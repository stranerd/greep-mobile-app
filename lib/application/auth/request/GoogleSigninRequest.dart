class GoogleSigninRequest {
  final String email;
  final String uuid;
  final String? displayName;
  final String? photoUrl;
  final String? phoneNumber;

  const GoogleSigninRequest({
    required this.email,
    required this.uuid,
    required this.displayName,
    required this.photoUrl,
    required this.phoneNumber,
  });

  factory GoogleSigninRequest.fromMap(Map<String, dynamic> map) {
    return new GoogleSigninRequest(
      email: map['email'] as String,
      uuid: map['uuid'] as String,
      displayName: map['displayName'] as String?,
      photoUrl: map['photoUrl'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'email': this.email,
      'uuid': this.uuid,
      'displayName': this.displayName,
      'photoUrl': this.photoUrl,
      'phoneNumber': this.phoneNumber,
    } as Map<String, dynamic>;
  }
}
