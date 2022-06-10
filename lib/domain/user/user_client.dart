import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/dio_config.dart';
import 'package:grip/application/response.dart';
import 'package:grip/application/user/driver/add_driver_request.dart';
import 'package:grip/domain/auth/AuthenticationService.dart';
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
      if (e.type == DioErrorType.response) {
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
              return fetchUser();
            }
          }
        } catch (_) {}
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

  Future<ResponseEntity<List<User>>> fetchUserDrivers(String userId) async {
    Map<String, dynamic> queryParams = {
      "where[]": {"field":"manager.managerId", "value":userId,},
      "all": "true"
    };
    Response response;
    try {
      response = await dio.get("users/users",queryParameters: queryParams);
      List<User> users = [];
      response.data["results"].forEach((e){
        users.add(User.fromServer(e));
      });
      print(users);
      return ResponseEntity.Data(users);
    } on DioError catch (e) {

      if (e.type == DioErrorType.connectTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioErrorType.response) {
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
              return fetchUserDrivers(userId);
            }
          }
        } catch (_) {}
      }
      dynamic error = e.response!.data;
      String message = "";
      if (error == null) {
        message = "An error occurred fetching user drivers. Try again";
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
          "An error occurred  fetching user drivers. Try again");
    }
  }

  Future<ResponseEntity> addDriver(AddDriverRequest request) async {
    print("add driver request");
    Response response;
    try {
      response = await dio.post("users/users/drivers/add", data: request.toJson());
      return ResponseEntity.Data(null);
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }

      if (e.type == DioErrorType.response) {
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
                  "An error occurred adding driver");
            } else {
              return addDriver(request);
            }
          }
        } catch (_) {}
      }
      dynamic error = e.response!.data;
      print(error);
      String message = "";
      if (error == null) {
        message = "An error occurred adding driver. Try again";
      } else {
        try {
          message = "${error[0]["field"]??""} ${error[0]["message"]}";
        } catch (e) {
          message = "an error occurred. Try again";
        }
      }
      return ResponseEntity.Error(message);
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred adding driver. Try again");
    }
  }


}
