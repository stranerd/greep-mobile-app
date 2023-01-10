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
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:location/location.dart' as loc;

import 'location_state.dart';

/// @author Ibekason Alexander
///
/// State management for current gps location of the customer

class LocationCubit extends HydratedCubit<LocationState> {
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

  LocationCubit() : super(LocationStateOff()) {
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      User user = GetIt.I<UserCubit>().user;
      updateUserLocation(user.id);
    });
  }

  Future<bool> subscribe() async {
    _serviceEnabled = await _location.serviceEnabled();
    _permissionGranted = await _location.hasPermission();
    if (!_serviceEnabled) {
      emit(LocationStateOff());
      return false;
    } else if (_permissionGranted == loc.PermissionStatus.denied) {
      emit(LocationStateOff());
      return await requestLocation();
    } else if (_serviceEnabled &&
        _permissionGranted == loc.PermissionStatus.granted) {
      _location.getLocation().then((value) {
        _currLocation = Location(
            longitude: value.longitude ?? 0, latitude: value.latitude ?? 0);
        emit(LocationStateOn(_currLocation));
      });

      streamSubscription =
          _location.onLocationChanged.listen((locationData) async {
        if (locationData.latitude != null && locationData.longitude != null) {
          GeoCoderCubit geoCoder = getIt<GeoCoderCubit>();
          String address = await geoCoder.fetchAddressFromLongAndLat(
            longitude: locationData.longitude ?? 0,
            latitude: locationData.latitude ?? 0,
          );
          Location newLocation = Location(
              latitude: locationData.latitude!,
              longitude: locationData.longitude!,
              address: address);
          _currLocation = newLocation;
          emit(LocationStateOn(newLocation));
        } else {
          _currLocation = Location.Zero();
          emit(LocationStateOff());
        }
      });
      return true;
    }
    return false;
  }

  Future<bool> requestLocation() async {
    loc.LocationData _locationData;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        emit(LocationStateOff());
        return false;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        emit(LocationStateOff());
        return false;
      } else {
        _locationData = await _location.getLocation();
        _currLocation = Location(
          latitude: _locationData.latitude!,
          longitude: _locationData.longitude!,
        );
        emit(LocationStateOn(_currLocation));
        return true;
      }
    } else if (_permissionGranted == loc.PermissionStatus.granted) {
      _locationData = await _location.getLocation();
      _currLocation = Location(
        latitude: _locationData.latitude!,
        longitude: _locationData.longitude!,
      );
      emit(LocationStateOn(_currLocation));
      return true;
    }
    return false;
  }

  Future<void> updateUserLocation(String userId, {Location? location}) async {
    await FirebaseApi.updateDriverLocation(
        driverId: userId, location: _currLocation, softUpdate: true);
    // print("$_currLocation location update ");
  }

  @override
  Future<void> close() {
    streamSubscription.cancel();
    timer.cancel();
    return super.close();
  }

  void emitOn() {
    try {
    emit(LocationStateOn(_currLocation));}
        catch (_){
    }
  }

  @override
  LocationState? fromJson(Map<String, dynamic> json) {
    bool isOn = json["isOn"];
    if (isOn) {
      emit(LocationStateOn(Location.fromMap(json["location"])));
    } else {
      emit(LocationStateOff());
    }
  }

  @override
  Map<String, dynamic>? toJson(LocationState state) {
    return {
      "isOn": state is LocationStateOn ? true : false,
      "location": state is LocationStateOn ? state.location.toMap() : {}
    };
  }
}
