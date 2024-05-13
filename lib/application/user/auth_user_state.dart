part of 'auth_user_cubit.dart';

abstract class AuthUserState {}

class AuthUserStateUninitialized extends AuthUserState {}

class AuthUserStateFetched extends AuthUserState {
  final AuthUser user;

  AuthUserStateFetched(this.user);
}

class AuthUserStateLoading extends AuthUserState {}

class AuthUserStateError extends AuthUserState {
  final String? errorMessage;
  bool isConnectionTimeout;
  bool isSocket;

  AuthUserStateError(this.errorMessage,
      {this.isConnectionTimeout = false, this.isSocket = false});
}
