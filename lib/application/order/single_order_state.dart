


import 'package:greep/domain/order/order.dart';

abstract class SingleOrderState {}

class SingleOrderStateUninitialized extends SingleOrderState {}

class SingleOrderStateLoading extends SingleOrderState {}

class SingleOrderStateFetched extends SingleOrderState {
  final UserOrder order;

  SingleOrderStateFetched({required this.order,});
}

class SingleOrderStateError extends SingleOrderState {
  final String? errorMessage;
  bool isConnectionTimeout;
  bool isSocket;
  Map<String, dynamic> fieldErrors;

  SingleOrderStateError(this.errorMessage,
      {this.isConnectionTimeout = false,
        this.isSocket = false,
        this.fieldErrors = const {}});
}
