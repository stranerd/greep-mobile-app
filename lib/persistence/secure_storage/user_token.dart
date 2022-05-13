class UserToken {
  String _rawToken;
  String get token => _rawToken;

  factory UserToken.fromJson(Map<String, dynamic> json) {
    final rawToken = json['accessToken'];

    return UserToken(rawToken: rawToken);
  }

  UserToken({
    required String rawToken,
  }) : _rawToken = rawToken;
}
