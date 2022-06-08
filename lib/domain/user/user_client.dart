import 'dart:io';

import 'package:dio/dio.dart';
import 'package:grip/application/dio_config.dart';
import 'package:grip/application/response.dart';
import 'package:grip/domain/user/model/User.dart';

class UserClient {
  final Dio dio = dioClient();

  Future<ResponseEntity<User>> fetchUser() async {
    Response response;
    try {
      response = await dio.get("auth/user");
      return ResponseEntity.Data(
          User.fromServerAuth(response.data));
    } on DioError catch (e) {

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
