import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/driver/drivers_cubit.dart';
import 'package:grip/application/response.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/domain/user/UserService.dart';
import 'package:grip/domain/user/model/User.dart';
import 'package:meta/meta.dart';

part 'manager_drivers_state.dart';

class ManagerDriversCubit extends Cubit<ManagerDriversState> {
  final UserService userService;
  final DriversCubit driversCubit;
  late StreamSubscription _streamSubscription;
  bool hasLoaded = false;
  List<User> drivers = [];
  ManagerDriversCubit({required this.driversCubit,required this.userService}) : super(ManagerDriversInitial()){
    _streamSubscription = driversCubit.stream.listen((event) {
      if (event is DriversStateManager){
        drivers = event.drivers;
        emit(ManagerDriversStateFetched(event.drivers));
      }
    });
  }

  void fetchDrivers({bool fullRefresh = false}) async {
    String requestId = GetIt.I<UserCubit>().userId! ;
    if (fullRefresh) {
      emit(ManagerDriversStateLoading());
    }

    // If there is more full refresh, then we can either load a cached data
    // or load paginated data from the server
    if (!fullRefresh) {
      // if there is an already loaded data plus when not a load more request, load cached data
      if (hasLoaded) {
        emit(ManagerDriversStateFetched(drivers));
      } else {
        // if there is no more data, just emit previous loaded data
        // else fetch new paginated data from server
        var response = await userService.fetchUserDrivers(
          requestId,
        );
        _checkResponse(response);
      }
    } else {
      var response = await userService.fetchUserDrivers(
        requestId,
      );

      _checkResponse(response,);
    }
  }

  ManagerDriversState _checkResponse(
      ResponseEntity<List<User>> response,) {
    if (response.isError) {
      var stateError = ManagerDriversStateError(
        errorMessage: response.errorMessage??"",
        isConnectionTimeout: response.isConnectionTimeout,
        isSocket: response.isSocket,
      );
      emit(
        stateError,
      );
      return stateError;
    } else {
      var drivers = response.data!;
        hasLoaded = true;
        drivers = drivers;
        var stateFetched = ManagerDriversStateFetched(drivers);
        emit(stateFetched);
        return stateFetched;

    }
  }


  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
