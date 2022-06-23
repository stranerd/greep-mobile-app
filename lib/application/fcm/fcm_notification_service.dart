import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/fcm/fcm_client.dart';
import 'package:grip/application/fcm/fcm_content.dart';
import 'package:grip/application/local_notification/local_notification_service.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  LocalNotificationService localNotificationService =
      LocalNotificationService();
  var content = FcmContent.fromServer(message);
  if (content.isNotification) {


    localNotificationService.show(notification: content.fcmNotification!);
  }
}

class FCMNotificationService {
  final LocalNotificationService localNotificationService =
      LocalNotificationService();
  static final FCMNotificationService _instance =
      FCMNotificationService._privateConstructor();

  FCMNotificationService._privateConstructor();

  factory FCMNotificationService() {
    return _instance;
  }

  factory FCMNotificationService.initialize() {
    var instance = _instance;
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((message) {
      instance._foreGroundMessageHandler(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      instance.onMessageOpenedAppHandler(message);
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    return instance;
  }

  static void sendMessage(
      {required String token,
      required String title,
      required String body,
      required String type}) {
    FcmClient.sendMessage(token: token, title: title, body: body, type: type);
  }

  void onMessageOpenedAppHandler(RemoteMessage message) async {
  }

  void _foreGroundMessageHandler(RemoteMessage message) async {
    var content = FcmContent.fromServer(message);
    if (content.isNotification) {
      var type = message.data["type"];
    }
  }
}
