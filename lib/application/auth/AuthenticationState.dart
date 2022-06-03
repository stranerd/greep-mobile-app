abstract class AuthenticationState {}

class AuthenticationStateUninitialized extends AuthenticationState {}

class AuthenticationStateLoading extends AuthenticationState {
  final bool isGoogle;

  AuthenticationStateLoading({this.isGoogle = false});


}

class AuthenticationStateNotAuthenticated extends AuthenticationState {}

class AuthenticationStateAuthenticated extends AuthenticationState {
  final String token;
  final String userId;

  AuthenticationStateAuthenticated({required this.token, required this.userId});
}

class AuthenticationStateError extends AuthenticationState {
  final String errorMessage;
  bool isConnectionTimeout;
  bool isSocket;
  Map<String, dynamic> fieldErrors;

  AuthenticationStateError(this.errorMessage,
      {this.isConnectionTimeout = false,
      this.isSocket = false,
      this.fieldErrors = const {}});
}
