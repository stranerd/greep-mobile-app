part of 'reset_password_cubit.dart';

@immutable
abstract class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordStateLoading extends ResetPasswordState {}

class ResetPasswordStateError extends ResetPasswordState {
  final String errorMessage;

  ResetPasswordStateError({required this.errorMessage});


}

class ResetPasswordCodeSent extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {}
