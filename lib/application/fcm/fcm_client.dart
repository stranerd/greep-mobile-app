import 'dart:convert';

import 'package:dio/dio.dart';

abstract class FcmClient {
  static Future<void> sendMessage(
      {required String token,
      required String title,
      required String body,
      required String type, Map<String,dynamic> data = const {}}) async {
    print("sending fcm token $token $title $body");
    const String serverToken = "AAAAz4CCPNQ:APA91bGeNlhNkfMW8PDRracEx9siPP4MF15H3VyQgin_ZDpvvNT05Ow6aZKP86mmy5SBS9woKCuOO-DAk6QRsD_6EIWSPbAnS7ynjcaTaauW1YhYr93wyIpC6xZJ4W6vDy_FCGmYnm-M";
    Response response;
    try {
      response = await Dio().post(
        "https://fcm.googleapis.com/fcm/send",
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$serverToken',
          },
        ),
        data: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'type': type,
              'status': 'done',
              ...data
            },
            'to': token,
          },
        ),
      );
      print("sent fcm successfully ${response.data}");
    } on DioError catch (e) {
      print("Unable to send fcm");
      if (e.type == DioErrorType.response){
        print(e.response!.data);

      }
    }
    catch (e){
      print("exception sending fcm");
    }
  }
}
