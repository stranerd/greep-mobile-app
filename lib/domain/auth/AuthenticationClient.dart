import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:greep/application/auth/password/request/confirm_reset_pin_request.dart';
import 'package:greep/application/auth/password/request/create_transaction_pin_request.dart';
import 'package:greep/application/auth/request/AppleSigninRequest.dart';
import 'package:greep/application/auth/request/GoogleSigninRequest.dart';
import 'package:greep/application/auth/request/LoginRequest.dart';
import 'package:greep/application/auth/request/SignupRequest.dart';
import 'package:greep/application/dio_config.dart';
import 'package:greep/application/response.dart';
import 'package:http/http.dart' as http;
import 'package:greep/domain/api.dart';

class AuthenticationClient {
  Future<ResponseEntity<Map<String, dynamic>>> login(
    LoginRequest request,
  ) async {
    final Dio dio = Dio();
    Response response;
    try {
      response = await dio.post(
        "${baseApi}auth/emails/signin",
        data: request.toJson(),
      );

      print("sign in data ${response.data["user"]}");

      return ResponseEntity.Data({
        "id": response.data["user"]["id"],
        "token": response.data["accessToken"],
        "user": response.data["user"],
        "isVerified": response.data["user"]?["isVerified"],

        "refreshToken": response.data["refreshToken"],
        "password": request.password,
        "email": request.email
      });
    } on DioError catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
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

  Future<ResponseEntity<Map<String, dynamic>>> googleLogin(
      GoogleSigninRequest request) async {
    final Dio dio = Dio();
    Response response;
    try {
      response = await dio.post(
        "${baseApi}auth/identities/google",
        data: request.toJson(),
      );

      return ResponseEntity.Data({
        "id": response.data["user"]["id"],
        "token": response.data["accessToken"],
        "refreshToken": response.data["refreshToken"],
      });
    } on DioError catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
        return ResponseEntity.Error(e.response!.data[0]["message"] ??
            "An error occurred. Please try again");
      }

      return ResponseEntity.Error("Incorrect credentials");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred logging you in. Try again");
    }
  }

  Future<ResponseEntity<Map<String, dynamic>>> appleSignin(
      AppleSigninRequest request) async {
    final Dio dio = Dio();
    Response response;
    try {
      response = await dio.post("${baseApi}auth/identities/apple",
          data: FormData.fromMap(request.toMap()));

      return ResponseEntity.Data({
        "id": response.data["user"]["id"],
        "token": response.data["accessToken"],
        "refreshToken": response.data["refreshToken"],
      });
    } on DioError catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }

      if (e.type == DioExceptionType.badResponse) {
        print("Apple sign in error ${e.response?.data}");
        return ResponseEntity.Error("There was an error on the server");
      }

      return ResponseEntity.Error("An error occurred signing in with Apple");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error("An error occurred. Please try again");
    }
  }

  Future<ResponseEntity<Map<String, dynamic>>> signup(
      SignUpRequest request) async {
    print("Signing up ${request.toMap()}");

    final Dio dio = Dio();
    Response response;
    try {
      response = await dio.post(
        "${baseApi}auth/emails/signup",
        data: request.toFormData(),
        options: Options(
          contentType: "multipart/form-data",
        ),
      );

      print("signup data ${response.data}");

      return ResponseEntity.Data({
        "id": response.data["user"]["id"],
        "token": response.data["accessToken"],
        "user": response.data["user"],

        "isVerified": response.data["user"]?["isVerified"],

        "refreshToken": response.data["refreshToken"]
      });
    } on DioError catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        print("connectionTimeout");
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
        print("signup data ${e.response?.data}");
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

  Future<ResponseEntity> testSignup(LoginRequest request) async {
    print("Testing Signup ${request.toMap()}");
    final Dio dio = Dio();
    Response response;
    try {
      response = await dio.post(
        "${baseApi}auth/emails/signup",
        data: request.toJson(),
      );

      print("Test signup result ${response.data}");

      return ResponseEntity.Data({
        "id": response.data["user"]["id"],
        "token": response.data["accessToken"],
        "user": response.data["user"],

        "isVerified": response.data["user"]?["isVerified"],

        "refreshToken": response.data["refreshToken"]
      });
    } on DioError catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        print("connectionTimeout");
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
        Map<String, dynamic> fieldErrors = {};
        e.response!.data.forEach((e) {
          if (e["field"] == "email") {
            fieldErrors.putIfAbsent("email", () => e["message"]);
          }

          if (e["field"] == "password") {
            fieldErrors.putIfAbsent("password", () => e["message"]);
          }
        });
        return ResponseEntity.Error(
            "Invalid fields", fieldErrors: fieldErrors);
      }

      return ResponseEntity.Error("An error occurred ");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred signing you up in. Try again");
    }
  }

  Future<ResponseEntity<Map<String, dynamic>>> refreshToken() async {
    final Dio dio = dioClient(useRefreshToken: true);
    Response response;
    try {
      response = await dio.post("auth/token", options: Options(headers: {}));

      return ResponseEntity.Data({
        "id": response.data["user"]["id"],
        "token": response.data["accessToken"],
        "refreshToken": response.data["refreshToken"]
      });
    } on DioError catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
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

  Future<ResponseEntity<bool>> verifyTransactionPin({required String pin}) async {
    print("verifying pin");
    final Dio dio = dioClient();
    Response response;
    try {
      response = await dio.post(
        "payment/wallets/pin/verify",
        data: jsonEncode({
          "pin": "\"${pin}\""
        },),
      );

      print("verify pin response ${response.data}");


      return ResponseEntity.Data(response.data == true);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
        return ResponseEntity.Error(
            e.response!.data[0]["message"] ?? "verifying transaction pin failed");
      }

      return ResponseEntity.Error("verifying transaction pin failed");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred verifying transaction pin. Try again");
    }
  }
  Future<ResponseEntity> sendResetPINCode() async {
    print("Resetting pin");
    final Dio dio = dioClient();
    Response response;
    try {
      response = await dio.post(
        "payment/wallets/pin/reset/mail",
      );

      print("Reseting pin response ${response.data}");


      return ResponseEntity.Data(null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
        return ResponseEntity.Error(
            e.response!.data[0]["message"] ?? "sending reset code failed");
      }

      return ResponseEntity.Error("sending reset code failed");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred sending reset code. Try again");
    }
  }

  Future<ResponseEntity> confirmResetPIN(
      ConfirmResetPINRequest request,
      ) async {

    print("Updating pin ${request.toMap()}");
    final Dio dio = dioClient();
    Response response;
    try {
      response = await dio.post(
          "payment/wallets/pin/reset",
          data: request.toMap()
      );

      print("Wallet pin reset response ${response.data}");

      return ResponseEntity.Data(null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
        print("Walet pin error ${e.response?.data} ${e.response?.statusCode}");
        return ResponseEntity.Error(
            e.response!.data[0]["message"] ?? "Pin update failed");
      }

      return ResponseEntity.Error("Pin Update failed");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred updating pin. Try again");
    }
  }
  Future<ResponseEntity> updateTransactionPin(
      UpdateTransactionPinRequest request,
      ) async {

    print("Updating pin ${request.toMap()}");
    final Dio dio = dioClient();
    Response response;
    try {
      response = await dio.post(
          "payment/wallets/pin",
          data: request.toMap()
      );

      print("Wallet pin response ${response.data}");

      return ResponseEntity.Data(null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
        print("Walet pin error ${e.response?.data} ${e.response?.statusCode}");
        return ResponseEntity.Error(
            e.response!.data[0]["message"] ?? "Pin update failed");
      }

      return ResponseEntity.Error("Pin Update failed");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred updating pin. Try again");
    }
  }
  Future<ResponseEntity> sendResetPasswordCode(
    String email,
  ) async {
    final Dio dio = Dio();
    Response response;
    try {
      response = await dio
          .post("${baseApi}auth/passwords/reset/mail", data: {"email": email});

      return ResponseEntity.Data(null);
    } on DioError catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
        return ResponseEntity.Error(
            e.response!.data[0]["message"] ?? "Password Reset failed");
      }

      return ResponseEntity.Error("Password Reset failed");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error("An error occurred sending code. Try again");
    }
  }

  Future<ResponseEntity> confirmPasswordResetChange(
      {required String password, required String token}) async {
    final Dio dio = Dio();
    Response response;
    try {
      response = await dio.post("${baseApi}auth/passwords/reset",
          data: jsonEncode({"password": password, "token": token}));

      return ResponseEntity.Data(null);
    } on DioError catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
        return ResponseEntity.Error(
            e.response!.data[0]["message"] ?? "Password Reset failed");
      }

      return ResponseEntity.Error("Password Reset failed");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error("An error occurred sending code. Try again");
    }
  }

  Future<ResponseEntity> sendEmailVerificationCode(
    String email,
  ) async {
    print("sending verification code ${email}");
    final Dio dio = dioClient();
    Response response;
    try {
      response = await dio
          .post("${baseApi}auth/emails/verify/mail", data: {"email": email});

      print("Send veriifcation result ${response.data}");

      return ResponseEntity.Data(null);
    } on DioError catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
        print("Send veriication error ${e.response?.statusCode} ${e.response?.data}");
        return ResponseEntity.Error(
            e.response!.data[0]["message"] ?? "Email Verification failed");
      }

      return ResponseEntity.Error("Email Verification  failed");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error("An error occurred sending code. Try again");
    }
  }

  Future<ResponseEntity> confirmEmailVerificationCode(
      {required String token}) async {
    print("confirming verification code ${token}");

    final Dio dio = dioClient();
    Response response;
    try {
      response = await dio.post("${baseApi}auth/emails/verify",
          data: jsonEncode({"token": "\"${token}\""}));
      print("Verification code confirmed ${response.data}");

      return ResponseEntity.Data(null);
    } on DioError catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
        print("confirm verification error ${e.response?.statusCode} ${e.response?.data}");

        return ResponseEntity.Error(
            e.response!.data[0]["message"] ?? "Email Verification failed");
      }

      return ResponseEntity.Error("Email Verification failed");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred verifying code. Try again");
    }
  }
}
