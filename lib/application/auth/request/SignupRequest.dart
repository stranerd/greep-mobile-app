import 'dart:convert';

import 'package:dio/dio.dart';

class SignUpRequest {
  final String password;
  final String firstName;
  final String lastName;
  final String path;
  final String email;
  final MultipartFile photo;

  const SignUpRequest({
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.path,
    required this.email,
    required this.photo
  });


  @override
  String toString() {
    return 'SignUpRequest{password: $password, firstName: $firstName, lastName: $lastName, email: $email, photo: $photo}';
  }

  FormData toFormData(){
    var formData = FormData.fromMap(toMap());
    formData.files.add(MapEntry("photo", photo));
    print(formData.files);
    return formData;
  }
  String toJson() {
    return jsonEncode(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'password': this.password,
      // 'firstName': this.firstName,
      'lastName': this.lastName,
      'email': this.email,
    };
  }

}
