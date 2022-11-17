import 'package:greep/domain/transaction/transaction.dart';

class CommissionSummary {
  final num commission;
  final List<DateTime> dateRange;
 final List<Transaction> transactions;

  const CommissionSummary({required this.commission, required this.transactions,required this.dateRange}):
      assert (dateRange.length == 2);

  factory CommissionSummary.Zero() {
    return  CommissionSummary(commission: 0, transactions: [],dateRange: [DateTime.now(),DateTime.now()]);
  }

  @override
  String toString() {
    return 'CommissionSummary{commission: $commission, transactions: ${transactions.length}, dateRange: $dateRange';
  }
}
