class TransferMoneyRequest {
  final String pin;
  final num amount;
  final String to;
  final String note;

  TransferMoneyRequest({
    required this.pin,
    required this.amount,
    required this.to,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'pin': "\"$pin\"",
      'amount': amount,
      'to': to,
      'note': note,
    };
  }

  factory TransferMoneyRequest.fromMap(Map<String, dynamic> map) {
    return TransferMoneyRequest(
      pin: map['pin'] as String,
      amount: map['amount'] as num,
      to: map['to'] as String,
      note: map['note'] as String,
    );
  }
}
