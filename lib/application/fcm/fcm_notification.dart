import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'fcm_notification_payload.dart';

class FcmNotification {
  final int id;
  final String title;
  final String body;
  final String channelKey;
  final String? payload;

  FcmNotification(
      {required this.id,
      required this.title,
      required this.body,
      required this.channelKey,
      this.payload});

  factory FcmNotification.fromServer(RemoteNotification data, Map<String, dynamic> content) {
    return FcmNotification(
        id: 3,
        title: data.title ??"",
        body: data.body ?? "",
        channelKey: "channelKey",
        payload: jsonEncode(content));
  }

  @override
  String toString() {
    return 'FcmNotification{id: $id, title: $title, body: $body, channelKey: $channelKey, payload: $payload}';
  }
}
