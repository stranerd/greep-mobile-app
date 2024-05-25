import 'package:bloc/bloc.dart';
import 'package:greep/application/order/request/assign_order_request.dart';
import 'package:greep/application/order/request/complete_order_request.dart';
import 'package:greep/application/order/response/order_checkout_price_response.dart';
import 'package:greep/domain/order/order.dart';
import 'package:greep/domain/order/order_service.dart';
import 'package:meta/meta.dart';

part 'order_crud_state.dart';

class OrderCrudCubit extends Cubit<OrderCrudState> {
  final OrderService orderService;

  OrderCrudCubit({
    required this.orderService,
  }) : super(OrderCrudStateInitial());

  void assignDriver({required AssignOrderRequest request}) async {
    emit(
      OrderCrudStateLoading(
        isAccept: true,
      ),
    );

    var response = await orderService.assignOrder(
      request: request,
    );
    if (response.isError) {
      emit(OrderCrudStateError(response.errorMessage ?? "An error occurred"));
    } else {
      emit(
        OrderCrudStateAssignedDriver(
          response: response.data!,
        ),
      );
    }
  }

  void completeDelivery({required CompleteOrderRequest request}) async {
    emit(
      OrderCrudStateLoading(
        isComplete: true,
      ),
    );

    var response = await orderService.completeDelivery(
      request: request,
    );
    if (response.isError) {
      emit(OrderCrudStateError(response.errorMessage ?? "An error occurred"));
    } else {
      emit(
        OrderCrudStateCompleteOrder(
          response: response.data!,
        ),
      );
    }
  }

  void markOrderPaid(String orderId) async {
    emit(OrderCrudStateLoading());

    var response = await orderService.markOrderPaid(
      orderId: orderId,
    );
    if (response.isError) {
      emit(
        OrderCrudStateError(
          response.errorMessage ?? "An error occurred",
        ),
      );
    } else {
      emit(
        OrderCrudStateMarkPaid(),
      );
    }
  }

  void cancelOrder(String orderId) async {
    emit(OrderCrudStateLoading());

    var response = await orderService.cancelOrder(
      orderId: orderId,
    );
    if (response.isError) {
      emit(OrderCrudStateError(response.errorMessage ?? "An error occurred"));
    } else {
      emit(OrderCrudStateSuccess());
    }
  }
}
