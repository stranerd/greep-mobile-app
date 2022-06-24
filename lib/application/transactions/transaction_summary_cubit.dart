import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/transactions/response/commission_summary.dart';
import 'package:grip/application/transactions/transaction_crud_cubit.dart';
import 'package:grip/application/transactions/response/transaction_summary.dart';
import 'package:grip/application/transactions/user_transactions_cubit.dart';
import 'package:grip/application/driver/drivers_cubit.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/application/user/utils/get_current_user.dart';
import 'package:grip/domain/transaction/TransactionData.dart';
import 'package:grip/domain/transaction/transaction.dart';
import 'package:meta/meta.dart';

part 'transaction_summary_state.dart';

class TransactionSummaryCubit extends Cubit<TransactionSummaryState> {
  final UserTransactionsCubit userTransactionsCubit;

  late StreamSubscription _streamSubscription;

  Map<String, List<Transaction>> _transactions = {};

  final DriversCubit driversCubit;

  final Map<String, TransactionSummary> _today = {};

  final Map<String, TransactionSummary> _yesterday = {};

  TransactionSummaryCubit({required this.userTransactionsCubit, required this.driversCubit})
      : super(TransactionSummaryInitial()) {
    _streamSubscription = userTransactionsCubit.stream.listen((event) {
      if (event is UserTransactionsStateFetched) {
        _transactions = userTransactionsCubit.transactions
            .map((key, value) => MapEntry(key, value.toList()));
        _calculateStatistics();
      }
    });
  }

  void _calculateStatistics() {
    emit(TransactionSummaryStateLoading());
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    Duration day = const Duration(days: 1);
    DateTime yesterday = DateTime(
        now.subtract(day).year, now.subtract(day).month, now.subtract(day).day);

    _transactions.forEach((key, value) {
      // calculate today
      _today[key] = _calculate(key, today, now);

      // calculate yesterday
      _yesterday[key] = _calculate(key, yesterday, today);
    });
    emit(TransactionSummaryStateDone());
  }

  TransactionSummary _calculate(String userId, DateTime from, DateTime to) {
    if (_transactions[userId] == null || _transactions[userId]!.isEmpty) {
      return TransactionSummary.Zero();
    }
    List<Transaction> transactions = _transactions[userId]!;

    late TransactionSummary transactionSummary;

    var filteredTrans = transactions.where((element) {
      return from.isBefore(element.timeAdded) &&
          to.isAfter(element.timeAdded);
    }).toList();

    num amount = filteredTrans.isNotEmpty
        ? filteredTrans
            .map((e) => e.amount)
            .reduce((value, element) => value + element)
        : 0;
    num trips = filteredTrans.isNotEmpty
        ? filteredTrans
            .map((e) => e.data)
            .where((element) => element.transactionType == TransactionType.trip)
            .length
        : 0;
    num expenses = filteredTrans.isNotEmpty
        ? filteredTrans
            .map((e) => e.data)
            .where(
                (element) => element.transactionType == TransactionType.expense)
            .length
        : 0;
    transactionSummary =
        TransactionSummary(amount: amount, trips: trips, expenses: expenses, transactions: filteredTrans);
    return transactionSummary;
  }

  CommissionSummary _calculateCommission(num commission, List<Transaction> transactions, DateTime from, DateTime to){
    var expenses = transactions.where((element) => element.data.transactionType == TransactionType.expense);
    num totalExpenses = expenses.isEmpty ? 0 : expenses.map((e) => e.amount).reduce((value, element) => value + element);
    var trips = transactions.where((element) => element.data.transactionType == TransactionType.trip);
    num totalIncome = trips.isEmpty  ? 0 : trips.map((e) => e.amount).reduce((value, element) => value + element);
    return CommissionSummary(commission: totalExpenses > totalIncome ? 0 : (totalIncome - totalExpenses) * commission, transactions: transactions);

  }

  TransactionSummary todaySummary(String userId) {
    if (_today[userId] == null) {
      return TransactionSummary.Zero();
    }
    return _today[userId]!;
  }

  TransactionSummary yesterdaySummary(String userId) {
    print(userId);
    print(_yesterday[userId]);
    if (_yesterday[userId] == null) {
      return TransactionSummary.Zero();
    }
    return _yesterday[userId]!;
  }

  TransactionSummary totalSummary(){
    String userId = getSelectedUserId();
    if (_transactions[userId] == null || _transactions[userId]!.isEmpty) {
      return TransactionSummary.Zero();
    }
    List<Transaction> trans = _transactions[userId]!;

    return TransactionSummary(
        amount: trans
            .map((e) => e.amount)
            .reduce((value, element) => element + value),
        trips: trans
            .map((e) => e.data)
            .where((element) =>
        element.transactionType == TransactionType.trip)
            .length,
        expenses: trans
            .map((e) => e.data)
            .where((element) =>
        element.transactionType == TransactionType.expense)
            .length,
        transactions: trans);

  }

  TransactionSummary calculateInterval(DateTime from, DateTime to){
    return _calculate(getSelectedUserId(), from, to);
  }

  Map<DateTime, TransactionSummary> getDailyTransactions(){
    String userId = getSelectedUserId();
    if (_transactions[userId] == null || _transactions[userId]!.isEmpty) {
      return {DateTime.now(): TransactionSummary.Zero()};
    }
    Map<DateTime, TransactionSummary> map = {};
    for (var element in _transactions[userId]!) {
      map.putIfAbsent(DateTime(element.timeAdded.year, element.timeAdded.month, element.timeAdded.day),
              () {
            List<Transaction> trans = _transactions[userId]!
                .where((e) =>
            e.timeAdded.year == element.timeAdded.year &&
                element.timeAdded.month == e.timeAdded.month && element.timeAdded.day == e.timeAdded.day)
                .toList();
            return TransactionSummary(
                amount: trans
                    .map((e) => e.amount)
                    .reduce((value, element) => element + value),
                trips: trans
                    .map((e) => e.data)
                    .where((element) =>
                element.transactionType == TransactionType.trip)
                    .length,
                expenses: trans
                    .map((e) => e.data)
                    .where((element) =>
                element.transactionType == TransactionType.expense)
                    .length,
                transactions: trans);
          });
    }

    return map;
  }

  Map<DateTime, CommissionSummary> getManagedDailyCommissions(){
    String userId = currentUser().id;
    var userTransactions = _transactions[userId] ?? const [];
    if (userTransactions.isEmpty) {
      return {DateTime.now(): CommissionSummary.Zero()};
    }
    if (!currentUser().hasManager){
      return {DateTime.now(): CommissionSummary.Zero()};
    }
    num commission = currentUser().commission??0;
    Map<DateTime, CommissionSummary> map = {};
    for (var element in userTransactions) {
      map.putIfAbsent(DateTime(element.timeAdded.year, element.timeAdded.month, element.timeAdded.day),
              () {
            List<Transaction> trans = userTransactions
                .where((e) =>
            e.timeAdded.year == element.timeAdded.year &&
                element.timeAdded.month == e.timeAdded.month && element.timeAdded.day == e.timeAdded.day)
                .toList();
            Duration day = const Duration(days: 1);
            return _calculateCommission(commission, trans, DateTime(element.timeAdded.add(day).year, element.timeAdded.add(day).month, element.timeAdded.add(day).day,), DateTime(element.timeAdded.year, element.timeAdded.month, element.timeAdded.day));
          });
    }

    return map;
  }

  Map<DateTime, CommissionSummary> getManagedMonthlyCommissions() {
    String userId = currentUser().id;
    var userTransactions = _transactions[userId] ?? const [];
    if (userTransactions.isEmpty) {
      return {DateTime.now(): CommissionSummary.Zero()};
    }
    if (!currentUser().hasManager){
      return {DateTime.now(): CommissionSummary.Zero()};
    }
    num commission = currentUser().commission??0;
    Map<DateTime, CommissionSummary> map = {};
    for (var element in userTransactions) {
      map.putIfAbsent(DateTime(element.timeAdded.year, element.timeAdded.month),
              () {
            List<Transaction> trans = userTransactions
                .where((e) =>
            e.timeAdded.year == element.timeAdded.year &&
                element.timeAdded.month == e.timeAdded.month)
                .toList();
            Duration day = const Duration(days: 1);
            return _calculateCommission(commission, trans, DateTime(element.timeAdded.add(day).year, element.timeAdded.add(day).month), DateTime(element.timeAdded.year, element.timeAdded.month));
          });
    }

    return map;
  }


  Map<DateTime, TransactionSummary> getMonthlyTransactions() {
    String userId = getSelectedUserId();
    if (_transactions[userId] == null || _transactions[userId]!.isEmpty) {
      return {DateTime.now(): TransactionSummary.Zero()};
    }
    Map<DateTime, TransactionSummary> map = {};
    for (var element in _transactions[userId]!) {
      map.putIfAbsent(DateTime(element.timeAdded.year, element.timeAdded.month),
          () {
        List<Transaction> trans = _transactions[userId]!
            .where((e) =>
                e.timeAdded.year == element.timeAdded.year &&
                element.timeAdded.month == e.timeAdded.month)
            .toList();
        return TransactionSummary(
            amount: trans
                .map((e) => e.amount)
                .reduce((value, element) => element + value),
            trips: trans
                .map((e) => e.data)
                .where((element) =>
                    element.transactionType == TransactionType.trip)
                .length,
            expenses: trans
                .map((e) => e.data)
                .where((element) =>
                    element.transactionType == TransactionType.expense)
                .length,
            transactions: trans);
      });
    }

    return map;
  }

  List<Transaction> filterTransactions(DateTime from, DateTime to) {
    String userId = getSelectedUserId();
    if (_transactions[userId] == null || _transactions[userId]!.isEmpty) {
      return [];
    }

    return _calculate(userId, from, to).transactions;

  }

  String getSelectedUserId() => driversCubit.selectedUser.id;

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }

}
