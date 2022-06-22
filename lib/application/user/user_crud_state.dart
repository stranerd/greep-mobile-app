part of 'user_crud_cubit.dart';

abstract class UserCrudState {}

class UserCrudInitial extends UserCrudState {}

class UserCrudStateLoading extends UserCrudState {
  final bool isManagerAdd;
  final bool isManagerReject;

  UserCrudStateLoading({this.isManagerAdd = false,this.isManagerReject = false});

  @override
  String toString() {
    return 'UserCrudStateLoading{isManagerAdd: $isManagerAdd, isManagerReject: $isManagerReject}';
  }
}

class UserCrudStateSuccess extends UserCrudState {
  final bool isDriverAdd;
  final bool isManagerAdd;
  final bool isManagerReject;
  final bool isEditUser;

  UserCrudStateSuccess({this.isDriverAdd = false,this.isManagerAdd = false,this.isManagerReject = false,  this.isEditUser = false});
}

class UserCrudStateFailure extends UserCrudState {
  final String errorMessage;

  UserCrudStateFailure({required this.errorMessage});
}
