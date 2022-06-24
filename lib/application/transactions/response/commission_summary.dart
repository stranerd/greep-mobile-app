import 'package:grip/domain/transaction/transaction.dart';

class CommissionSummary {
  final num commission;
 final List<Transaction> transactions;

  const CommissionSummary({required this.commission, required this.transactions});

  factory CommissionSummary.Zero() {
    return const CommissionSummary(commission: 0, transactions: []);
  }


}
