import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grip/application/transactions/user_transactions_cubit.dart';
import 'package:grip/domain/customer/customer.dart';
import 'package:grip/domain/customer/customer_service.dart';

part 'user_customers_state.dart';
class UserCustomersCubit extends Cubit<UserCustomersState> {
  final CustomerService customerService;
  bool hasFetched = false;
  List<Customer> customers = [];
  final UserTransactionsCubit transactionsCubit;
  late StreamSubscription _streamSubscription;

  UserCustomersCubit({
    required this.customerService,
    required this.transactionsCubit,
  }) : super(UserCustomersStateUninitialized()) {
    _streamSubscription = transactionsCubit.stream.listen((event) {
      if (event is UserTransactionsStateFetched) {
        fetchUserCustomers(softUpdate: true);
      }
    });
  }

  void fetchUserCustomers(
      {bool fullRefresh = false, bool softUpdate = true}) async {
    if (!softUpdate) {
      emit(UserCustomersStateLoading());
    }
    if (hasFetched == true && !fullRefresh && !softUpdate) {
      emit(UserCustomersStateFetched(customers));
      return;
    }

    var response = await customerService.getCustomers();

    if (response.isError) {
      emit(UserCustomersStateError(
        response.errorMessage,
        isConnectionTimeout: response.isConnectionTimeout,
        isSocket: response.isSocket,
      ));
    } else {
      customers = response.data!;
      hasFetched = true;
      emit(UserCustomersStateFetched(customers));
    }
  }


  void destroy() {
    hasFetched = false;
    customers.clear();
    emit(UserCustomersStateUninitialized());
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
