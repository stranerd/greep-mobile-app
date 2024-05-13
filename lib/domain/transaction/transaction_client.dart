import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:greep/application/dio_config.dart';
import 'package:greep/application/response.dart';
import 'package:greep/application/transactions/request/add_balance_request.dart';
import 'package:greep/application/transactions/request/add_expense_request.dart';
import 'package:greep/application/transactions/request/add_trip_request.dart';
import 'package:greep/domain/auth/AuthenticationService.dart';
import 'package:greep/domain/transaction/transaction.dart';
import 'package:greep/domain/transaction/wallet_transaction.dart';

class TransactionClient {
  final Dio dio = dioClient();

  Future<ResponseEntity<List<Transaction>>> getUserTransactions(
      String driverId,{Pagination? pagination}) async {
    Map<String, dynamic> queryParams = {
      "all": true,
      "where[]": {"field":"driverId", "value":driverId,},

    };
    Response response;
    try {
      response = await dio.get("trips/transactions",queryParameters: queryParams);
      List<Transaction> transactions = [];
      response.data["results"].forEach((e) {
        transactions.add(Transaction.fromServer(e));
      });

      return ResponseEntity.Data(transactions);
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


  Future<ResponseEntity<List<WalletTransaction>>> fetchPaymentTransactions({String? type}) async {
    print("fetching transaction ${type}");

    Response response;
    try {
      Map<String,dynamic> query = {};
      if (type!=null){
        query = {
          "where[]": {
            "field": "data.type",
            "value": type,
          },
          "all": "true"
        };
      }
      print(query);
      response = await dio.get("payment/transactions",queryParameters: query);
      List<WalletTransaction> transactions = [];

      print("response transactions ${response.data} ");

      response.data["results"].forEach((e) {
        transactions.add(WalletTransaction.fromMap(e));
      });

      return ResponseEntity.Data(transactions);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
        dynamic error = e.response!.data;
        String message = "";
        if (error == null) {
          message = "An error occurred fetching transactions";
        } else {
          message = error["message"] ?? "";
        }
        return ResponseEntity.Error(message);
      }
      return ResponseEntity.Error("An error occurred fetching transactions");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred fetching transactions. Try again");
    }
  }


  Future<ResponseEntity<Transaction>> addTrip(AddTripRequest request) async {
    Response response;
    try {
      response = await dio.post("trips/transactions", data: request.toJson());
      return ResponseEntity.Data(Transaction.fromServer(response.data));
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
      response = await dio.post("trips/transactions", data: request.toJson());
      return ResponseEntity.Data(Transaction.fromServer(response.data));
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
          message = error[0]["message"];
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
      response = await dio.post("trips/transactions", data: request.toJson());
      return ResponseEntity.Data(Transaction.fromServer(response.data));
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
