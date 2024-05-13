class ConfirmResetPINRequest {

  final String pin;
  final String token;

  ConfirmResetPINRequest({required this.pin, required this.token});

  Map<String, dynamic> toMap() {
    return {
      'pin': "\"$pin\"",
      'token': token,
    };
  }

  factory ConfirmResetPINRequest.fromMap(Map<String, dynamic> map) {
    return ConfirmResetPINRequest(
      pin: map['pin'] ?? "",
      token: map['token'] as String,
    );
  }
}
