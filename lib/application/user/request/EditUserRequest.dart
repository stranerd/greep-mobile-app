import 'dart:convert';

import 'package:dio/dio.dart';

/// @author Ibekason Alexander

class EditUserRequest {
  final String firstName;
  final String lastName;
  final MultipartFile? photo;

  const EditUserRequest({
      required this.firstName,
      required this.lastName,
      required this.photo});

  Map<String, dynamic> toMap() {
    Map<String,dynamic> map = {
      'firstName': firstName,
      'lastName': lastName,
    };
    if (photo!=null){
      map.putIfAbsent("photo", () => photo);
    }
    return map;
  }

  FormData toFormData() {
  return FormData.fromMap(toMap());
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
