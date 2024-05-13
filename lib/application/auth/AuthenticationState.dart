import 'package:greep/domain/user/model/auth_user.dart';

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
  final bool isSignup;
  final bool isEarlySignup;
  final AuthUser? user;


  AuthenticationStateAuthenticated({
    required this.token,
    this.isSignup = false,
    this.isEarlySignup = false,
    this.user,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'userId': userId,
      'isSignup': isSignup,
      'isEarlySignup': isEarlySignup,
      'user': user?.toMap()
    };
  }

  factory AuthenticationStateAuthenticated.fromMap(Map<String, dynamic> map) {
    return AuthenticationStateAuthenticated(
      token: map['token'] as String,
      userId: map['userId'] as String,
      isSignup: map['isSignup'] as bool,
      isEarlySignup: map['isEarlySignup'] as bool,
    );
  }

  @override
  String toString() {
    return 'AuthenticationStateAuthenticated{token: $token, userId: $userId, isSignup: $isSignup, isEarlySignup: $isEarlySignup, user: $user}';
  }
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
