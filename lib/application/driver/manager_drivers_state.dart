part of 'manager_drivers_cubit.dart';

abstract class ManagerDriversState {}

class ManagerDriversInitial extends ManagerDriversState {}

class ManagerDriversStateLoading extends ManagerDriversState {
}

class ManagerDriversStateFetched extends ManagerDriversState {
  final List<DriverCommission> drivers;
  final bool isDelete;
  final bool isError;
  final String errorMessage;
  final bool isLoading;
  final String loadingId;

  ManagerDriversStateFetched(this.drivers, {this.isDelete = false,this.isLoading = false, this.loadingId = "",this.errorMessage="",this.isError=false});
}

class ManagerDriversStateError extends ManagerDriversState {
  final String errorMessage;
  bool isConnectionTimeout;
  bool isSocket;

  ManagerDriversStateError({required this.errorMessage, this.isConnectionTimeout = false, this.isSocket = false});

}
