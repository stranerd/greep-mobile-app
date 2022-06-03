import 'dart:convert';

class SignUpRequest {
  final String password;
  final String fullName;
  final String email;
  final bool isGoogleSignIn;

  SignUpRequest({
    required this.password,
    this.isGoogleSignIn = false,
    required this.fullName,
    required this.email,
  });


  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'password': this.password,
      'fullName': this.fullName,
      'email': this.email,
      'isGoogleSignIn': this.isGoogleSignIn,
    } as Map<String, dynamic>;
  }


  @override
  String toString() {
    return 'SignUpRequest{password: $password,  fullName: $fullName, email: $email, }';
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
