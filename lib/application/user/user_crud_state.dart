part of 'user_crud_cubit.dart';

abstract class UserCrudState {}

class UserCrudInitial extends UserCrudState {}

class UserCrudStateLoading extends UserCrudState {}

class UserCrudStateSuccess extends UserCrudState {
  final bool isDriverAdd;

  UserCrudStateSuccess({this.isDriverAdd = false});
}

class UserCrudStateFailure extends UserCrudState {
  final String errorMessage;

  UserCrudStateFailure({required this.errorMessage});
}
