import 'dart:math';

import 'package:greep/application/location/location.dart';

class LocationUtils {


  static double getDistanceBetweenLocations({required Location from, required Location to}){
    const p = 0.017453292519943295;
    const c = cos;
    final a = 0.5 -
        c((to.latitude - from.latitude) * p) / 2 +
        c(from.latitude * p) * c(to.latitude * p) * (1 - c((to.longitude - from.longitude) * p)) / 2;
    return (12742 * asin(sqrt(a)));

    }

}
