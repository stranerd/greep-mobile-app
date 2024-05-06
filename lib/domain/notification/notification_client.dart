import 'dart:io';

import 'package:dio/dio.dart';
import 'package:greep/application/dio_config.dart';
import 'package:greep/application/response.dart';
import 'package:greep/domain/notification/user_notification.dart';

class NotificationClient {


  final Dio dio = dioClient();


  Future<ResponseEntity<List<UserNotification>>> fetchUserNotifications() async {
    Response response;
    try {
      response = await dio.get("notifications/notifications");
      List<UserNotification> notifications = [];

      print("response notifications ${response.data} ");

      response.data["results"].forEach((e) {
        notifications.add(UserNotification.fromMap(e));
      });

      return ResponseEntity.Data(notifications);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
        print("notificationError ${e.response?.data} ${e.response?.statusCode}");
        dynamic error = e.response!.data;
        String message = "";
        if (error == null) {
          message = "An error occurred fetching notifications";
        } else {
          message = error["message"] ?? "";
        }
        return ResponseEntity.Error(message);
      }
      return ResponseEntity.Error("An error occurred fetching notifications");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred fetching notifications. Try again");
    }
  }


}
