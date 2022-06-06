import 'package:grip/domain/transaction/transaction.dart';

class TransactionSummary {
   num amount;
   num trips;
   num expenses;
   List<Transaction> transactions;

  TransactionSummary({required this.amount, required this.trips, this.transactions = const [], required this.expenses});


  factory TransactionSummary.Zero() {
    return TransactionSummary(amount: 0, trips: 0, expenses: 0);
  }

   @override
  String toString() {
    return 'TransactionSummary{amount: $amount, trips: $trips, expenses: $expenses}';
  }
}
