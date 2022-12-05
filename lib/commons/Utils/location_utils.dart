import 'dart:math';

import 'package:greep/application/location/location.dart';
import 'package:vector_math/vector_math_64.dart';

class LocationUtils {
  static double getDistanceBetweenLocations(
      {required Location from, required Location to}) {
    const p = 0.017453292519943295;
    const c = cos;
    final a = 0.5 -
        c((to.latitude - from.latitude) * p) / 2 +
        c(from.latitude * p) *
            c(to.latitude * p) *
            (1 - c((to.longitude - from.longitude) * p)) /
            2;
    return (12742 * asin(sqrt(a)));
  }

  static const double AVERAGE_RADIUS_OF_EARTH_KM = 6371;

  static double calculateDistanceInKilometer(
      {required Location user, required Location venue}) {
    print("user ${user}, venue ${venue}");
    double latDistance = radians(user.latitude - venue.latitude);
    double lngDistance = radians(user.longitude - venue.longitude);

    double a = sin(latDistance / 2) * sin(latDistance / 2) +
        cos(radians(user.latitude)) *
            cos(radians(venue.latitude)) *
            sin(lngDistance / 2) *
            sin(lngDistance / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return (AVERAGE_RADIUS_OF_EARTH_KM * c);
  }
}
