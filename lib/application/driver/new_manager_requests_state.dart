part of 'new_manager_requests_cubit.dart';

abstract class NewManagerRequestsState {}

class NewManagerRequestsStateFetched extends NewManagerRequestsState {
  final ManagerRequest request;

  NewManagerRequestsStateFetched({required this.request});
}

class NewManagerRequestsStateLoading extends NewManagerRequestsState {}

class NewManagerRequestsStateError extends NewManagerRequestsState {
  final String? errorMessage;
  bool isConnectionTimeout;
  bool isSocket;

  NewManagerRequestsStateError(this.errorMessage,
      {this.isConnectionTimeout = false, this.isSocket = false});
}
