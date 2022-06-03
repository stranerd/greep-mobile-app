import 'dart:io';

import 'package:dio/dio.dart';
import 'package:grip/application/auth/request/LoginRequest.dart';
import 'package:grip/application/auth/request/SignupRequest.dart';
import 'package:grip/application/response.dart';
import 'package:grip/domain/api.dart';


class AuthenticationClient {
  Future<ResponseEntity<Map<String, dynamic>>> login(
      LoginRequest request,) async {
    print(request);
    final Dio dio = Dio();
    Response response;
    try {
      response = await dio.post(
        "${baseApi}auth/emails/signin",
        data: request.toJson(),
      );

        return ResponseEntity.Data(
            {"id": response.data["user"]["id"], "token": response.data["accessToken"],});

    } on DioError catch (e) {
      print(e.type);
      if (e.type == DioErrorType.connectTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioErrorType.response) {
        print(e.response!.data);
        return ResponseEntity.Error(
            e.response!.data[0]["message"] ?? "Incorrect Credentials");
      }

      return ResponseEntity.Error("Incorrect credentials");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred logging you in. Try again");
    }
  }

  Future<ResponseEntity<Map<String, dynamic>>> signup(
      SignUpRequest request) async {
    final Dio dio = Dio();
    Response response;
    try {
      response = await dio.post(
        "${baseApi}auth/emails/signup",
        data: request.toJson(),
      );

        return ResponseEntity.Data(
            {"id": response.data["user"]["id"], "token": response.data["accessToken"], });

    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        print("connectionTimeout");
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioErrorType.response) {

        return ResponseEntity.Error(
            e.response!.data["message"] ?? "An error occurred in sign up");
      }

      return ResponseEntity.Error("An error occurred ");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred signing you up in. Try again");
    }
  }
}
