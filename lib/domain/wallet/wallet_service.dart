import 'package:greep/application/response.dart';
import 'package:greep/domain/wallet/wallet.dart';
import 'package:greep/domain/wallet/wallet_client.dart';

class WalletService {

  final WalletClient walletClient;

  WalletService({required this.walletClient});

  Future<ResponseEntity<Wallet>> getUserWallet() async {
    var responseEntity = await walletClient.getUserWallet();
    return responseEntity;
  }

}
