import 'dart:convert';

class AddTripRequest {
  final String customerName;
  final String description;
  final num amount;
  final DateTime dateRecorded;
  final String paymentType;
  final num paidAmount;

  const AddTripRequest({
    required this.customerName,
    required this.description,
    required this.amount,
    required this.dateRecorded,
    required this.paymentType,
    required this.paidAmount,
  });

  Map<String, dynamic> toServer(){
    return {
      "amount": amount,
      "description": description,
      "recordedAt": dateRecorded.millisecondsSinceEpoch,
      "data": {
        "totalAmount": paidAmount,
        "paymentType": paymentType,
        "type": "trip",
        "customerName": customerName,
      }
    };
  }

  String toJson(){
    return jsonEncode(toServer());
  }

}
