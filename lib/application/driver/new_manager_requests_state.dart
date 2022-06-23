part of 'new_manager_requests_cubit.dart';

abstract class NewManagerRequestsState {}

class NewManagerRequestsStateInitial extends NewManagerRequestsState {}

class NewManagerRequestsStateAvailable extends NewManagerRequestsState {
  final ManagerRequest request;

  NewManagerRequestsStateAvailable({required this.request});
}

class NewManagerRequestsStateUnAvailable extends NewManagerRequestsState {}
