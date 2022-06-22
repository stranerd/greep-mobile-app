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

  ManagerDriversStateError({required this.errorMessage});

}
