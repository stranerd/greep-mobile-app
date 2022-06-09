import 'package:equatable/equatable.dart';

class User extends Equatable{
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String fullName;
  final String photoUrl;
  final bool isManager;

  const User(
      {required this.id,
      required this.email,
      required this.fullName,
      required this.firstName,
      required this.isManager,
      required this.lastName,
      required this.photoUrl});

  factory User.fromServer(dynamic data) {
    var user = User(
        id: data["id"],
        email: data["bio"]["email"],
        fullName: data["bio"]["name"]["full"],
        firstName: data["bio"]["name"]["first"] ?? "",
        lastName: data["bio"]["name"]["last"] ?? "",
        isManager: data["manager"] != null,
        photoUrl: data["bio"]["photo"]["link"]);
    return user;
  }

  factory User.fromServerAuth(dynamic data) {
    var user = User(
        id: data["id"],
        email: data["email"],
        fullName: data["allNames"]["full"],
        firstName: data["name"]["first"] ?? "",
        lastName: data["name"]["last"] ?? "",
        isManager: false,
        photoUrl: data["photo"]["link"]);
    return user;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'email': this.email,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'fullName': this.fullName,
      'photoUrl': this.photoUrl,
      'isManager': this.isManager,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      email: map['email'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      fullName: map['fullName'] as String,
      photoUrl: map['photoUrl'] as String,
      isManager: map['isManager'] as bool,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, email: $email, firstName: $firstName, lastName: $lastName, fullName: $fullName, photoUrl: $photoUrl, isManager: $isManager}';
  }

  @override
  List<Object?> get props => [id];
}
