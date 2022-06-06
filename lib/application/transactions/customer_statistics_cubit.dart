import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:grip/application/auth/AuthenticationCubit.dart';
import 'package:grip/application/auth/AuthenticationState.dart';
import 'package:grip/application/transactions/response/customer_summary.dart';
import 'package:grip/application/transactions/user_transactions_cubit.dart';
import 'package:grip/domain/transaction/TransactionData.dart';
import 'package:grip/domain/transaction/transaction.dart';
import 'package:meta/meta.dart';

part 'customer_statistics_state.dart';

class CustomerStatisticsCubit extends Cubit<CustomerStatisticsState> {
  final UserTransactionsCubit transactionsCubit;
  final AuthenticationCubit authenticationCubit;
  late StreamSubscription _streamSubscription;
  late StreamSubscription _authSubscription;
  Map<String, List<Transaction>> _transactions = {};

  Map<String, List<Transaction>> _customerTransactions = {};

  CustomerStatisticsCubit(
      {required this.transactionsCubit, required this.authenticationCubit})
      : super(CustomerStatisticsInitial()) {
    _authSubscription = authenticationCubit.stream.listen((event) {
      if (event is AuthenticationStateNotAuthenticated) {
        destroy();
      }
    });
    _streamSubscription = transactionsCubit.stream.listen((event) {
      if (event is UserTransactionsStateFetched) {
        _transactions = transactionsCubit.transactions
            .map((key, value) => MapEntry(key, value.toList()));
        _calculateStatistics();
      }
    });
  }

  void _calculateStatistics() {
    _customerTransactions = _transactions.map((key, value) =>
        MapEntry(
            key,
            value.where((element) =>
            element.data.transactionType == TransactionType.trip ||
                element.data.transactionType == TransactionType.balance)
                .toList()));
  }

  List<Transaction> getDebtTransactions(String userId) {
    if (_customerTransactions[userId] == null ||
        _customerTransactions[userId]!.isEmpty) {
      return [];
    }
    return _customerTransactions[userId]!.toList();
  }

  Transaction? getByParentBalance(String userId, String parentId) {
    if (_customerTransactions[userId] == null ||
        _customerTransactions[userId]!.isEmpty) {
      return null;
    }
    List<Transaction> transactions = _customerTransactions[userId]!;
    Transaction? transaction = transactions.firstWhereOrNull((
        element) => element.id == parentId);
    return transaction;
  }

  CustomerSummary getCustomerSummary(String name, String userId) {
    if (_customerTransactions[userId] == null ||
        _customerTransactions[userId]!.isEmpty) {
      return CustomerSummary.Zero(name);
    }
    List<Transaction> _transactions = _customerTransactions[userId]!;
    List<Transaction> _custTransactions = _transactions.where((e) =>
    e.data.transactionType == TransactionType.trip &&
        e.data.customerName!.toLowerCase() == name.toLowerCase()).toList();

    return CustomerSummary(name: name,
        totalPaid: _custTransactions.map((e) => e.amount).reduce((value,
            element) => value + value),
        toCollect: _custTransactions.map((e) => e.data.debt).reduce((value,
            element) {
          value = value ?? 0;
          element = element ?? 0;
          return element + value;
        })!,
        transactions: _custTransactions,
        toPay: 0);
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    _authSubscription.cancel();
    return super.close();
  }

  void destroy() {
    _transactions.clear();
  }
}
