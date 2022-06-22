part of 'manager_requests_cubit.dart';

@immutable
abstract class ManagerRequestsState {}

class ManagerRequestsInitial extends ManagerRequestsState{}

class ManagerRequestsAvailable extends ManagerRequestsState {
  final ManagerRequest request;

  ManagerRequestsAvailable(this.request);
}

class ManagerRequestsUnAvailable extends ManagerRequestsState {}
