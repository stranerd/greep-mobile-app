import 'package:equatable/equatable.dart';

class User extends Equatable{
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String username;
  final String fullName;
  final String photoUrl;
  String? managerName;
  final bool hasManager;
  final num? commission;
  final String? managerId;

   User(
      {required this.id,
      required this.email,
      required this.fullName,
        this.managerId,
        required this.username,
        this.commission,
        this.managerName,
      required this.firstName,
      required this.hasManager,
      required this.lastName,
      required this.photoUrl});

  factory User.fromServer(dynamic data) {
    var user = User(
        id: data["id"],
        email: data["bio"]["email"],
        fullName: data["bio"]["name"]["full"],
        username: data["bio"]["username"] ?? "",
        firstName: data["bio"]["name"]["first"] ?? "",
        lastName: data["bio"]["name"]["last"] ?? "",
        hasManager: data["manager"] != null,
        managerId: data["manager"] != null ? data["manager"]["managerId"]: null,
        commission: data["manager"] != null ? data["manager"]["commission"]: null,
        photoUrl: data["bio"]["photo"]["link"]);
    return user;
  }

  factory User.fromServerAuth(dynamic data) {
    var user = User(
        id: data["id"],
        email: data["email"],
        username: data["username"] ?? "",
        fullName: data["allNames"]["full"],
        firstName: data["name"]["first"] ?? "",
        lastName: data["name"]["last"] ?? "",
        hasManager: false,
        photoUrl: data["photo"]["link"]);
    return user;
  }


  @override
  String toString() {
    return 'User{id: $id, email: $email, firstName: $firstName, lastName: $lastName, fullName: $fullName, photoUrl: $photoUrl, isManager: $hasManager, commission: $commission, managerId: $managerId}';
  }

  @override
  List<Object?> get props => [id];
}
