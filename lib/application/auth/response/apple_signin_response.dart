class AppleSigninResponse {
  final String firstName;
  final String lastName;
  final String identifier;
  final String email;

  AppleSigninResponse(
      {required this.firstName,
      required this.lastName,
      required this.identifier,
      required this.email,
      });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'identifier': identifier,
      'email': email,
    };
  }

  factory AppleSigninResponse.fromMap(Map<String, dynamic> map) {
    return AppleSigninResponse(
      firstName: map['name'] as String,
      lastName: map['lastName'],
      identifier: map['identifier'] as String,
      email: map['email']??"",
    );
  }

  @override
  String toString() {
    return 'AppleSigninResponse{firstName: $firstName, lastName: $lastName, identifier: $identifier, email: $email}';
  }
}
