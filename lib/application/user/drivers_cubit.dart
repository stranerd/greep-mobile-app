import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:grip/application/auth/AuthenticationCubit.dart';
import 'package:grip/application/auth/AuthenticationState.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/application/user/user_state.dart';
import 'package:grip/domain/user/UserService.dart';
import 'package:grip/domain/user/model/User.dart';
import 'package:meta/meta.dart';

part 'drivers_state.dart';

class DriversCubit extends Cubit<DriversState> {
  final UserCubit userCubit;
  final UserService userService;
  late StreamSubscription _streamSubscription;
  List<User> _drivers = [];
  User? _currentUser;

  DriversCubit({required this.userCubit, required this.userService})
      : super(DriversInitial()) {
    _streamSubscription = userCubit.stream.listen((event) {
      if (event is UserStateFetched) {
        _currentUser = event.user;
        fetchUserDrivers();
      }
    });
  }

  late User _selectedUser;

  User get selectedUser => _selectedUser;

  void fetchUserDrivers() async {
    print("fetching drivers for ${_currentUser!.id}");
    var response = await userService.fetchUserDrivers(_currentUser!.id);
    print(response);
    if (response.isError || response.data!.isEmpty) {
      emit(DriversStateManager([_currentUser!],selectedUser: _currentUser!));
      _selectedUser = _currentUser!;
      return;
    }

    _selectedUser = _currentUser!;
    emit(DriversStateManager(response.data!..insert(0, _currentUser!),selectedUser: _currentUser!));
    _drivers = response.data!;
  }

  void setSelectedUser(User user){
    if (state is! DriversStateManager) return;
    if (_drivers.contains(user)){
      _selectedUser = user;
      emit(DriversStateManager(_drivers, selectedUser: _selectedUser));

    }
  }


  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
