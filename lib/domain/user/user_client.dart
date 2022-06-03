import 'dart:io';

import 'package:dio/dio.dart';
import 'package:grip/application/dio_config.dart';
import 'package:grip/application/response.dart';
import 'package:grip/domain/user/model/User.dart';

class UserClient {
  final Dio dio = dioClient();

  Future<ResponseEntity<User>> fetchUser(String userId) async {
    print("fetching user $userId");
    Response response;
    try {
      response = await dio.get("users/users/$userId");
      print("response from user fetch ${response.data}");
      return ResponseEntity.Data(
          User.fromServer(response.data));
    } on DioError catch (e) {
      print("DioError: ${e.error} and ${e.response}");

      if (e.type == DioErrorType.connectTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      dynamic error = e.response!.data;
      String message = "";
      if (error == null) {
        message = "An error occurred logging you in. Try again";
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
          "An error occurred logging you in. Try again");
    }
  }

}
