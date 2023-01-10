import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:greep/application/geocoder/geocoder_cubit.dart';
import 'package:greep/application/location/location.dart';
import 'package:greep/application/response.dart';
import 'package:greep/application/user/user_cubit.dart';
import 'package:greep/domain/firebase/Firebase_service.dart';
import 'package:greep/domain/user/model/User.dart';
import 'package:greep/domain/user/user_client.dart';
import 'package:greep/ioc.dart';
import 'package:location/location.dart' as loc;

import 'location_state.dart';

/// @author Ibekason Alexander
///
/// State management for current gps location of the customer

class LocationCubit extends Cubit<LocationState> {
  loc.Location _location = loc.Location();
  late bool _serviceEnabled;
  late Location _currLocation;
  late loc.PermissionStatus _permissionGranted;
  late StreamSubscription streamSubscription;
  late Timer timer;

  Location get currLocation {
    if (state is LocationStateOn) return _currLocation;
    return Location.Zero();
  }

  LocationCubit() : super(LocationStateUninitialized()) {
    subscribe();
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      User user = GetIt.I<UserCubit>().user;
      updateUserLocation(user.id);

    });
  }

  void subscribe() async {
    print("asking for location service");
    _serviceEnabled = await _location.serviceEnabled();
    _permissionGranted = await _location.hasPermission();
    print(_serviceEnabled);
    print(_permissionGranted);
    if (!_serviceEnabled) {
      emit(LocationStateOff());
    } else if (_permissionGranted == loc.PermissionStatus.denied) {
      emit(LocationStateOff());
      requestLocation();
    } else if (_serviceEnabled &&
        _permissionGranted == loc.PermissionStatus.granted) {
      print("emitting location on ");
      _location.getLocation().then((value) {
        _currLocation = Location(longitude: value.longitude ?? 0, latitude: value.latitude ?? 0);
        emit(LocationStateOn(_currLocation));
        print("emitted location on ${_currLocation}");
      });

      streamSubscription = _location.onLocationChanged.listen((locationData) async {
        if (locationData.latitude != null && locationData.longitude != null) {
          GeoCoderCubit geoCoder =getIt<GeoCoderCubit>();
          String address = await geoCoder.fetchAddressFromLongAndLat(longitude: locationData.longitude ?? 0, latitude: locationData.latitude??0,);
          Location newLocation = Location(
            latitude: locationData.latitude!,
            longitude: locationData.longitude!,
            address: address
          );
          _currLocation = newLocation;
          emit(LocationStateOn(newLocation));

        } else {
          _currLocation = Location.Zero();
          emit(LocationStateOff());
        }
      });
    }
  }

  void requestLocation() async {
    loc.LocationData _locationData;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        emit(LocationStateOff());
      }
    }

    _permissionGranted = await _location.hasPermission();
    print("permission granted ${_permissionGranted}");
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        emit(LocationStateOff());
      } else {
        _locationData = await _location.getLocation();
        _currLocation = Location(
          latitude: _locationData.latitude!,
          longitude: _locationData.longitude!,
        );
        emit(LocationStateOn(_currLocation));
      }
    } else if (_permissionGranted == loc.PermissionStatus.granted) {
      _locationData = await _location.getLocation();
      _currLocation = Location(
        latitude: _locationData.latitude!,
        longitude: _locationData.longitude!,
      );
      emit(LocationStateOn(_currLocation));
    }
  }

  Future<void> updateUserLocation(String userId,
      {Location? location}) async {
      await FirebaseApi.updateDriverLocation(driverId: userId, location: _currLocation, softUpdate: true);
       // print("$_currLocation location update ");
    }


  @override
  Future<void> close() {
    streamSubscription.cancel();
    timer.cancel();
    return super.close();
  }
}
