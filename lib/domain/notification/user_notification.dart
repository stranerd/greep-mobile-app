import 'package:equatable/equatable.dart';

enum NotificationType {
  AccountApplication,
  WalletFundSuccessful,
  WithdrawalSuccessful,
  WithdrawalFailed,
  RequestPaid,
  RequestRejected,
  RequestAcknowledged,
}

class UserNotification extends Equatable {
  final String id;
  final String title;
  final String body;
  final bool seen;
  final bool sendEmail;
  final DateTime date;
  final NotificationData data;

  const UserNotification(
      {required this.id,
      required this.title,
      required this.body,
      required this.seen,
      required this.sendEmail,
      required this.date,
      required this.data});

  @override
  List<Object?> get props => [id];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'seen': seen,
      'sendEmail': sendEmail,
      'date': date,
      'data': data,
    };
  }

  factory UserNotification.random() {
    return UserNotification(
        id: "id",
        title: "ffg",
        body: "body",
        seen: true,
        sendEmail: true,
        date: DateTime.now(),
        data: NotificationData(
            type: NotificationType.WithdrawalFailed,
            amount: 4,
            currency: "currency",
            accepted: false,
            message: "message"));
  }

  factory UserNotification.fromMap(Map<String, dynamic> map) {
    return UserNotification(
      id: map['id'] ?? "",
      title: map['title'] ?? "",
      body: map['body'] ?? "",
      seen: map['seen'] == true,
      sendEmail: map['sendEmail'] == true,
      date: DateTime.fromMillisecondsSinceEpoch(map["updatedAt"]),
      data: NotificationData.fromMap(map["data"]),
    );
  }
}

class NotificationData {
  final NotificationType type;
  final num? amount;
  final String? currency;
  final bool? accepted;
  final String? message;

  NotificationData(
      {required this.type,
      required this.amount,
      required this.currency,
      required this.accepted,
      required this.message});

  static NotificationType getType(String type) {
    switch (type) {
      case "AccountApplication":
        return NotificationType.AccountApplication;
      case "WalletFundSuccessful":
        return NotificationType.WalletFundSuccessful;
      case "WithdrawalSuccessful":
        return NotificationType.WithdrawalSuccessful;
      case "WithdrawalFailed":
        return NotificationType.WithdrawalFailed;
      case "RequestPaid":
        return NotificationType.RequestPaid;
      case "RequestRejected":
        return NotificationType.RequestRejected;
      case "RequestAcknowledged":
        return NotificationType.RequestAcknowledged;
      default:
        return NotificationType.AccountApplication;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'amount': amount,
      'currency': currency,
      'accepted': accepted,
      'message': message,
    };
  }

  factory NotificationData.fromMap(Map<String, dynamic> map) {
    return NotificationData(
      type: getType(map['type'] ?? ""),
      amount: map['amount'],
      currency: map['currency'],
      accepted: map['accepted'],
      message: map['message'],
    );
  }
}
