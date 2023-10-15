import 'dart:math';

import 'package:greep/domain/user/model/User.dart';

class ChatMessage {
  final String message;
  final User receiver;
  final bool isSender;
  final DateTime date;

  ChatMessage({
    required this.message,
    required this.receiver,
    required this.date,
    required this.isSender
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'receiver': receiver,
      'date': date,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      message: map['message'],
      receiver: map['receiver'],
      date: map['date'],
      isSender: true
    );
  }

  factory ChatMessage.random() {
    List<String> messages = [
      "You're welcome! It's all part of the service. Have a fantastic trip and enjoy your time with your family.",
      "Thank you for the smooth ride, and for taking the alternate route to avoid the traffic.",
      "Perfect timing then! I'll drop you off right at the departure terminal.",
      "Have a safe flight",
      "Thank you once again",
      "Thank you for using greep",
      "I will",
      "We're nearing the airport now."
    ];
    return ChatMessage(
      message: messages[Random().nextInt(messages.length -1)],
      receiver: User(
        id: "id",
        email: "email",
        fullName: "fullName",
        firstName: "firstName",
        hasManager: false,
        lastName: "lastName",
        photoUrl: "photoUrl",
      ),
      date: DateTime.now(),
      isSender: Random().nextBool()
    );
  }
}
