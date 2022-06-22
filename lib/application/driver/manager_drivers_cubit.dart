import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/driver/drivers_cubit.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/domain/user/UserService.dart';
import 'package:grip/domain/user/model/User.dart';
import 'package:meta/meta.dart';

part 'manager_drivers_state.dart';

class ManagerDriversCubit extends Cubit<ManagerDriversState> {
  final UserService userService;
  final DriversCubit driversCubit;
  late StreamSubscription _streamSubscription;
  List<User> drivers = [];
  ManagerDriversCubit({required this.driversCubit,required this.userService}) : super(ManagerDriversInitial()){
    _streamSubscription = driversCubit.stream.listen((event) {
      if (event is DriversStateManager){
        drivers = event.drivers;
        emit(ManagerDriversStateFetched(event.drivers));
      }
    });
  }

  void fetchDrivers() async {
    String userId = GetIt.I<UserCubit>().userId! ;
    var response = await userService.fetchUserDrivers(userId);
    if (response.isError){
      emit(ManagerDriversStateError(errorMessage: response.errorMessage!));
    }
    else {
      drivers = response.data ?? const [];
      emit(ManagerDriversStateFetched(drivers));
    }
  }



  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
