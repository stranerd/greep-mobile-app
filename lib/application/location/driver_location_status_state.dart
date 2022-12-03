part of 'driver_location_status_cubit.dart';

abstract class DriverLocationStatusState {}

class DriverLocationStatusStateFetched extends DriverLocationStatusState {
  final DriverLocation status;

  DriverLocationStatusStateFetched({required this.status});
}

class DriverLocationStatusStateLoading extends DriverLocationStatusState {}

class DriverLocationStatusStateError extends DriverLocationStatusState {
  final String? errorMessage;
  bool isConnectionTimeout;
  bool isSocket;

  DriverLocationStatusStateError(this.errorMessage,
      {this.isConnectionTimeout = false, this.isSocket = false});
}
