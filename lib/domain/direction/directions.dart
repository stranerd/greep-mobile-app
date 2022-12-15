import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directions {
  final LatLngBounds bounds;
  final List<PointLatLng> polyPoints;
  final String totalDistance;
  final int totalDuration;

  const Directions({required this.bounds,
    required this.polyPoints,
    required this.totalDistance,
    required this.totalDuration,});


  factory Directions.fromMap(Map<String, dynamic> map) {
    final data = Map<String, dynamic>.from(map['routes'][0]);
    final northeast = data['bounds']['northeast'];
    final southwest = data['bounds']['southwest'];
    final bounds = LatLngBounds(northeast: LatLng(
      northeast['lat'], northeast['lng'],
    ), southwest: LatLng(
      southwest['lat'], southwest['lng'],
    ),);

    String distance = '';
    int duration = 0;
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'];
      duration = leg['duration']['value'];
    }

    var directions = Directions(
      bounds: bounds,
      polyPoints: PolylinePoints().decodePolyline(
          data['overview_polyline']['points']),
      totalDistance: distance,
      totalDuration: duration,
    );
    return directions;
  }

  @override
  String toString() {
    return 'Directions{bounds: $bounds, polyPoints: $polyPoints, totalDistance: $totalDistance, totalDuration: $totalDuration}';
  }
}
