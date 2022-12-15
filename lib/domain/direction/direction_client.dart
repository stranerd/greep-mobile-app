import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:greep/application/location/location.dart';

import 'directions.dart';

class DirectionsClient {
  static const String baseUrl =
      "https://maps.googleapis.com/maps/api/directions/json?";
  final Dio _dio = Dio();

  DirectionsClient._privateConstructor();

  static DirectionsClient instance = DirectionsClient._privateConstructor();

  Future<Directions?> getDirections(
      {required Location origin,
      required Location destination,
      List<Location?>? waypoints}) async {
    await dotenv.load(fileName: ".env");
    String googleApiKey = dotenv.env[ Platform.isIOS ? 'GOOGLEIOSAPIKEY':'GOOGLEAPIKEY']??"";

    // print("getting directions $origin $destination");

    String waypoint = "";
    if (waypoints != null || waypoints!.isNotEmpty) {
      waypoint = waypoints.map((e) => e!.toDirectionsLatLng()).join("|via:");
    }
    // print("waypoints string $waypoint");
    final response = await _dio.get(baseUrl, queryParameters: {
      'origin': '${origin.latitude},${origin.longitude}',
      'destination': '${destination.latitude},${destination.longitude}',
      'key': googleApiKey,
      'waypoints': "via:$waypoint",
    });

    if (isSuccessful(response.statusCode ?? 0)) {
      return Directions.fromMap(response.data);
    }
    return null;
  }


  bool isSuccessful(int code) {
    return code >= 200 && code <= 299;
  }

}
