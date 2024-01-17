import 'dart:io';

import 'package:greep/application/dio_config.dart';
import 'package:greep/application/response.dart';
import 'package:greep/domain/api.dart';
import 'package:greep/domain/wallet/wallet.dart';
import 'package:dio/dio.dart';

class WalletClient {

  final Dio dio = dioClient();


  Future<ResponseEntity<Wallet>> getUserWallet() async {

    print("Fetching user wallet");

    Response response;
    try {
      response = await dio.get("payment/wallets",);
      print("wallet data ${response.data}");


      return ResponseEntity.Data(Wallet.fromMap(response.data));
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }

      if (e.type == DioErrorType.response) {
        print("wallet error data ${e.response?.data} ${e.response?.statusCode}");
        String message = e.response?.data?["message"] ?? "An error occurred fetching wallet";
        return ResponseEntity.Error(message);
      }
      return ResponseEntity.Error("An error occurred fetching wallet");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred fetching wallet. Try again");
    }
  }




}
