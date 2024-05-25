import 'package:greep/application/order/request/assign_order_request.dart';
import 'package:greep/application/order/request/complete_order_request.dart';
import 'package:greep/application/order/response/order_checkout_price_response.dart';
import 'package:greep/application/response.dart';
import 'package:greep/domain/order/order.dart';
import 'package:greep/domain/order/order_client.dart';

class OrderService {
  final OrderClient orderClient;


  OrderService({required this.orderClient});

  Future<ResponseEntity<List<UserOrder>>> fetchUserOrders({ bool? isActive,}) async {
    var responseEntity = await orderClient.fetchUserOrders(isActive: isActive);
    if (!responseEntity.isError){
      responseEntity.data!.sort((a,b) => b.date.compareTo(a.date));
    }
    return responseEntity;
  }
  Future<ResponseEntity<UserOrder>> fetchSingleOrder(
      {required String orderId}) async {
    return await orderClient.fetchSingleOrder(orderId: orderId,);
  }

  Future<ResponseEntity<List<UserOrder>>> fetchNewOrders() async {
    var responseEntity = await orderClient.fetchNewOrders();
    if (!responseEntity.isError){
      responseEntity.data!.sort((a,b) => b.date.compareTo(a.date));
    }
    return responseEntity;
  }

  Future<ResponseEntity<UserOrder>> completeDelivery(
      {required CompleteOrderRequest request}) async {
    return await orderClient.completeDelivery(request: request);
  }

  Future<ResponseEntity<UserOrder>> assignOrder(
      {required AssignOrderRequest request}) async {
    return await orderClient.assignOrder(request: request);
  }

  Future<ResponseEntity> markOrderPaid({required String orderId,}) async {
  return await orderClient.markOrderPaid(orderId: orderId,);

  }

  Future<ResponseEntity<UserOrder>> cancelOrder(
      {required String orderId}) async {
    return orderClient.cancelOrder(orderId: orderId);

  }

}
