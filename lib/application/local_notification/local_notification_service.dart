import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/fcm/fcm_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalNotificationService {
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'channelId1', // id
    'ChannelTitle2', // title
    description: 'This channel is used for important notifications.',
    // description
    importance: Importance.max,
    sound: RawResourceAndroidNotificationSound('sound'),
    playSound: true,
  );

  static const AndroidNotificationChannel channel2 = AndroidNotificationChannel(
    'high_importance_channel 2', // id
    'High Importance Notifications 2', // title
    description: 'This channel is used for important notifications 2.',
    // description
    importance: Importance.max,
    sound: RawResourceAndroidNotificationSound('normal'),
    playSound: true,
  );

  static final LocalNotificationService _instance =
  LocalNotificationService._privateConstructor();

  LocalNotificationService._privateConstructor();

  factory LocalNotificationService() {
    return _instance;
  }

  static void initialize() async {
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    await FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel2);

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
    );
    await FlutterLocalNotificationsPlugin().initialize(initializationSettings,
        onDidReceiveNotificationResponse: selectNotification);
  }

  void show({required FcmNotification notification,}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      "Channel1Id",
      "Channel1Title",
      channelDescription: "Channel1Desc",
      importance: Importance.max,
      autoCancel: true,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await FlutterLocalNotificationsPlugin().show(notification.id,
        notification.title, notification.body, platformChannelSpecifics,
        payload: notification.payload);
  }

  static Future onDidReceiveLocalNotification(int id, String? title,
      String? body, String? payload) {
    return Future(
            () => {print("Receive local notification: payload: $payload ")});
  }

  static Future selectNotification(_) async {
  }
}
