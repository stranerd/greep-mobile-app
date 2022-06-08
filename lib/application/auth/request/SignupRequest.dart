import 'dart:convert';

import 'package:dio/dio.dart';

class SignUpRequest {
  final String password;
  final String firstName;
  final String middleName;
  final String lastName;
  final String description;
  final String email;
  final MultipartFile photo;

  const SignUpRequest({
    required this.password,
    required this.firstName,
    required this.description,
    required this.lastName,
    required this.middleName,
    required this.email,
    required this.photo
  });

  @override
  String toString() {
    return 'SignUpRequest{password: $password,  fullName: $firstName, email: $email, }';
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'password': this.password,
      'firstName': this.firstName,
      'middleName': this.middleName,
      'lastName': this.lastName,
      'description': this.description,
      'email': this.email,
      'photo': this.photo,
    };
  }

  factory SignUpRequest.fromMap(Map<String, dynamic> map) {
    return SignUpRequest(
      password: map['password'] as String,
      firstName: map['firstName'] as String,
      middleName: map['middleName'] as String,
      lastName: map['lastName'] as String,
      description: map['description'] as String,
      email: map['email'] as String,
      photo: map['photo'] as MultipartFile,
    );
  }
}
