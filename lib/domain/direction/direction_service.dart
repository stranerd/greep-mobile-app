import 'package:greep/application/location/location.dart';
import 'package:greep/application/response.dart';
import 'package:greep/domain/direction/direction_client.dart';

class DirectionService {
  final DirectionsClient directionsClient;

  DirectionService(this.directionsClient);

  // Future<ResponseEntity<int>> getDirections(
  //     {
  //     required Location origin,
  //     required Location destination,
  //     List<Location?>? waypoints}) async {
  //
  //   var response =
  //       await directionsClient.getTotalTime(origin, destination, waypoints);
  //
  //   return response;
  // }
}
