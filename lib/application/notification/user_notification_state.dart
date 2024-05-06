part of 'user_notification_cubit.dart';

abstract class UserNotificationState {}

class UserNotificationInitial extends UserNotificationState {}
class UserNotificationStateLoading extends UserNotificationState {}

class UserNotificationStateError extends UserNotificationState {
  final String errorMessage;
  final bool isConnectionTimeout;
  final bool isSocket;
  UserNotificationStateError({this.isConnectionTimeout = false, this.isSocket = false, required this.errorMessage});

}

class UserNotificationStateFetched extends UserNotificationState {
  final List<UserNotification> notifications;

  UserNotificationStateFetched({
    required this.notifications,
  });



  @override
  String toString() {
    return 'UserNotificationStateFetched{notifications: $notifications}';
  }
}
