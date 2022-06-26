part of 'user_customers_cubit.dart';

abstract class UserCustomersState {}

class UserCustomersStateUninitialized extends UserCustomersState {}

class UserCustomersStateLoading extends UserCustomersState {
  final bool isDelete;

  UserCustomersStateLoading({ this.isDelete = false});
}

class UserCustomersStateFetched extends UserCustomersState {
  final List<Customer> customers;
  final bool isError;
  final String errorMessage;
  final bool isDelete;

  UserCustomersStateFetched(this.customers, { this.isError = false, this.errorMessage="", this.isDelete = false});
}

class UserCustomersStateError extends UserCustomersState {
  final String? errorMessage;
  bool isConnectionTimeout;
  bool isSocket;
  Map<String, dynamic> fieldErrors;

  UserCustomersStateError(this.errorMessage,
      {this.isConnectionTimeout = false,
        this.isSocket = false,
        this.fieldErrors = const {}});
}
