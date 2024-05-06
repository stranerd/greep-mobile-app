import 'package:greep/application/response.dart';
import 'package:greep/domain/notification/notification_client.dart';
import 'package:greep/domain/notification/user_notification.dart';

class NotificationService {
  final NotificationClient notificationClient;

  NotificationService({required this.notificationClient});

  Future<ResponseEntity<List<UserNotification>>>
      fetchUserNotifications() async {
    return await notificationClient.fetchUserNotifications();
  }
}
