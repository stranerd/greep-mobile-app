import 'dart:io';

import 'package:dio/dio.dart';

class UpdateUserTypeRequest {
  final File license;

  UpdateUserTypeRequest({
    required this.license,
  });

  FormData toMap()  {
    return FormData.fromMap({
      'type': "driver",
      'license':  license,
    });
  }


}
