import 'package:greep/domain/transaction/transaction.dart';

class CustomerSummary {
  final String name;
  final num totalPaid;
  final num toCollect;
  final num toPay;
  final List<Transaction> transactions;

  CustomerSummary({
    required this.name,
    required this.totalPaid,
    required this.toCollect,
    required this.transactions,
    required this.toPay,
  });

  factory CustomerSummary.Zero(String name){
    return CustomerSummary(name: name, totalPaid: 0, toCollect: 0, toPay: 0, transactions: []);
  }

  @override
  String toString() {
    return 'CustomerSummary{name: $name, totalPaid: $totalPaid, toCollect: $toCollect, toPay: $toPay}';
  }
}
