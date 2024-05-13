import 'dart:math';

import 'package:equatable/equatable.dart';

enum WalletTransactionType {
  reward,
  trip,
  discount,
  transaction
}

class WalletTransactionData {

  final String type;
  final String? note;
  final String? to;
  final num? exchangeRate;

  WalletTransactionData({this.note, this.to, this.exchangeRate, required this.type,});

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'note': note,
      'to': to,
      'exchangeRate': exchangeRate,
    };
  }

  factory WalletTransactionData.fromMap(Map<String, dynamic> map) {
    return WalletTransactionData(
      type: map['type'] ?? "",
      note: map['note'],
      to: map['to'],
      exchangeRate: map['exchangeRate'],
    );
  }
}

class WalletTransaction extends Equatable {
  final String id;
  final String title;
  final num points;
  final DateTime date;
  final String currency;
  final num amount;

  final String description;
  final String status;

  final WalletTransactionType transactionType;
  final WalletTransactionData? data;
  final String dataType;

  WalletTransaction(
      {required this.id,
      required this.title,
      required this.points,
      required this.currency,
      required this.description,
      required this.date,
      required this.dataType,
        required this.data,
      required this.status,
      required this.amount,
      required this.transactionType});

  @override
  List<Object?> get props => [id];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'points': points,
      'date': date,
      'amount': amount,
      'transactionType': transactionType,
    };
  }

  factory WalletTransaction.fromMap(Map<String, dynamic> map) {
    return WalletTransaction(
      id: map['id'] ?? "",
      data: map["data"] == null ? null : WalletTransactionData.fromMap(map["data"]),

      title: map['title'] ?? "",
      dataType: map['data']?['type'] ?? "",
      points: map['points'] ?? 0,
      currency: map['currency'] ?? "",
      description: map['description'] ?? "",
      status: map['status'] ?? "",
      date: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      amount: map['amount']??0,
      transactionType: WalletTransactionType.transaction ,
    );
  }

  factory WalletTransaction.random({WalletTransactionType? type}) {
    List<String> names = ["10% discount", "Trip reward", "Trip with alex"];
    return WalletTransaction(
      data: WalletTransactionData(type: ""),
      id: Random().nextInt(2444).toString(),
      title: names[Random().nextInt(names.length)],
      points: Random().nextInt(2444),
      description: "",
      date: DateTime(2023, Random().nextInt(12), Random().nextInt(28)),
      amount: Random().nextInt(2444),
      transactionType: type ??
          WalletTransactionType
              .values[Random().nextInt(WalletTransactionType.values.length)],
      currency: '',
      dataType: '',
      status: '',
    );
  }

  static WalletTransactionType getType(String type) {
    switch (type.toLowerCase()) {
      case "trip":
        return WalletTransactionType.trip;
      case "reward":
        return WalletTransactionType.reward;
      case "discount":
        return WalletTransactionType.discount;
      default:
        return WalletTransactionType.trip;
    }
  }
}
