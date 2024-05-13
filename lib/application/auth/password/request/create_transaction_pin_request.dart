class UpdateTransactionPinRequest {

  final String? oldPin;
  final String pin;

  UpdateTransactionPinRequest({required this.oldPin, required this.pin,});

  Map<String, dynamic> toMap() {
    return {
      'oldPin': oldPin != null ? "\"$oldPin\"" : null,
      'pin': "\"$pin\"",
    };
  }

  factory UpdateTransactionPinRequest.fromMap(Map<String, dynamic> map) {
    return UpdateTransactionPinRequest(
      oldPin: map['oldPin'] as String,
      pin: map['pin'] as String,
    );
  }

  @override
  String toString() {
    return 'CreateTransactionPinRequest{oldPin: $oldPin, pin: $pin}';
  }
}
