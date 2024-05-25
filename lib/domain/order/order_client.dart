import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:greep/application/dio_config.dart';
import 'package:greep/application/order/request/accept_order_request.dart';
import 'package:greep/application/order/request/assign_order_request.dart';
import 'package:greep/application/order/request/complete_order_request.dart';
import 'package:greep/application/order/response/order_checkout_price_response.dart';
import 'package:greep/application/response.dart';
import 'package:greep/application/user/user_util.dart';
import 'package:greep/domain/order/order.dart';

class OrderClient {
  final Dio dio = dioClient();

  Future<ResponseEntity<List<UserOrder>>> fetchUserOrders(
      {bool? isActive}) async {
    print("fetching orders ${isActive} ");
    Response response;
    try {
      List wjere = [
        {
          "field": "driverId",
          "value": getUser().id,
        },
        if (isActive != null)
          {
            "field": "done",
            "value": !isActive,
          },
      ];

      Map<String, dynamic> map = {"where": jsonEncode(wjere), "all": "true"};
      response = await dio.get("marketplace/orders", queryParameters: map);
      List<UserOrder> orders = [];

      // print("response orders ${response.data} ");

      response.data["results"].forEach((e) {
        orders.add(UserOrder.fromMap(e));
      });

      return ResponseEntity.Data(orders);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
        dynamic error = e.response!.data;
        String message = "";
        if (error == null) {
          message = "An error occurred fetching orders";
        } else {
          message = error[0]?["message"] ?? "";
        }
        return ResponseEntity.Error(message);
      }
      return ResponseEntity.Error("An error occurred fetching orders");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred fetching orders. Try again");
    }
  }


  Future<ResponseEntity<UserOrder>> fetchSingleOrder(
      {required String orderId}) async {
    print("fetching single order ${orderId} ");
    Response response;
    try {
      response = await dio.get("marketplace/orders/$orderId",);

      // print("response orders ${response.data} ");


      return ResponseEntity.Data(UserOrder.fromMap(response.data,),);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
        dynamic error = e.response!.data;
        String message = "";
        if (error == null) {
          message = "An error occurred fetching single order";
        } else {
          message = error[0]?["message"] ?? "";
        }
        return ResponseEntity.Error(message);
      }
      return ResponseEntity.Error("An error occurred fetching single order");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred fetching single order. Try again");
    }
  }
  Future<ResponseEntity<List<UserOrder>>> fetchNewOrders() async {
    print("fetching new orders ");
    Response response;
    try {
      Map<String,dynamic> query = {};
        query = {
          "where[]": jsonEncode({
            "field": "driverId",
            "value": null,
          }),
          "all": "true"
        };
      response = await dio.get(
        "marketplace/orders",
        queryParameters: query,
      );
      List<UserOrder> orders = [];

      print("response new orders ${response.data} ");

      response.data["results"].forEach((e) {
        orders.add(UserOrder.fromMap(e));
      });

      return ResponseEntity.Data(orders);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
        dynamic error = e.response!.data;
        String message = "";
        if (error == null) {
          message = "An error occurred fetching orders";
        } else {
          message = error[0]?["message"] ?? "";
        }
        return ResponseEntity.Error(message);
      }
      return ResponseEntity.Error("An error occurred fetching orders");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred fetching orders. Try again");
    }
  }


  Future<ResponseEntity<UserOrder>> acceptOrder(
      {required AcceptOrderRequest request}) async {
    print("Accepting order ${request.toMap()}");
    Response response;
    try {
      response = await dio.post(
        "marketplace/orders/${request.orderId}/accept",
        data: request.toJson()
      );

      print("response orders ${response.data} ");

      return ResponseEntity.Data(UserOrder.fromMap(response.data));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
        print(
            "Error from order acceptance ${e.response?.statusCode} ${e.response?.data}");

        dynamic error = e.response!.data;
        String message = "";
        if (error == null) {
          message = "An error occurred canceling order";
        } else {
          message = error[0]?["message"] ?? "";
        }
        return ResponseEntity.Error(message);
      }
      return ResponseEntity.Error("An error occurred accepting order");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred accepting order. Try again");
    }
  }

  Future<ResponseEntity<UserOrder>> assignOrder(
      {required AssignOrderRequest request}) async {
    print("Assigning order ${request.toMap()}");
    Response response;
    try {
      response = await dio.post(
        "marketplace/orders/${request.orderId}/assignDriver",
      );

      print("response orders ${response.data} ");

      return ResponseEntity.Data(UserOrder.fromMap(response.data));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
        print(
            "Error from order assigning ${e.response?.statusCode} ${e.response?.data}");

        dynamic error = e.response!.data;
        String message = "";
        if (error == null) {
          message = "An error occurred canceling order";
        } else {
          message = error[0]?["message"] ?? "";
        }
        return ResponseEntity.Error(message);
      }
      return ResponseEntity.Error("An error occurred accepting order");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred accepting order. Try again");
    }
  }

  Future<ResponseEntity> markOrderPaid({required String orderId,}) async {
    print("mark order shipped ${orderId}");
    Response response;
    try {
      response = await dio.post("marketplace/orders/$orderId/markPaid",);

      print("mark order shipped ${response.data}");

      return ResponseEntity.Data(null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
        print("Error wallet payment ${e.response?.data } ${e.response?.statusCode}");
        dynamic error = e.response!.data;
        String message = "";
        if (error == null) {
          message = "An error occurred accepting payment for order";
        } else {
          try {
            message = error?["message"] ?? "";}
          catch (_){
            return ResponseEntity.Error("An error occurred accepting payment for order");

          }
        }
        return ResponseEntity.Error(message);
      }
      return ResponseEntity.Error("An error occurred accepting payment for order");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred accepting payment for order. Try again");
    }
  }


  Future<ResponseEntity<UserOrder>> completeDelivery(
      {required CompleteOrderRequest request}) async {
    print("completing order ${request.toMap()}");
    Response response;
    try {
      response = await dio.post(
          "marketplace/orders/${request.orderId}/complete",
          data: request.toJson()
      );

      print("response orders ${response.data} ");

      return ResponseEntity.Data(UserOrder.fromMap(response.data));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
        print(
            "Error from order completion ${e.response?.statusCode} ${e.response?.data}");

        dynamic error = e.response!.data;
        String message = "";
        if (error == null) {
          message = "An error occurred completing order";
        } else {
          message = error[0]?["message"] ?? "";
        }
        return ResponseEntity.Error(message);
      }
      return ResponseEntity.Error("An error occurred completing order");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred completing order. Try again");
    }
  }
  Future<ResponseEntity<UserOrder>> cancelOrder(
      {required String orderId}) async {
    Response response;
    try {
      response = await dio.post(
        "marketplace/orders/${orderId}/cancel",
      );

      print("response orders ${response.data} ");

      return ResponseEntity.Data(UserOrder.fromMap(response.data));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
        print(
            "Error from checkout price ${e.response?.statusCode} ${e.response?.data}");

        dynamic error = e.response!.data;
        String message = "";
        if (error == null) {
          message = "An error occurred canceling order";
        } else {
          message = error[0]?["message"] ?? "";
        }
        return ResponseEntity.Error(message);
      }
      return ResponseEntity.Error("An error occurred canceling order");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred canceling order. Try again");
    }
  }
}
