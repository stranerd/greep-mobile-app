part of 'reset_password_cubit.dart';

@immutable
abstract class PasswordCrudState {}

class PasswordCrudInitial extends PasswordCrudState {}

class PasswordCrudStateLoading extends PasswordCrudState {}

class PasswordCrudStateError extends PasswordCrudState {
  final String errorMessage;

  PasswordCrudStateError({required this.errorMessage});


}

class PasswordCrudStateCodeSent extends PasswordCrudState {}

class PasswordCrudStateSuccess extends PasswordCrudState {}
