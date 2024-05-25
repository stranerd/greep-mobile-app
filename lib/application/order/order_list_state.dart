part of 'order_list_cubit.dart';

@immutable
abstract class OrderListState {}

class OrderListStateInitial extends OrderListState {}

class OrderListStateFetched extends OrderListState {

  final List<UserOrder> orders;

  OrderListStateFetched({required this.orders});

  Map<String, dynamic> toMap() {
    return {
      'products': this.orders,
    };
  }


  @override
  String toString() {
    return 'OrderListStateFetched{products: $orders}';
  }
}


class OrderListStateLoading extends OrderListState {}


class OrderListStateError extends OrderListState {
  final String? errorMessage;
  bool isConnectionTimeout;
  bool isSocket;

  OrderListStateError(this.errorMessage,
      {this.isConnectionTimeout = false, this.isSocket = false});
}
