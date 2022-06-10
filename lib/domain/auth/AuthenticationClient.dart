import 'dart:io';

import 'package:dio/dio.dart';
import 'package:grip/application/auth/request/LoginRequest.dart';
import 'package:grip/application/auth/request/SignupRequest.dart';
import 'package:grip/application/dio_config.dart';
import 'package:grip/application/response.dart';
import 'package:http/http.dart' as http;
import 'package:grip/domain/api.dart';


class AuthenticationClient {
  Future<ResponseEntity<Map<String, dynamic>>> login(LoginRequest request,) async {
    final Dio dio = Dio();
    Response response;
    try {
      response = await dio.post(
        "${baseApi}auth/emails/signin",
        data: request.toJson(),
      );

        return ResponseEntity.Data(
            {"id": response.data["user"]["id"], "token": response.data["accessToken"],
              "refreshToken": response.data["refreshToken"], "password": request.password, "email": request.email

            });

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
    print(request.toString());
    Response response;
    try {
      response = await dio.post(
        "${baseApi}auth/emails/signup",
        data: request.toFormData(),
        options: Options(
          contentType: "multipart/form-data",
        ),
      );

        return ResponseEntity.Data(
            {"id": response.data["user"]["id"], "token": response.data["accessToken"],
              "refreshToken": response.data["refreshToken"]

            });

    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        print("connectionTimeout");
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioErrorType.response) {
        print(e.response!.data);

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

  Future<ResponseEntity> testSignup(LoginRequest request)async{
    final Dio dio = Dio();
    Response response;
    try {
      response = await dio.post(
        "${baseApi}auth/emails/signup",
        data: request.toJson(),
      );

      return ResponseEntity.Data(response.data);

    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        print("connectionTimeout");
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioErrorType.response) {
        Map<String,dynamic> fieldErrors = {};
        e.response!.data.forEach((e) {
          if (e["field"] == "email"){
            fieldErrors.putIfAbsent("email", () => e["message"]);
          }

          if (e["field"] == "password"){
            fieldErrors.putIfAbsent("password", () => e["message"]);

          }
        });
        return ResponseEntity.Error("Invalid fields",fieldErrors = fieldErrors);
      }

      return ResponseEntity.Error("An error occurred ");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred signing you up in. Try again");
    }
  }

  Future<ResponseEntity<Map<String,dynamic>>> refreshToken() async{
    final Dio dio = dioClient(useRefreshToken: true);
    Response response;
    try {
      response = await dio.post("auth/token",
      options: Options(
        headers: {

        }
      )
      );

      return ResponseEntity.Data(
          {"id": response.data["user"]["id"], "token": response.data["accessToken"],
          "refreshToken": response.data["refreshToken"]
          });

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
}
