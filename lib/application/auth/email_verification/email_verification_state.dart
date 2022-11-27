part of 'email_verification_cubit.dart';

@immutable
abstract class EmailVerificationState {}

class EmailVerificationInitial extends EmailVerificationState {}

class EmailVerificationStateLoading extends EmailVerificationState {}

class EmailVerificationStateError extends EmailVerificationState {
  final String errorMessage;

  EmailVerificationStateError({required this.errorMessage});


}

class EmailVerificationCodeSent extends EmailVerificationState {}

class EmailVerificationSuccess extends EmailVerificationState {}
