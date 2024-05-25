import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greep/application/order/single_order_state.dart';
import 'package:greep/domain/order/order_service.dart';


class SingleOrderCubit extends Cubit<SingleOrderState> {
  final OrderService orderService;

  SingleOrderCubit({
    required this.orderService,
  }) : super(SingleOrderStateUninitialized());

  Future<void> fetchSingleOrder({
    required String requestId,
    bool fullRefresh = false,
  }) async {
      emit(SingleOrderStateLoading());

        var response = await orderService.fetchSingleOrder(
          orderId: requestId,
        );
      if (response.isError) {
        var stateError = SingleOrderStateError(
          response.errorMessage,
          isConnectionTimeout: response.isConnectionTimeout,
          isSocket: response.isSocket,
        );
        emit(
          stateError,
        );
      } else {
        var stateFetched = SingleOrderStateFetched(order: response.data!);

        emit(stateFetched);
      }

  }

}
