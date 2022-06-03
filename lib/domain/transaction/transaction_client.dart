import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/dio_config.dart';
import 'package:grip/application/response.dart';
import 'package:grip/domain/auth/AuthenticationService.dart';
import 'package:grip/domain/transaction/transaction.dart';

class TransactionClient {

  final Dio dio = dioClient();

  Future<ResponseEntity<List<Transaction>>> getUserTransactions(String userId)async{
    print("print losses");
    Response response;
    try {
      response = await dio.get("users/transactions");
      List<Transaction> transactions = [];
      response.data["results"].forEach((e){
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

      if (e.type == DioErrorType.response){
        try {
          if (e.response!.data[0]["message"].toString().toLowerCase().contains("access token")){
            print("refreshing token");
           var response =  await GetIt.I<AuthenticationService>().refreshToken();
           if (response.isError) {
             return ResponseEntity.Error("An error occurred fetching transactions");
           }
           else {
             return getUserTransactions(userId);
           }
          }
        }
        catch (_){

        }
      }
      dynamic error = e.response!.data;
      String message = "";
      if (error == null) {
        message = "An error occurred fetching transactions. Try again";
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
          "An error occurred fetching transactions. Try again");
    }
  }

}
