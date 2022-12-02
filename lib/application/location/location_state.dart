import 'package:greep/application/location/location.dart';

abstract class LocationState {}

class LocationStateUninitialized extends LocationState {}

class LocationStateOff extends LocationState {}

class LocationStateOn extends LocationState {
  final Location location;

  LocationStateOn(this.location);
}
