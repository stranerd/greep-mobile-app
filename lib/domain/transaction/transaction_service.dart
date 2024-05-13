import 'package:greep/application/response.dart';
import 'package:greep/application/transactions/request/add_balance_request.dart';
import 'package:greep/application/transactions/request/add_expense_request.dart';
import 'package:greep/application/transactions/request/add_trip_request.dart';
import 'package:greep/domain/transaction/transaction.dart';
import 'package:greep/domain/transaction/transaction_client.dart';
import 'package:greep/domain/transaction/wallet_transaction.dart';

class TransactionService {
  final TransactionClient transactionClient;

  TransactionService(this.transactionClient);

  Future<ResponseEntity<List<Transaction>>> getUserTransactions(String driverId) async {
    var responseEntity = await transactionClient.getUserTransactions(driverId);
    if (!responseEntity.isError){
      if (responseEntity.data!=null && responseEntity.data!.isNotEmpty){
      sortResults(responseEntity.data!);
      }
      return responseEntity;
    }
    return responseEntity;
  }

  Future<ResponseEntity<List<WalletTransaction>>> fetchPaymentTransactions({String? type}) async {
    return await transactionClient.fetchPaymentTransactions(type: type);


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

  void sortResults(List<Transaction> list){
    list.sort((a, b) {
      return b.timeAdded.compareTo(a.timeAdded);
    });
  }
}
