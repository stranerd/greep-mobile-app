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
      "managerId": managerId,
      "accept": accept
    };
  }

  String toJson(){
    return jsonEncode(toServer());
  }

}
