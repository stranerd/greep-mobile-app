import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:greep/application/dio_config.dart';
import 'package:greep/application/response.dart';
import 'package:greep/domain/auth/AuthenticationService.dart';
import 'package:greep/domain/customer/customer.dart';

class CustomerClient {
  final dio = dioClient();

  Future<ResponseEntity<List<Customer>>> getCustomers() async {
    Response response;
    try {
      response = await dio.get("users/customers");
      List<Customer> drivers = [];
      if (response.data["results"]==null || response.data["results"].isEmpty){
        return ResponseEntity.Data(const []);
      }

      response.data["results"].forEach((e) {
        drivers.add(Customer.fromServer(e));
      });

      return ResponseEntity.Data(drivers);
    } on DioError catch (e) {

      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
        try {
          if (e.response!.data[0]["message"]
              .toString()
              .toLowerCase()
              .contains("access token")) {
            print("refreshing token");
            var response =
            await GetIt.I<AuthenticationService>().refreshToken();
            if (response.isError) {
              return ResponseEntity.Error(
                  "An error occurred, please log in again");
            } else {
              return getCustomers();
            }
          }
        } catch (_) {}
      }
      dynamic error = e.response!.data;
      String message = "";
      if (error == null) {
        message = "An error occurred fetching customers. Try again";
      } else {
        try {
          message = error["message"];
        }
        catch (e) {
          message = "an error occurred. Try again";
        }
      }
      return ResponseEntity.Error(message);
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred fetching customers. Try again");
    }
  }
}
