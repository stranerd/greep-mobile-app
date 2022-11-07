class AppleSigninRequest {
  final String? email;
  final String idToken;
  final String? firstName;
  final String? lastName;

  const AppleSigninRequest({
    required this.email,
    required this.idToken,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'email': email,
      'idToken': idToken,
      'firstName': firstName,
      'lastName': lastName,
    } as Map<String, dynamic>;
  }
}
