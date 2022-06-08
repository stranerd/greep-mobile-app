abstract class SignupState {}

class SignupStateUninitialized extends SignupState {}

class SignupStateLoading extends SignupState {}

class SignupStateSuccess extends SignupState {}

class SignupStateError extends SignupState {
  final String? errorMessage;
  bool isConnectionTimeout;
  bool isSocket;
  Map<String, dynamic> fieldErrors;

  SignupStateError(this.errorMessage,
      {this.isConnectionTimeout = false,
      this.isSocket = false,
      this.fieldErrors = const {}});
}
