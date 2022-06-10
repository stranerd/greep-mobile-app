import 'dart:convert';

import 'package:dio/dio.dart';

/// @author Ibekason Alexander

class SignUpRequest {
  final String password;
  final String firstName;
  final String lastName;
  final String path;
  final String email;
  final MultipartFile photo;

  const SignUpRequest(
      {required this.password,
      required this.firstName,
      required this.lastName,
      required this.path,
      required this.email,
      required this.photo});

  Map<String, dynamic> toMap() {
    // print(photo.contentType);
    return {
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'photo': photo
    };
  }

  FormData toFormData() {
    var formData = FormData.fromMap(toMap());
    // formData.files.add(MapEntry("photo", photo));
    return formData;
  }

  @override
  String toString() {
    return 'SignUpRequest{password: $password, firstName: $firstName, lastName: $lastName, email: $email, photo: $photo}';
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
