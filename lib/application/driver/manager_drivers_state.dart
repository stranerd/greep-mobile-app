part of 'manager_drivers_cubit.dart';

@immutable
abstract class ManagerDriversState {}

class ManagerDriversInitial extends ManagerDriversState {}

class ManagerDriversStateLoading extends ManagerDriversState {}

class ManagerDriversStateFetched extends ManagerDriversState {
  final List<User> drivers;
  final bool isDelete;

  ManagerDriversStateFetched(this.drivers, {this.isDelete = false});
}

class ManagerDriversStateError extends ManagerDriversState {
  final String errorMessage;
  bool isConnectionTimeout;
  bool isSocket;

  ManagerDriversStateError({required this.errorMessage, this.isConnectionTimeout = false, this.isSocket = false});

}
