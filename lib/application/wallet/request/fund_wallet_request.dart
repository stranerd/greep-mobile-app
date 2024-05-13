import 'package:flutter/material.dart';

class FundWalletRequest {

  final num amount;
  final String pin;

  FundWalletRequest({required this.amount, required this.pin});

  Map<String, dynamic> toMap() {
    return {
      'amount': this.amount,
      'pin': '\"$pin\"',
    };
  }

  factory FundWalletRequest.fromMap(Map<String, dynamic> map) {
    return FundWalletRequest(
      amount: map['amount'] as num,
      pin: map['pin'] as String,
    );
  }
}
