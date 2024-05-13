import 'package:greep/application/response.dart';
import 'package:greep/application/wallet/request/fund_wallet_request.dart';
import 'package:greep/application/wallet/request/transfer_money_request.dart';
import 'package:greep/application/wallet/request/wallet_withdraw_request.dart';
import 'package:greep/domain/transaction/transaction.dart';
import 'package:greep/domain/transaction/wallet_transaction.dart';
import 'package:greep/domain/wallet/wallet.dart';
import 'package:greep/domain/wallet/wallet_client.dart';

class WalletService {
  final WalletClient walletClient;

  WalletService({required this.walletClient});

  Future<ResponseEntity<Wallet>> getUserWallet() async {
    var responseEntity = await walletClient.getUserWallet();
    return responseEntity;
  }

  Future<ResponseEntity<num>> getConversionRate() async {
    var responseEntity = await walletClient.getConversionRate();
    return responseEntity;
  }

  Future<ResponseEntity> fulfillTransaction(String transactionId) async {
    return await walletClient.fulfillTransaction(transactionId);
  }

  Future<ResponseEntity<WalletTransaction>> withdrawWallet(
      WalletWithdrawRequest request) async {
    return walletClient.withdrawWallet(request);
  }

// Future<ResponseEntity<UserTransaction>> fundWallet(FundWalletRequest request) async {
//   return await walletClient.fundWallet(request);
// }
//
// Future<ResponseEntity<UserTransaction>> transferFund(TransferMoneyRequest request) async {
//
// return await walletClient.transferFund(request);
// }
}
