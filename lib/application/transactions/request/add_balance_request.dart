import 'dart:convert';

class AddBalanceRequest {
  final String customerId;
  final String description;
  final num amount;
  final DateTime dateRecorded;

  const AddBalanceRequest({
    required this.customerId,
    required this.description,
    required this.amount,
    required this.dateRecorded,
  });

  Map<String, dynamic> toServer(){
    return {
      "amount": amount,
      "description": description,
      "recordedAt": dateRecorded.millisecondsSinceEpoch,
      "data": {
        "type": "balance",
        "customerId": customerId,
      }
    };
  }

  String toJson(){
    return jsonEncode(toServer());
  }

}
