import 'dart:convert';

/// @author Ibekason Alexander

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.password, required this.email,});

  Map<String, dynamic> toLogin() {
    return {
      "email": email,
      "password": password,
    };
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'email': email,
      "password": password,
    } as Map<String, dynamic>;
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  @override
  String toString() {
    return 'LoginRequest{email: $email, password: $password}';
  }
}
