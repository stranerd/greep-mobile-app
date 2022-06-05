import 'dart:convert';

class AddExpenseRequest {
  final String name;
  final String description;
  final num amount;
  final DateTime dateRecorded;

  const AddExpenseRequest({
    required this.name,
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
        "type": "trip",
        "name": name,
      }
    };
  }

  String toJson(){
    return jsonEncode(toServer());
  }

}
