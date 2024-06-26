import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:greep/application/auth/AuthStore.dart';
import 'package:greep/application/dio_config.dart';
import 'package:greep/application/response.dart';
import 'package:greep/application/driver/request/accept_manager_request.dart';
import 'package:greep/application/driver/request/add_driver_request.dart';
import 'package:greep/application/user/request/EditUserRequest.dart';
import 'package:greep/application/user/request/update_user_type_request.dart';
import 'package:greep/domain/api.dart';
import 'package:greep/domain/auth/AuthenticationService.dart';
import 'package:greep/domain/user/model/User.dart';
import 'package:greep/domain/user/model/auth_user.dart';
import 'package:greep/domain/user/model/driver_commission.dart';
import 'package:greep/domain/user/model/manager_request.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class UserClient {
  final Dio dio = dioClient();

  Future<ResponseEntity<User>> fetchUser(String userId) async {
    Response response;
    try {
      response = await dio.get("users/users/$userId");
      return ResponseEntity.Data(User.fromServer(response.data));
    } on DioError catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
        print("error in user ${e.response?.data}");
        try {
          if (e.response!.data[0]["message"]
              .toString()
              .toLowerCase()
              .contains("access token")) {
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
        } catch (e) {
          message = "an error occurred. Try again";
        }
      }
      return ResponseEntity.Error(message);
    } catch (e) {
      print("User Exception error $e");
      return ResponseEntity.Error(
          "An error occurred logging you in. Try again");
    }
  }

  Future<ResponseEntity<AuthUser>> fetchAuthUser(String userId) async {
    Response response;
    try {
      response = await dio.get("auth/user");
      print("Auth user response ${response.data}");
      return ResponseEntity.Data(AuthUser.fromMap(response.data));
    } on DioError catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
        print("error in user ${e.response?.data}");
        try {
          if (e.response!.data[0]["message"]
              .toString()
              .toLowerCase()
              .contains("access token")) {
            var response =
            await GetIt.I<AuthenticationService>().refreshToken();
            if (response.isError) {
              return ResponseEntity.Error(
                  "An error occurred, please log in again");
            } else {
              return fetchAuthUser(userId);
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
        } catch (e) {
          message = "an error occurred. Try again";
        }
      }
      return ResponseEntity.Error(message);
    } catch (e) {
      print("User Exception error $e");
      return ResponseEntity.Error(
          "An error occurred logging you in. Try again");
    }
  }


  Future<ResponseEntity<List<DriverCommission>>> fetchUserDriverCommissions(
      String userId) async {
    Response response;
    try {
      response = await dio.get("users/users/$userId");
      List<DriverCommission> drivers = [];
      if (response.data["drivers"] == null ||
          response.data["drivers"].isEmpty) {
        return ResponseEntity.Data(const []);
      }

      response.data["drivers"].forEach((e) {
        drivers.add(DriverCommission.fromServer(e));
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
        } catch (e) {
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

    String where = jsonEncode({
      "field": "manager.managerId",
      "value": userId,
    },);
    Map<String, dynamic> queryParams = {
      "where[]": where,
      "all": "true"
    };
    Response response;
    try {
      response = await dio.get("users/users", queryParameters: queryParams);
      // print("Fetch user drivers respknse ${response.data}");
      List<User> users = [];
      response.data["results"].forEach((e) {
        // print("driver ${e}");
        users.add(User.fromServer(e));
      });
      return ResponseEntity.Data(users);
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
        } catch (e) {
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

  Future<ResponseEntity> sendOrRemoveDriverRequest(
      AddDriverRequest request) async {
    Response response;
    try {
      response =
          await dio.post("users/users/drivers/add", data: request.toJson());
      return ResponseEntity.Data(null);
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
              return ResponseEntity.Error("An error occurred adding driver");
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
          message = "${error[0]["field"] ?? ""} ${error[0]["message"]}";
        } catch (e) {
          message = "an error occurred. Try again";
        }
      }
      return ResponseEntity.Error(message);
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error("An error occurred adding driver. Try again");
    }
  }

  Future<ResponseEntity> acceptOrRejectManager(
      AcceptManagerRequest request) async {
    print("accept manager request");
    Response response;
    try {
      response =
          await dio.post("users/users/managers/accept", data: request.toJson());
      return ResponseEntity.Data(null);
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
              return ResponseEntity.Error("An error occurred adding driver");
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
          message = "${error[0]["field"] ?? ""} ${error[0]["message"]}";
        } catch (e) {
          message = "an error occurred. Try again";
        }
      }
      return ResponseEntity.Error(message);
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error("An error occurred adding driver. Try again");
    }
  }

  Future<ResponseEntity> removeDriver(String driverId) async {
    print("delete driver request");
    Response response;
    try {
      response = await dio.post("users/users/drivers/remove",
          data: jsonEncode({"driverId": driverId}));
      return ResponseEntity.Data(null);
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
              return ResponseEntity.Error("An error occurred adding driver");
            } else {
              return removeDriver(driverId);
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
          message = "${error[0]["field"] ?? ""} ${error[0]["message"]}";
        } catch (e) {
          message = "an error occurred. Try again";
        }
      }
      return ResponseEntity.Error(message);
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error("An error occurred adding driver. Try again");
    }
  }

  Future<ResponseEntity<ManagerRequest>> fetchManagerRequests(
      String userId) async {
    Response response;
    try {
      response = await dio.get("users/users/$userId");
      Map<String, dynamic> managerRequests = {};
      if (response.data["managerRequests"] != null ||
          (response.data["managerRequests"] as List).isNotEmpty) {
        List list = (response.data["managerRequests"] as List);
        return ResponseEntity.Data(ManagerRequest.fromServer(list.first));
      }
      return ResponseEntity.Error("No manager requests");
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
        } catch (e) {
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
              return ResponseEntity.Error("An error occurred adding driver");
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
          message = "${error[0]["field"] ?? ""} ${error[0]["message"]}";
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

  Future<ResponseEntity> deleteUser() async {
    Response response;
    try {
      response = await dio.delete("auth/user");
      return ResponseEntity.Data(null);
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
              return ResponseEntity.Error("An error occurred adding driver");
            } else {
              return deleteUser();
            }
          }
        } catch (_) {}
      }
      dynamic error = e.response!.data;
      print(error);
      String message = "";
      if (error == null) {
        message = "An error occurred deleting your account. Try again";
      } else {
        try {
          message = "${error[0]["field"] ?? ""} ${error[0]["message"]}";
        } catch (e) {
          message = "an error occurred. Try again";
        }
      }
      return ResponseEntity.Error(message);
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred occurred deleting your account. Try again");
    }
  }
  Future<ResponseEntity> updateUserType(UpdateUserTypeRequest request) async {
    print("updating user type ${request.toMap().files} ${dio.options.headers}");
    Response response;
    FormData formData = FormData();
    var extension = request.license.path.split(".").last;

      formData.files.add(MapEntry(
        "license",
        MultipartFile.fromFileSync(request.license.path,
            contentType: MediaType(
                'image', extension == "jpg" ? "jpeg" : extension,
            )

      ),
      ));

    formData.fields.add(
      const MapEntry("type", "driver"),
    );
    try {
      response = await dio.post(
        "users/users/type",
        data: formData,
        options: Options(
          contentType: "multipart/form-data",
        ),
      );

      print("Update Customer Type response ${response.data}");
      return ResponseEntity.Data(null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }

      if (e.type == DioExceptionType.badResponse) {
        print("Update Customer Type response ${e.response?.data}");

        try {
          if (e.response!.data[0]["message"]
              .toString()
              .toLowerCase()
              .contains("access token")) {
            print("refreshing token");
            var response =
            await GetIt.I<AuthenticationService>().refreshToken();
            if (response.isError) {
              return ResponseEntity.Error("An error occurred updating info");
            } else {
              return updateUserType(request);
            }
          }
        } catch (_) {}
      }
      dynamic error = e.response!.data;
      String message = "";
      if (error == null) {
        message = "An error occurred editing fields. Try again";
      } else {
        try {
          message = "${error[0]["field"] ?? ""} ${error[0]["message"]}";
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

  Future<ResponseEntity> updateUserType2(
      UpdateUserTypeRequest userRequest) async {
    try {
      var uri = Uri.parse('${baseApi}users/users/type');

      var request = http.MultipartRequest('POST', uri)
        ..fields['type'] = 'driver'
        ..files.add(
          await http.MultipartFile.fromPath(
            'license',
            userRequest.license.path,

          ),
        )


      ;

      var pref = AuthStore();
      var token = await pref.getAuthToken();
      request.headers["Access-Token"] = "${token["token"] ?? ""}";
      request.headers["Accept"] = "*/*";
      var response = await http.Response.fromStream(await request.send());

      print(
          "Update Customer Type response ${response.body} ${"${token["token"] ?? ""}"}");

      if (response.statusCode == 200) {
        return ResponseEntity.Data(null);
      } else {
        return ResponseEntity.Error(
            "An error occurred updating information. Try again");
      }
    } on SocketException {
      return ResponseEntity.Socket();
    } on http.ClientException catch (e) {
      return ResponseEntity.Error(
          "An error occurred updating information. Try again: $e");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred updating information. Try again");
    }
  }

  Future<ResponseEntity<List<User>>> fetchUserRankings({required String rankingType}) async {

    String where = jsonEncode({ "field": 'account.rankings.${rankingType}.value', "desc": true });
    Map<String, dynamic> queryParams = {
      "sort[]": where,
      "all": "true"
    };
    Response response;
    try {
      response = await dio.get("users/users", queryParameters: queryParams);
      // print("Fetch user drivers respknse ${response.data}");
      List<User> users = [];
      response.data["results"].forEach((e) {
        // print("driver ${e}");
        users.add(User.fromServer(e));
      });
      return ResponseEntity.Data(users);
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
              return fetchUserRankings(rankingType: rankingType);
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
        } catch (e) {
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


}
