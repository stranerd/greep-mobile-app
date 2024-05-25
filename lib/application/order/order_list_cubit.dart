import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greep/domain/order/order.dart';
import 'package:greep/domain/order/order_service.dart';
import 'package:greep/domain/product/product.dart';

part 'order_list_state.dart';

class OrderListCubit extends Cubit<OrderListState> {
  final OrderService orderService;

  OrderListCubit({
    required this.orderService,
  }) : super(OrderListStateInitial());

  Future<void> fetchUserOrders({bool softUpdate = false,bool? isActive }) async {
    if (!softUpdate || state is! OrderListStateFetched) {
      emit(OrderListStateLoading());
    }
    var result = await orderService.fetchUserOrders(isActive: isActive);

    if (result.isError) {
      emit(
        OrderListStateError(
          result.errorMessage,
        ),
      );
    } else {
      emit(
        OrderListStateFetched(
          orders: result.data!,
        ),
      );
    }
  }
  Future<void> fetchNewOrders({bool softUpdate = false, }) async {
    if (!softUpdate || state is! OrderListStateFetched) {
      emit(OrderListStateLoading());
    }
    var result = await orderService.fetchNewOrders();

    if (result.isError) {
      emit(
        OrderListStateError(
          result.errorMessage,
        ),
      );
    } else {
      emit(
        OrderListStateFetched(
          orders: result.data!,
        ),
      );
    }
  }
}
