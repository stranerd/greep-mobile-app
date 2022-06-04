import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:grip/application/transactions/transaction_summary.dart';
import 'package:grip/application/transactions/user_transactions_cubit.dart';
import 'package:grip/domain/transaction/TransactionData.dart';
import 'package:grip/domain/transaction/transaction.dart';
import 'package:meta/meta.dart';

part 'transaction_summary_state.dart';

class TransactionSummaryCubit extends Cubit<TransactionSummaryState> {
  final UserTransactionsCubit userTransactionsCubit;
  late StreamSubscription _streamSubscription;
  Map<String, List<Transaction>> _transactions = {};

  final Map<String, TransactionSummary> _today = {};
  final Map<String, TransactionSummary> _yesterday = {};

  TransactionSummaryCubit({required this.userTransactionsCubit})
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
    print("calculating statistics");
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    Duration day = const Duration(days: 1);
    DateTime yesterday = DateTime(
        now.subtract(day).year, now.subtract(day).month, now.subtract(day).day);

    _transactions.forEach((key, value) {
      // calculate today
      _today[key] = calculate(key, today, now);

      // calculate yesterday
      _yesterday[key] = calculate(key, yesterday, today);
    });
  }

  TransactionSummary calculate(String userId, DateTime from, DateTime to) {
    if (_transactions[userId] == null || _transactions[userId]!.isEmpty) {
      return TransactionSummary.Zero();
    }
    List<Transaction> transactions = _transactions[userId]!;


    late TransactionSummary transactionSummary;

    var filteredTrans = transactions.where((element) {
      return from.isBefore(element.timeCreated) &&
          to.isAfter(element.timeCreated);
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
        TransactionSummary(amount: amount, trips: trips, expenses: expenses);
    return transactionSummary;
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

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
