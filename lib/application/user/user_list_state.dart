part of 'user_list_cubit.dart';

@immutable
abstract class UserListState {}

class UserListInitial extends UserListState {}

class UserListStateRankings extends UserListState {
  final List<User> users;

  UserListStateRankings({required this.users});
}

class UserListStateLoading extends UserListState {}

class UserListStateError extends UserListState {
  final String errorMessage;

  UserListStateError({required this.errorMessage});

  @override
  String toString() {
    return 'UserListStateError{errorMessage: $errorMessage}';
  }
}
