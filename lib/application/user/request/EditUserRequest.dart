import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:greep/presentation/widgets/custom_phone_field.dart';
/// @author Ibekason Alexander

class EditUserRequest {
  final String firstName;
  final String lastName;
  final MultipartFile? photo;
  final AppPhoneNumber phoneNumber;
  final String username;

  const EditUserRequest({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.photo,
    required this.username,
  });

  Map<String, dynamic> toMap() {
    Map<String,dynamic> map = {
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      "phone": jsonEncode({
        "code": phoneNumber.code,
        "number": phoneNumber.number,
      }),
    };


    return map;
  }

  FormData toFormData() {
    FormData formData =FormData.fromMap(toMap());
    if (photo!=null){
      formData.files.add(MapEntry("photo", photo!,));
    }
    return formData;
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
