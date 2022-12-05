
abstract class GeoCoderState {}

class GeoCoderStateUninitialized extends GeoCoderState {}

class GeoCoderStateFetched extends GeoCoderState {
  final String address;

  GeoCoderStateFetched(this.address);
}

class GeoCoderStateLoading extends GeoCoderState {}

class GeoCoderStateError extends GeoCoderState {
  final String? errorMessage;
  bool isConnectionTimeout;
  bool isSocket;

  GeoCoderStateError(
    this.errorMessage, {
    this.isConnectionTimeout = false,
    this.isSocket = false,
  });
}
