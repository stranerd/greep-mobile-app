import 'package:grip/application/response.dart';
import 'package:grip/domain/transaction/transaction.dart';
import 'package:grip/domain/transaction/transaction_client.dart';

class TransactionService {
  final TransactionClient transactionClient;

  TransactionService(this.transactionClient);

  Future<ResponseEntity<List<Transaction>>> getUserTransactions(String userId) async {
    return await transactionClient.getUserTransactions(userId);
  }
}
