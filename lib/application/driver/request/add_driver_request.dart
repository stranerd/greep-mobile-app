import 'dart:convert';

class AddDriverRequest {
  final String driverId;
  final num commission;
  final bool add;

  const AddDriverRequest({
    required this.driverId,
    required this.commission,
    required this.add,
  });

  Map<String, dynamic> toServer(){
    return {
      "commission": commission,
      "driverId": driverId,
      "add": add
    };
  }

  String toJson(){
    return jsonEncode(toServer());
  }

}
