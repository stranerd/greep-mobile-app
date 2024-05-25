import 'dart:convert';

import 'package:flutter/material.dart';

class CompleteOrderRequest {
  final String orderId;
  final String token;

  CompleteOrderRequest({
    required this.orderId,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      "token": "\"$token\"",

    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

}
