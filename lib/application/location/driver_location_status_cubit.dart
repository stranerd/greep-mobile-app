import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greep/application/location/location.dart';
import 'package:greep/domain/firebase/Firebase_service.dart';
import 'package:greep/domain/user/model/driver_location_status.dart';
import 'package:greep/domain/user/model/ride_status.dart';

part 'driver_location_status_state.dart';

class DriverLocationStatusCubit extends Cubit<DriverLocationStatusState> {
  DriverLocationStatusCubit() : super(DriverLocationStatusStateLoading());
  StreamSubscription? _streamSubscription;

  void checkOnlineStatus(String userId) {
    print("checking online statsu $userId ");
    var statusStream = FirebaseApi.getDriverLocation(userId);
    var status = statusStream.asyncMap((event) =>
        event.docs.map((e) => DriverLocation.fromServer(e.data())).toList());
    _streamSubscription = status.listen((event) {
      if (event.isNotEmpty) {
        emit(DriverLocationStatusStateFetched(status: event.first));
      } else {
        // if user has no updated online status, create new record
        setDriverLocationStatus(userId);

        emit(DriverLocationStatusStateFetched(
            status: DriverLocation(
                rideStatus: RideStatus.ended,
                latitude: "",
                longitude: "",
                driverId: userId,
                updatedAt: DateTime.now().subtract(const Duration(hours: 1)))));
      }
    });
  }

  void setDriverLocationStatus(
    String userId,
  ) {
    FirebaseApi.updateDriverLocation(
        driverId: userId, location: Location.Zero());
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
