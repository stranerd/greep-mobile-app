import 'package:firebase_messaging/firebase_messaging.dart';

Future<String> fcmToken()async {
  return await FirebaseMessaging.instance.getToken() ?? "";
}
