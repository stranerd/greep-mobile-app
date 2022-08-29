import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/auth/AuthenticationCubit.dart';
import 'package:grip/application/auth/AuthenticationState.dart';
import 'package:grip/application/driver/drivers_cubit.dart';
import 'package:grip/application/transactions/response/customer_summary.dart';
import 'package:grip/application/transactions/user_transactions_cubit.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/application/user/utils/get_current_user.dart';
import 'package:grip/domain/transaction/TransactionData.dart';
import 'package:grip/domain/transaction/transaction.dart';
import 'package:meta/meta.dart';

part 'customer_statistics_state.dart';

class CustomerStatisticsCubit extends Cubit<CustomerStatisticsState> {
  final UserTransactionsCubit transactionsCubit;

  final AuthenticationCubit authenticationCubit;

  late StreamSubscription _streamSubscription;

  final DriversCubit driversCubit;

  late StreamSubscription _authSubscription;

  Map<String, List<Transaction>> _transactions = {};

  Map<String, List<Transaction>> _customerTransactions = {};

  Map<String, List<Transaction>> get customerTransactions =>
      _customerTransactions;

  CustomerStatisticsCubit(
      {required this.transactionsCubit,
      required this.driversCubit,
      required this.authenticationCubit})
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
    emit(CustomerStatisticsStateLoading());
    _customerTransactions = _transactions.map((key, value) => MapEntry(
        key,
        value
            .where((element) =>
                element.data.transactionType == TransactionType.trip)
            .toList()));
    emit(CustomerStatisticsStateDone());
  }

  List<Transaction> getCustomerTransactions({String type = "none"}) {
    String userId = driversCubit.selectedUser.id;
    if (_customerTransactions[userId] == null ||
        _customerTransactions[userId]!.isEmpty) {
      return [];
    }
    Map<String, Transaction> trans = {};

    List<Transaction> filteredTransactions = [..._customerTransactions[userId]!];
    if (type.toLowerCase() == "collect") {
      filteredTransactions.removeWhere((element) => element.debt <= 0);
    }
    else if (type.toLowerCase() == "pay"){
      filteredTransactions.removeWhere((element) => element.debt >= 0);
    }

    else if (type.toLowerCase() == "not balanced"){
      filteredTransactions.removeWhere((element) {
        return element.debt == 0;
      });
    }



    else if (type.toLowerCase() == "balance"){
      filteredTransactions.removeWhere((element) {
        return element.debt != 0;
      });
    }

    for (var element in filteredTransactions) {
      var customerName = element.data.customerName!.toLowerCase().trim();
      if (trans[customerName] == null) {
        trans.putIfAbsent(customerName, () => element);
      }
    }

    return trans.values.toList();
  }

  List<Transaction> getDebtTransactions(
      {required bool toPay, required bool toCollect, required String customer}) {
    List<Transaction> trans = [];
    String userId = GetIt.I<UserCubit>().userId!;
    if (_customerTransactions[userId] == null ||
        _customerTransactions[userId]!.isEmpty) {
      return [];
    } else {
      trans = [..._customerTransactions[userId]!.where((element) => element.data.customerName!.toLowerCase() == customer.toLowerCase())];
    }
    // for (var element in trans) {
    //   print(element);
    // }

    if (!toPay && !toCollect) {
      return const [];
    }

    if (toPay && !toCollect) {
      trans = trans.where((element) {
        return element.debt < 0;
      }).toList();

    } else if (!toPay && toCollect) {
      trans = trans.where((element) {
        return element.debt > 0;
      }).toList();

    } else {
      trans = trans.where((element) {
        return element.debt!=0;
      }).toList();
    }
    return trans;
  }

  Transaction? getByParentBalance(String parentId) {
    String userId = driversCubit.selectedUser.id;
    if (_customerTransactions[userId] == null ||
        _customerTransactions[userId]!.isEmpty) {
      return null;
    }
    List<Transaction> transactions = _customerTransactions[userId]!;
    Transaction? transaction =
        transactions.firstWhereOrNull((element) => element.id == parentId);
    return transaction;
  }

  CustomerSummary getCustomerSummary(String name) {
    String userId = driversCubit.selectedUser.id;
    if (_customerTransactions[userId] == null ||
        _customerTransactions[userId]!.isEmpty) {
      return CustomerSummary.Zero(name);
    }
    List<Transaction> _transactions = _customerTransactions[userId]!;
    List<Transaction> _custTransactions = _transactions
        .where((e) =>
            e.data.transactionType == TransactionType.trip &&
            e.data.customerName!.toLowerCase() == name.toLowerCase())
        .toList();

    var toPayList = _custTransactions.where((element) => element.debt < 0);
    var toCollectList = _custTransactions.where((element) => element.debt > 0);
    return CustomerSummary(
      name: name,
      totalPaid: _custTransactions
          .map((e) => e.amount)
          .reduce((value, element) => value + element),
      toPay: toPayList.isEmpty ? 0 : toPayList.map((e) => e.debt).reduce((value, element) {
        value = value;
        element = element;
        return element + value;
      }),
      transactions: _custTransactions,
      toCollect:
          toCollectList.isEmpty ? 0 : toCollectList.map((e) => e.debt).reduce((value, element) {
        value = value;
        element = element;
        return element + value;
      }),
    );
  }

  List<String> getUserCustomers() {
    String userId = currentUser().id;
    if (_customerTransactions[userId] == null ||
        _customerTransactions[userId]!.isEmpty) {
      return [];
    }
    Set<String> customerNames =
        _customerTransactions[userId]!.map((e) => e.data.customerName!).toSet();
    return customerNames.toList();
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
