import 'dart:convert';

class GoogleSigninRequest {
  final String accessToken;
  final String idToken;


  const GoogleSigninRequest({
    required this.accessToken,
    required this.idToken,
  });

  String toJson(){
    return jsonEncode(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'accessToken': this.accessToken,
      'idToken': this.idToken,
    };
  }

  factory GoogleSigninRequest.fromMap(Map<String, dynamic> map) {
    return GoogleSigninRequest(
      accessToken: map['accessToken'] as String,
      idToken: map['idToken'] as String,
    );
  }
}
