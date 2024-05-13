import 'package:equatable/equatable.dart';
import 'package:greep/domain/user/model/User.dart';

class MessageList extends Equatable {
  final String id;
  final num unreadCount;
  final String message;
final DateTime date;
  final User receiver;

  const MessageList({required this.date,
      required this.id,
      required this.unreadCount,
      required this.message,
      required this.receiver});

  @override
  List<Object?> get props => [id];

  factory MessageList.random() {
    return MessageList(
        id: "ddd",
        unreadCount: 2,
        date: DateTime.now(),
        message: "How are you doing",
        receiver: User(
            id: "id",
            email: "email",
            isVerified: false,
            username: "",
            fullName: "Ibekason",
            firstName: "Alexander",
            hasManager: false,
            lastName: "",
            photoUrl: ""));
  }
}
