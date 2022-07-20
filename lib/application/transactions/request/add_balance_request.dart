import 'dart:convert';

class AddBalanceRequest {
  final String parentId;
  final String description;
  final num amount;
  final DateTime dateRecorded;

  const AddBalanceRequest({
    required this.parentId,
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
        "parentId": parentId,
      }
    };
  }


  @override
  String toString() {
    return 'AddBalanceRequest{parentId: $parentId, description: $description, amount: $amount, dateRecorded: $dateRecorded}';
  }

  String toJson(){
    return jsonEncode(toServer());
  }

}
