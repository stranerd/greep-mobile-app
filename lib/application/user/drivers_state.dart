part of 'drivers_cubit.dart';

@immutable
abstract class DriversState {

}

class DriversInitial extends DriversState {}

class DriversStateDriver extends DriversState {
  final User user;

  DriversStateDriver(this.user);
}

class DriversStateManager extends DriversState {
  final List<User> drivers;

  DriversStateManager(this.drivers);
}
