part of 'trip_direction_builder_cubit.dart';

abstract class TripDirectionBuilderState {}

class TripDirectionBuilderStateInitial extends TripDirectionBuilderState {}

class TripDirectionBuilderStateGotTrip extends TripDirectionBuilderState {
  final DirectionProgress directionProgress;
  final Map<RideStatus, DirectionProgress> directions;

  TripDirectionBuilderStateGotTrip(
      {required this.directionProgress, required this.directions});
}

class TripDirectionBuilderStateStartTrip extends TripDirectionBuilderState {
  final DirectionProgress directionProgress;
  final Map<RideStatus, DirectionProgress> directions;

  TripDirectionBuilderStateStartTrip(
      {required this.directionProgress, required this.directions});
}

class TripDirectionBuilderStateEndTrip extends TripDirectionBuilderState {
  final DirectionProgress directionProgress;
  final Map<RideStatus, DirectionProgress> directions;

  TripDirectionBuilderStateEndTrip(
      {required this.directionProgress, required this.directions});
}
