part of 'drivers_cubit.dart';

@immutable
abstract class DriversState {

}

class DriversInitial extends DriversState {}

class DriversStateFetched extends DriversState {
  final User selectedUser;

  DriversStateFetched({required this.selectedUser});
}

class DriversStateDriver extends DriversStateFetched {
  final User user;

  DriversStateDriver(this.user) : super(selectedUser: user);
}

class DriversStateManager extends DriversStateFetched {
  final List<User> drivers;

  DriversStateManager(this.drivers,{required User selectedUser}): super(selectedUser: selectedUser);
}
