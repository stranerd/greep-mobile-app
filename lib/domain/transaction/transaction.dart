import 'package:equatable/equatable.dart';
import 'package:greep/domain/transaction/TransactionData.dart';

class Transaction extends Equatable {
  final String driverId;
  final String id;
  final String managerId;
  final num amount;
  final String description;
  final DateTime timeAdded;
  final DateTime timeCreated;
  final DateTime timeUpdated;
  final num debt;
  final TransactionData data;

  const Transaction({
    required this.driverId,
    required this.id,
    required this.managerId,
    required this.amount,
    required this.debt,
    required this.description,
    required this.timeAdded,
    required this.timeCreated,
    required this.timeUpdated,
    required this.data,

  });

  factory Transaction.fromServer(dynamic data) {
    var transactionData = TransactionData.fromServer(data["data"]);

    return Transaction(
      driverId: data["driverId"] ?? "",
      id: data["id"],
      managerId: data["managerId"] ?? "",
      amount: data["amount"] ?? 0,
      description: data["description"] ?? "",
      timeAdded: DateTime.fromMillisecondsSinceEpoch(data["recordedAt"]),
      timeCreated: DateTime.fromMillisecondsSinceEpoch(data["createdAt"]),
      timeUpdated: DateTime.fromMillisecondsSinceEpoch(data["updatedAt"]),
      data: transactionData,
      debt: transactionData.debt??0,
    );
  }


  @override
  String toString() {
    return 'Transaction{driverId: $driverId, id: $id, managerId: $managerId, amount: $amount, description: $description, timeAdded: $timeAdded, timeCreated: $timeCreated, timeUpdated: $timeUpdated, debt: $debt, data: $data}';
  }

  @override
  List<Object?> get props => [id];
}
