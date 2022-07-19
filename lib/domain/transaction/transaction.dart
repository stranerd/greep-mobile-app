import 'package:equatable/equatable.dart';
import 'package:grip/domain/transaction/TransactionData.dart';

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
  final num credit;
  final TransactionData data;

  const Transaction({
    required this.driverId,
    required this.id,
    required this.credit,
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
    num paidAmount = data["data"]["paidAmount"] == null
        ? 0
        : data["data"]["paidAmount"] ?? 0;
    num amount = data["amount"];
    num debt = 0;
    num credit = 0;
    if (paidAmount < amount) {
      debt = amount - paidAmount;
    }
    else if (paidAmount > amount){
      credit = paidAmount - amount;
    }
    return Transaction(
      driverId: data["driverId"],
      id: data["id"],
      credit: credit,
      managerId: data["managerId"],
      amount: data["amount"],
      description: data["description"],
      timeAdded: DateTime.fromMillisecondsSinceEpoch(data["recordedAt"]),
      timeCreated: DateTime.fromMillisecondsSinceEpoch(data["createdAt"]),
      timeUpdated: DateTime.fromMillisecondsSinceEpoch(data["updatedAt"]),
      data: TransactionData.fromServer(data["data"]),
      debt: debt,
    );
  }


  @override
  String toString() {
    return 'Transaction{driverId: $driverId, id: $id, managerId: $managerId, amount: $amount, description: $description, timeAdded: $timeAdded, timeCreated: $timeCreated, timeUpdated: $timeUpdated, debt: $debt, credit: $credit, data: $data}';
  }

  @override
  List<Object?> get props => [id];
}
