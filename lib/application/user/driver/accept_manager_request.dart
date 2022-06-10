import 'dart:convert';

class AcceptManagerRequest {
  final String managerId;
  final bool accept;

  const AcceptManagerRequest({
    required this.managerId,
    required this.accept,
  });

  Map<String, dynamic> toServer(){
    return {
      "driverId": managerId,
      "add": accept
    };
  }

  String toJson(){
    return jsonEncode(toServer());
  }

}
