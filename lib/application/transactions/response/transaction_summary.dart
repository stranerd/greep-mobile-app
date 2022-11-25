import 'package:greep/domain/transaction/transaction.dart';

class TransactionSummary {
  num income;
  num tripCount;
  num expenseCount;
  num tripAmount;
  num expenseAmount;
  List<Transaction> transactions;
  final List<DateTime> dateRange;


  TransactionSummary({
    required this.income,
    required this.expenseAmount,
    required this.dateRange,
    required this.tripAmount,
    required this.tripCount,
    this.transactions = const [],
    required this.expenseCount,
  });

  factory TransactionSummary.Zero() {
    return TransactionSummary(
      income: 0,
      tripCount: 0,
      expenseCount: 0,
      dateRange: [DateTime.now(),DateTime.now()],
      tripAmount: 0,
      expenseAmount: 0,
    );
  }

  @override
  String toString() {
    return 'TransactionSummary{income: $income, tripCount: $tripCount, expenseCount: $expenseCount, tripAmount: $tripAmount, expenseAmount: $expenseAmount, transactions: ${transactions.length}, date range: $dateRange';
  }
}
