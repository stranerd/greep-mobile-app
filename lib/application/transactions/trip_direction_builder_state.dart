part of 'trip_direction_builder_cubit.dart';

abstract class TripDirectionBuilderState {

  Map<String,dynamic> toJson(TripDirectionBuilderState state);
  TripDirectionBuilderState fromJson(Map<String, dynamic> json);
}

class TripDirectionBuilderStateInitial extends TripDirectionBuilderState {
  @override
  TripDirectionBuilderState fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson(TripDirectionBuilderState state) {
    // TODO: implement toJson
    return {};

  }
}

class TripDirectionBuilderStateGotTrip extends TripDirectionBuilderState {
  final DirectionProgress directionProgress;
  final Map<RideStatus, DirectionProgress> directions;

  TripDirectionBuilderStateGotTrip(
      {required this.directionProgress, required this.directions});

  @override
  TripDirectionBuilderState fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson(TripDirectionBuilderState state) {
    // TODO: implement toJson
    return {};

  }

  @override
  String toString() {
    return "${this.runtimeType}";
  }
}

class TripDirectionBuilderStateStartTrip extends TripDirectionBuilderState {
  final DirectionProgress directionProgress;
  final Map<RideStatus, DirectionProgress> directions;

  TripDirectionBuilderStateStartTrip(
      {required this.directionProgress, required this.directions});

  @override
  TripDirectionBuilderState fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson(TripDirectionBuilderState state) {
    return {};
  }
}

class TripDirectionBuilderStateEndTrip extends TripDirectionBuilderState {
  final DirectionProgress directionProgress;
  final Map<RideStatus, DirectionProgress> directions;

  TripDirectionBuilderStateEndTrip(
      {required this.directionProgress, required this.directions});

  @override
  TripDirectionBuilderState fromJson(Map<String, dynamic> json) {

    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson(TripDirectionBuilderState state) {
    return {
      "directionProgress": directionProgress.toMap(),
      "directions": directions.map((key, value) => MapEntry(key, value.toMap()))
    };
  }
}

class TripDirectionBuilderStateCompleted extends TripDirectionBuilderState {
  @override
  TripDirectionBuilderState fromJson(Map<String, dynamic> json) {
    return TripDirectionBuilderStateCompleted();
  }

  @override
  Map<String, dynamic> toJson(TripDirectionBuilderState state) {
    return {};
  }
}
