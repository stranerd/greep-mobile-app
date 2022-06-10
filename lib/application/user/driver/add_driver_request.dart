import 'dart:convert';

class AddDriverRequest {
  final String driverId;
  final num commission;

  const AddDriverRequest({
    required this.driverId,
    required this.commission,
  });

  Map<String, dynamic> toServer(){
    return {
      "commission": commission,
      "driverId": driverId,
      "add": true
    };
  }

  String toJson(){
    return jsonEncode(toServer());
  }

}
