import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greep/application/location/location.dart';
import 'package:greep/application/location/location_cubit.dart';
import 'package:greep/application/user/user_util.dart';
import 'package:greep/commons/Utils/location_utils.dart';
import 'package:greep/domain/firebase/Firebase_service.dart';
import 'package:greep/domain/user/model/driver_location_status.dart';
import 'package:greep/domain/user/model/ride_status.dart';
import 'package:timeago/timeago.dart' as timeago;

part 'trip_direction_builder_state.dart';

class DirectionProgress {
  final num distance;
  final DateTime date;
  final num speed;
  final Location location;
  final Duration duration;

  DirectionProgress(
      {required this.distance,
      required this.date,
      required this.duration,
      required this.speed,
      required this.location});

  @override
  String toString() {
    return 'DirectionProgress{distance: $distance, date: $date, speed: $speed, location: $location, duration: $duration}';
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
      FirebaseApi.updateDriverLocation(
          driverId: getUser().id,
          location: locationCubit.currLocation,
          rideStatus: RideStatus.pending);
      DirectionProgress directionProgress = DirectionProgress(
        distance: 0,
        date: DateTime.now(),
        duration: Duration.zero,
        speed: 0,
        location: locationCubit.currLocation,
      );

      _rideStatus = RideStatus.pending;
      _directions[RideStatus.pending] = directionProgress;
      emit(TripDirectionBuilderStateGotTrip(
          directionProgress: directionProgress, directions: _directions));
    }
  }

  void startTrip() {
    if (_rideStatus == RideStatus.pending) {
      FirebaseApi.updateDriverLocation(
          driverId: getUser().id,
          location: locationCubit.currLocation,
          rideStatus: RideStatus.inProgress);
      var distance2 = num.parse(
        LocationUtils.calculateDistanceInKilometer(
          user: _directions[RideStatus.pending]?.location ?? Location.Zero(),
          venue: locationCubit.currLocation,
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
        location: locationCubit.currLocation,
      );

      _rideStatus = RideStatus.inProgress;
      _directions[RideStatus.inProgress] = directionProgress;
      emit(TripDirectionBuilderStateStartTrip(
          directionProgress: directionProgress, directions: _directions));
    }
  }

  void endTrip() {
    if (_rideStatus == RideStatus.inProgress) {
      FirebaseApi.updateDriverLocation(
        driverId: getUser().id,
        location: locationCubit.currLocation,
        rideStatus: RideStatus.ended,
      );
      var distance2 = num.parse(LocationUtils.calculateDistanceInKilometer(
              user:
                  _directions[RideStatus.pending]?.location ?? Location.Zero(),
              venue: locationCubit.currLocation)
          .toStringAsFixed(2));
      var difference = DateTime.now()
          .difference(_directions[RideStatus.pending]?.date ?? DateTime.now())
          .abs();
      DirectionProgress directionProgress = DirectionProgress(
        distance: distance2,
        date: DateTime.now(),
        duration: difference,
        speed: difference.inSeconds == 0 ? 0 : distance2 / difference.inSeconds,
        location: locationCubit.currLocation,
      );

      _rideStatus = RideStatus.ended;
      _directions[RideStatus.ended] = directionProgress;
      emit(TripDirectionBuilderStateEndTrip(
          directionProgress: directionProgress, directions: _directions));
    }
  }

  void cancelProgress() {
    _directions.clear();
    _rideStatus  = RideStatus.ended;
    emit(TripDirectionBuilderStateInitial());
  }
}
