import 'dart:convert';

import 'package:flutter/material.dart';

class AcceptOrderRequest {
  final String message;
  final String orderId;
  final bool isAccepting;

  AcceptOrderRequest({
    required this.message,
    required this.orderId,
    required this.isAccepting,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'accepted': isAccepting,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory AcceptOrderRequest.fromMap(Map<String, dynamic> map) {
    return AcceptOrderRequest(
      message: map['message'] as String,
      orderId: map['orderId'] as String,
      isAccepting: map['isAccepting'] as bool,
    );
  }
}
