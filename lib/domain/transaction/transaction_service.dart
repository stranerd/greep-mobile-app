import 'package:grip/application/response.dart';
import 'package:grip/application/transactions/request/add_balance_request.dart';
import 'package:grip/application/transactions/request/add_expense_request.dart';
import 'package:grip/application/transactions/request/add_trip_request.dart';
import 'package:grip/domain/transaction/transaction.dart';
import 'package:grip/domain/transaction/transaction_client.dart';

class TransactionService {
  final TransactionClient transactionClient;

  TransactionService(this.transactionClient);

  Future<ResponseEntity<List<Transaction>>> getUserTransactions(String userId) async {
    var responseEntity = await transactionClient.getUserTransactions(userId);
    if (responseEntity.isError)
      return responseEntity;
    return responseEntity;
  }

  Future<ResponseEntity<Transaction>> addTrip(AddTripRequest request) async {
    return await transactionClient.addTrip(request);
  }
  Future<ResponseEntity<Transaction>> addExpense(AddExpenseRequest request) async {
    return await transactionClient.addExpense(request);
  }

  Future<ResponseEntity<Transaction>> addBalance(AddBalanceRequest request) async {
    return await transactionClient.addBalance(request);
  }

}
