import 'dart:convert';
import 'dart:io';

import 'package:greep/application/dio_config.dart';
import 'package:greep/application/response.dart';
import 'package:greep/application/wallet/request/fund_wallet_request.dart';
import 'package:greep/application/wallet/request/transfer_money_request.dart';
import 'package:greep/application/wallet/request/wallet_withdraw_request.dart';
import 'package:greep/domain/api.dart';
import 'package:greep/domain/transaction/transaction.dart';
import 'package:greep/domain/transaction/wallet_transaction.dart';
import 'package:greep/domain/wallet/wallet.dart';
import 'package:dio/dio.dart';

class WalletClient {
  final Dio dio = dioClient();

  Future<ResponseEntity<Wallet>> getUserWallet() async {
    print("Fetching user wallet");

    Response response;
    try {
      response = await dio.get(
        "payment/wallets",
      );
      print("wallet data ${response.data} ");

      return ResponseEntity.Data(Wallet.fromMap(response.data));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }

      if (e.type == DioExceptionType.badResponse) {
        print(
            "wallet error data ${e.response?.data} ${e.response?.statusCode}");
        String message = e.response?.data?[0]["message"] ??
            "An error occurred fetching wallet";
        return ResponseEntity.Error(
          message,
          statusCode: e.response?.statusCode ?? 400,
        );
      }
      return ResponseEntity.Error("An error occurred fetching wallet");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred fetching wallet. Try again");
    }
  }

  Future<ResponseEntity> fulfillTransaction(String transactionId) async {
    print("fulfilling wallet ${transactionId}");

    Response response;
    try {
      response = await dio.put(
        "payment/transactions/${transactionId}/fulfill",
      );
      print("fulfilling wallet data ${response.data}");

      return ResponseEntity.Data(null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }

      if (e.type == DioExceptionType.badResponse) {
        print(
            "wallet error data ${e.response?.data} ${e.response?.statusCode}");
        String message = e.response?.data?[0]["message"] ??
            "An error occurred funding wallet";
        return ResponseEntity.Error(
          message,
          statusCode: e.response?.statusCode ?? 400,
        );
      }
      return ResponseEntity.Error("An error occurred funding wallet");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred funding wallet. Try again");
    }
  }

  Future<ResponseEntity<WalletTransaction>> withdrawWallet(
      WalletWithdrawRequest request) async {
    print("withdrawing wallet");

    Response response;
    try {
      response = await dio.post(
        "payment/wallets/withdraw",
        data: jsonEncode(request.toMap()),
      );
      print("withdrawing from wallet data ${response.data}");

      return ResponseEntity.Data(WalletTransaction.fromMap(response.data));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }

      if (e.type == DioExceptionType.badResponse) {
        print(
            "wallet error data ${e.response?.data} ${e.response?.statusCode}");
        String message = e.response?.data?[0]["message"] ??
            "An error occurred withdrawing from wallet";
        return ResponseEntity.Error(
          message,
          statusCode: e.response?.statusCode ?? 400,
        );
      }
      return ResponseEntity.Error("An error occurred withdrawing from wallet");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred withdrawing from wallet. Try again");
    }
  }

  Future<ResponseEntity<num>> getConversionRate() async {
    print("Fetching conversion rate");

    Response response;
    try {
      response = await dio.get(
        "payment/transactions/rates",
      );
      print("conversation data ${response.data}");

      return ResponseEntity.Data(
          num.tryParse(response.data?["NGN"]?.toString() ?? "") ?? 0);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }

      if (e.type == DioExceptionType.badResponse) {
        print(
            "wallet error data ${e.response?.data} ${e.response?.statusCode}");
        String message = e.response?.data?[0]["message"] ??
            "An error occurred fetching conversion rate";
        return ResponseEntity.Error(
          message,
          statusCode: e.response?.statusCode ?? 400,
        );
      }
      return ResponseEntity.Error(
          "An error occurred fetching conversation rate");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred fetching conversation rate. Try again");
    }
  }
}
