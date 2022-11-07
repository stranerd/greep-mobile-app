import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/dio_config.dart';
import 'package:grip/application/response.dart';
import 'package:grip/application/driver/request/accept_manager_request.dart';
import 'package:grip/application/driver/request/add_driver_request.dart';
import 'package:grip/application/user/request/EditUserRequest.dart';
import 'package:grip/domain/auth/AuthenticationService.dart';
import 'package:grip/domain/user/model/User.dart';
import 'package:grip/domain/user/model/driver_commission.dart';
import 'package:grip/domain/user/model/manager_request.dart';

class UserClient {
  final Dio dio = dioClient();

  Future<ResponseEntity<User>> fetchUser(String userId) async {
    Response response;
    try {
      response = await dio.get("users/users/$userId");
      return ResponseEntity.Data(
          User.fromServer(response.data));
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
              return fetchUser(userId);
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

  Future<ResponseEntity<List<DriverCommission>>> fetchUserDriverCommissions(String userId) async {
    Response response;
    try {
      response = await dio.get("users/users/$userId");
      List<DriverCommission> drivers = [];
      if (response.data["drivers"]==null || response.data["drivers"].isEmpty){
        return ResponseEntity.Data(const []);
      }

      response.data["drivers"].forEach((e) {
        drivers.add(DriverCommission.fromServer(e));
      });

      return ResponseEntity.Data(drivers);
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
              return fetchUserDriverCommissions(userId);
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
          "An error occurred fetching driver. Try again");
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
      print(response.data["results"]);
      response.data["results"].forEach((e){
        print(e);
        users.add(User.fromServer(e));
      });
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

  Future<ResponseEntity> sendOrRemoveDriverRequest(AddDriverRequest request) async {
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
              return sendOrRemoveDriverRequest(request);
            }
          }
        } catch (_) {}
      }
      dynamic error = e.response!.data;
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

  Future<ResponseEntity> acceptOrRejectManager(AcceptManagerRequest request) async {
    print("accept manager request");
    Response response;
    try {
      response = await dio.post("users/users/managers/accept", data: request.toJson());
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
              return acceptOrRejectManager(request);
            }
          }
        } catch (_) {}
      }
      dynamic error = e.response!.data;
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

  Future<ResponseEntity> removeDriver(String driverId) async {
    print("delete driver request");
    Response response;
    try {
      response = await dio.post("users/users/drivers/remove", data: jsonEncode({"driverId": driverId}));
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
              return removeDriver(driverId);
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

  Future<ResponseEntity<ManagerRequest>> fetchManagerRequests(String userId) async {
    Response response;
    try {
      response = await dio.get("users/users/$userId");
      Map<String,dynamic> managerRequests = {};
      if (response.data["managerRequests"]!=null || (response.data["managerRequests"] as List).isNotEmpty){
        List list  = (response.data["managerRequests"] as List);
   return ResponseEntity.Data(ManagerRequest.fromServer(list.first));
      }
      return ResponseEntity.Error("No manager requests");
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
              return fetchManagerRequests(userId);
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

  Future<ResponseEntity> editUser(EditUserRequest request) async {
    Response response;
    try {
      response = await dio.put("auth/user", data: request.toFormData());
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
              return editUser(request);
            }
          }
        } catch (_) {}
      }
      dynamic error = e.response!.data;
      print(error);
      String message = "";
      if (error == null) {
        message = "An error occurred editing fields. Try again";
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
          "An error occurred editing fields. Try again");
    }
  }


}
