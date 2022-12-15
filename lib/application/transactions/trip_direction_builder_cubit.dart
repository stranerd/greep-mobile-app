import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greep/application/location/location.dart';
import 'package:greep/application/location/location_cubit.dart';
import 'package:greep/application/user/user_util.dart';
import 'package:greep/commons/Utils/location_utils.dart';
import 'package:greep/commons/Utils/time_helper.dart';
import 'package:greep/domain/firebase/Firebase_service.dart';
import 'package:greep/domain/user/model/ride_status.dart';

part 'trip_direction_builder_state.dart';

class DirectionProgress {
  final num distance;
  final DateTime date;
  final num speed;
  final Location location;
  final Duration duration;

  DirectionProgress({
    required this.distance,
    required this.date,
    required this.duration,
    required this.speed,
    required this.location,
  });

  @override
  String toString() {
    return 'DirectionProgress{distance: $distance, date: $date, speed: $speed, location: $location, duration: $duration}';
  }

  Map<String, dynamic> toMap() {
    return {
      'distance': distance,
      'date': date,
      'speed': speed,
      'location': location.toMap(),
      'duration': duration.inMinutes,
    };
  }

  factory DirectionProgress.fromMap(Map<String, dynamic> map) {
    return DirectionProgress(
      distance: map['distance'],
      date: TimeUtil.toDateTime(map["date"]),
      speed: map['speed'] as num,
      location: map['location'] == null ? Location.Zero() :Location.fromMap(map['location']),
      duration: Duration(seconds: map['duration'] ?? 0),
    );
  }
}

class TripDirectionBuilderCubit extends Cubit<TripDirectionBuilderState> {
  final LocationCubit locationCubit;

  TripDirectionBuilderCubit({
    required this.locationCubit,
  }) : super(TripDirectionBuilderStateInitial());

  RideStatus _rideStatus = RideStatus.ended;

  Map<RideStatus, DirectionProgress> _directions = {};

  Map<RideStatus, DirectionProgress> get directions => _directions;

  void gotTrip() {
    if (_rideStatus == RideStatus.ended) {

      DirectionProgress directionProgress = DirectionProgress(
        distance: 0,
        date: DateTime.now(),
        duration: Duration.zero,
        speed: 0,
        location: locationCubit.currLocation,
      );

      _rideStatus = RideStatus.pending;
      _directions[RideStatus.pending] = directionProgress;
      FirebaseApi.updateDriverLocation(
          driverId: getUser().id,
          location: locationCubit.currLocation,
          rideStatus: RideStatus.pending,
        directions: {
            "got": directionProgress,
          "start": null,
          "end": null,
        }
      );
      emit(TripDirectionBuilderStateGotTrip(
          directionProgress: directionProgress, directions: _directions));
    }
  }

  void startTrip() {
    if (_rideStatus == RideStatus.pending) {

      var currLocation = locationCubit.currLocation;
      // var currLocation = Location(longitude: 9.078766416437889, latitude: 7.42531622351495,);
      
      var distance2 = num.parse(
        LocationUtils.calculateDistanceInKilometer(
          user: _directions[RideStatus.pending]?.location ?? Location.Zero(),
          venue: currLocation,
        ).toStringAsFixed(
          2,
        ),
      );
      var difference = DateTime.now()
          .difference(_directions[RideStatus.pending]?.date ?? DateTime.now())
          .abs();

      DirectionProgress directionProgress = DirectionProgress(
        distance: distance2,
        date: DateTime.now(),
        duration: difference,
        speed: difference.inSeconds == 0 ? 0 : distance2 / difference.inSeconds,
        location: currLocation,
      );

      _rideStatus = RideStatus.inProgress;
      _directions[RideStatus.inProgress] = directionProgress;
      FirebaseApi.updateDriverLocation(
          driverId: getUser().id,
          location: currLocation,
          rideStatus: RideStatus.inProgress,
          directions: {
            "got": _directions[RideStatus.pending],
            "start": directionProgress,
            "end": null,
          }
      );
      emit(TripDirectionBuilderStateStartTrip(
          directionProgress: directionProgress, directions: _directions,),);
    }
  }

  void endTrip() {
    if (_rideStatus == RideStatus.inProgress) {

      var currLocation = locationCubit.currLocation;
      // var currLocation = Location(longitude: 9.072592455428323, latitude:  7.434399466421093,);

      var distance2 = num.parse(LocationUtils.calculateDistanceInKilometer(
              user:
                  _directions[RideStatus.pending]?.location ?? Location.Zero(),
              venue: currLocation)
          .toStringAsFixed(2));
      var difference = DateTime.now()
          .difference(_directions[RideStatus.pending]?.date ?? DateTime.now())
          .abs();
      DirectionProgress directionProgress = DirectionProgress(
        distance: distance2,
        date: DateTime.now(),
        duration: difference,
        speed: difference.inSeconds == 0 ? 0 : distance2 / difference.inSeconds,
        location: currLocation,
      );

      _rideStatus = RideStatus.ended;
      _directions[RideStatus.ended] = directionProgress;
      FirebaseApi.updateDriverLocation(
        driverId: getUser().id,
        location: currLocation,
        rideStatus: RideStatus.ended,
          directions: {
            "got": _directions[RideStatus.pending],
            "start": _directions[RideStatus.inProgress],
            "end": directionProgress,
          }
      );
      emit(TripDirectionBuilderStateEndTrip(
          directionProgress: directionProgress, directions: _directions));
    }
  }

  void cancelProgress({required bool isCompleted}) {
    _directions.clear();
    _rideStatus = RideStatus.ended;
    FirebaseApi.updateDriverLocation(
        driverId: getUser().id,
        location: locationCubit.currLocation,
        rideStatus: RideStatus.ended,
        directions: {
          "got": null,
          "start": null,
          "end": null,
        }
    );
    emit(isCompleted ? TripDirectionBuilderStateCompleted() : TripDirectionBuilderStateInitial());
  }
}
