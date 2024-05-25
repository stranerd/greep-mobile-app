part of 'order_crud_cubit.dart';

@immutable
abstract class OrderCrudState {}

class OrderCrudStateInitial extends OrderCrudState {}

class OrderCrudStateLoading extends OrderCrudState {
  final bool isAccept;
  final bool isComplete;

  OrderCrudStateLoading({
    this.isAccept = false,
    this.isComplete = false,
  });
}

class OrderCrudStateAssignedDriver extends OrderCrudState {
  final UserOrder response;

  OrderCrudStateAssignedDriver({
    required this.response,
  });
}

class OrderCrudStateCompleteOrder extends OrderCrudState {
  final UserOrder response;

  OrderCrudStateCompleteOrder({
    required this.response,
  });
}

class OrderCrudStateSuccess extends OrderCrudState {
  OrderCrudStateSuccess();
}

class OrderCrudStateMarkPaid extends OrderCrudState {
  OrderCrudStateMarkPaid();
}
class OrderCrudStateError extends OrderCrudState {
  final String? errorMessage;
  bool isConnectionTimeout;
  bool isSocket;
  Map<String, dynamic> fieldErrors;

  OrderCrudStateError(this.errorMessage,
      {this.isConnectionTimeout = false,
      this.isSocket = false,
      this.fieldErrors = const {}});
}
