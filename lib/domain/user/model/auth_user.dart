import 'package:greep/presentation/widgets/custom_phone_field.dart';

class AuthUser {

  final String id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String photo;
  final AppPhoneNumber? phone;
  final bool isVerified;


  String get fullName => "$firstName $lastName";
//<editor-fold desc="Data Methods">
  const AuthUser({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.photo,
    required this.phone,
    required this.isVerified,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthUser &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          username == other.username &&
          email == other.email &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          photo == other.photo &&
          phone == other.phone &&
          isVerified == other.isVerified);

  @override
  int get hashCode =>
      id.hashCode ^
      username.hashCode ^
      email.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      photo.hashCode ^
      phone.hashCode ^
      isVerified.hashCode;

  @override
  String toString() {
    return 'AuthUser{' +
        ' id: $id,' +
        ' username: $username,' +
        ' email: $email,' +
        ' firstName: $firstName,' +
        ' lastName: $lastName,' +
        ' photo: $photo,' +
        ' phone: $phone,' +
        ' isVerified: $isVerified,' +
        '}';
  }

  AuthUser copyWith({
    String? id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? photo,
    AppPhoneNumber? phone,
    bool? isVerified,
  }) {
    return AuthUser(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      photo: photo ?? this.photo,
      phone: phone ?? this.phone,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'photo': photo,
      'phone': phone?.toMap(),
      'isVerified': isVerified,
    };
  }

  factory AuthUser.fromMap(Map<String, dynamic> map) {

    return AuthUser(
      id: map['id'] ?? "",
      username: map['username'] ?? "",
      email: map['email'] ?? "",
      firstName: map["name"]?['first'] ?? "",
      lastName: map["name"]?['last'] ?? "",
      photo: map['photo']?["link"] ?? "",
      phone: map["phone"] == null ?  null : AppPhoneNumber.fromMap(map["phone"]),
      isVerified: map['isVerified'] == true,
    );
  }

//</editor-fold>
}
