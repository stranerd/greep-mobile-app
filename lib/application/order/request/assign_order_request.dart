import 'dart:convert';

import 'package:flutter/material.dart';

class AssignOrderRequest {
  final String orderId;

  AssignOrderRequest({
    required this.orderId,
  });

  Map<String, dynamic> toMap() {
    return {

    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

}
