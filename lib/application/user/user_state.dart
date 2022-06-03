
import 'package:grip/domain/user/model/User.dart';

abstract class UserState {}

class UserStateUninitialized extends UserState {}

class UserStateFetched extends UserState {
  final User user;

  UserStateFetched(this.user);
}

class UserStateLoading extends UserState {}

class UserStateError extends UserState {
  final String? errorMessage;
  bool isConnectionTimeout;
  bool isSocket;

  UserStateError(this.errorMessage,
      {this.isConnectionTimeout = false, this.isSocket = false});
}
