import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/dio_config.dart';
import 'package:grip/application/response.dart';
import 'package:grip/application/transactions/request/add_balance_request.dart';
import 'package:grip/application/transactions/request/add_expense_request.dart';
import 'package:grip/application/transactions/request/add_trip_request.dart';
import 'package:grip/domain/auth/AuthenticationService.dart';
import 'package:grip/domain/transaction/transaction.dart';

class TransactionClient {
  final Dio dio = dioClient();

  Future<ResponseEntity<List<Transaction>>> getUserTransactions(
      String driverId) async {
    Map<String, dynamic> queryParams = {
      "limit": 1000,
      "where[]": {"field":"driverId", "value":driverId,},

    };
    Response response;
    try {
      response = await dio.get("users/transactions",queryParameters: queryParams);
      List<Transaction> transactions = [];
      response.data["results"].forEach((e) {
        transactions.add(Transaction.fromServer(e));
      });

      return ResponseEntity.Data(transactions);
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
                  "An error occurred fetching transactions");
            } else {
              return getUserTransactions(driverId);
            }
          }
        } catch (_) {}
      }
      dynamic error = e.response!.data;
      String message = "";
      if (error == null) {
        message = "An error occurred fetching transactions. Try again";
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
          "An error occurred fetching transactions. Try again");
    }
  }

  Future<ResponseEntity<Transaction>> addTrip(AddTripRequest request) async {
    print("add trip request");
    Response response;
    try {
      response = await dio.post("users/transactions", data: request.toJson());
      return ResponseEntity.Data(Transaction.fromServer(response.data));
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
                  "An error occurred adding transactions");
            } else {
              return addTrip(request);
            }
          }
        } catch (_) {}
      }
      dynamic error = e.response!.data;
      print(error);
      String message = "";
      if (error == null) {
        message = "An error occurred adding transactions. Try again";
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
          "An error occurred adding transactions. Try again");
    }
  }

  Future<ResponseEntity<Transaction>> addBalance(
      AddBalanceRequest request) async {
    print("add balance request");
    Response response;
    try {
      response = await dio.post("users/transactions", data: request.toJson());
      return ResponseEntity.Data(Transaction.fromServer(response.data));
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
                  "An error occurred adding transactions");
            } else {
              return addBalance(request);
            }
          }
        } catch (_) {}
      }
      dynamic error = e.response!.data;
      print(error);
      String message = "";
      if (error == null) {
        message = "An error occurred adding transactions. Try again";
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
          "An error occurred adding transactions. Try again");
    }
  }

  Future<ResponseEntity<Transaction>> addExpense(
      AddExpenseRequest request) async {
    print("add expense request");
    Response response;
    try {
      response = await dio.post("users/transactions", data: request.toJson());
      return ResponseEntity.Data(Transaction.fromServer(response.data));
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
                  "An error occurred adding transactions");
            } else {
              return addExpense(request);
            }
          }
        } catch (_) {}
      }
      dynamic error = e.response!.data;
      String message = "";
      if (error == null) {
        message = "An error occurred adding transactions. Try again";
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
          "An error occurred adding transactions. Try again");
    }
  }
}
