import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/driver/drivers_cubit.dart';
import 'package:grip/application/response.dart';
import 'package:grip/application/user/user_crud_cubit.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/domain/user/UserService.dart';
import 'package:grip/domain/user/model/User.dart';
import 'package:grip/domain/user/model/driver_commission.dart';
import 'package:meta/meta.dart';

part 'manager_drivers_state.dart';

class ManagerDriversCubit extends Cubit<ManagerDriversState> {
  final UserService userService;
  final DriversCubit driversCubit;
  late StreamSubscription _streamSubscription;
  bool hasLoaded = false;
  List<User> drivers = [];
  List<DriverCommission> driverCommissions = [];

  ManagerDriversCubit({required this.driversCubit, required this.userService})
      : super(ManagerDriversInitial()) {
    _streamSubscription = driversCubit.stream.listen((event) {
      if (event is DriversStateManager) {
        drivers = event.drivers;
        fetchDrivers(softUpdate: true);
      }
    });
  }

  void fetchDrivers({bool fullRefresh = false, bool softUpdate = false}) async {
    String requestId = GetIt.I<UserCubit>().userId!;
    if (fullRefresh && !softUpdate) {
      emit(ManagerDriversStateLoading());
    }

    // If there is more full refresh, then we can either load a cached data
    // or load paginated data from the server
    if (!fullRefresh && !softUpdate) {
      // if there is an already loaded data plus when not a load more request, load cached data
      if (hasLoaded) {
        emit(ManagerDriversStateFetched(_getMappedResults(driverCommissions)));
      } else {
        // if there is no more data, just emit previous loaded data
        // else fetch new paginated data from server
        var response = await userService.fetchUserDriverCommissions(
          requestId,
        );
        _checkResponse(response);
      }
    } else {
      var response = await userService.fetchUserDriverCommissions(
        requestId,
      );

      _checkResponse(
        response,
      );
    }
  }

  ManagerDriversState _checkResponse(
    ResponseEntity<List<DriverCommission>> response,
  ) {
    if (response.isError) {
      var stateError = ManagerDriversStateError(
        errorMessage: response.errorMessage ?? "",
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
      driverCommissions = _getMappedResults(drivers);
      var stateFetched = ManagerDriversStateFetched(driverCommissions);
      emit(stateFetched);
      return stateFetched;
    }
  }


  List<DriverCommission> _getMappedResults(List<DriverCommission> drivers) {
    return drivers.map((e) {
      User? user = this.drivers.any((element) => element.id == e.driverId)
          ? this.drivers.firstWhere((element) => element.id == e.driverId)
          : null;
      return DriverCommission(
          driverId: e.driverId,
          commission: e.commission,
          driverName: user != null ? user.fullName : e.driverId,
          driverPhoto: user != null ? user.photoUrl : e.driverId);
    }).toList();
  }

  void removeDriver({required DriverCommission driver}) async {
    emit(ManagerDriversStateFetched(_getMappedResults(driverCommissions),
        isLoading: true, loadingId: driver.driverId));
    var response = await userService.removeDriver(driver.driverId);
    if (response.isError) {
      emit(ManagerDriversStateFetched(_getMappedResults(driverCommissions),
          errorMessage: response.errorMessage ?? "An error occurred",
          isError: true));
    } else {
      driverCommissions.removeWhere((element) => element.driverId == driver.driverId);
      emit(ManagerDriversStateFetched(_getMappedResults(driverCommissions), isDelete: true));
      fetchDrivers(softUpdate: true);
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
