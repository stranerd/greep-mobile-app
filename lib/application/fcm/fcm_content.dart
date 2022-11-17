import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:greep/application/fcm/fcm_message_model.dart';
import 'package:greep/application/fcm/fcm_notification.dart';

class FcmContent {
  final FcmMessage? fcmMessage;
  final FcmNotification? fcmNotification;
  final bool isNotification;

  FcmContent(
      {this.fcmMessage,
      required this.fcmNotification,
      required this.isNotification});

  factory FcmContent.fromServer(RemoteMessage data) {
    FcmNotification? notification = data.notification != null
        ? FcmNotification.fromServer(data.notification!, data.data)
        : null;
    FcmMessage? message =
        data.data.isNotEmpty ? FcmMessage.fromServer() : null;

    return FcmContent(
      fcmNotification: notification,
      isNotification: notification!=null,
      fcmMessage: message,
    );
  }

  @override
  String toString() {
    return 'FcmContent{fcmMessage: $fcmMessage, fcmNotification: $fcmNotification, isNotification: $isNotification}';
  }
}
