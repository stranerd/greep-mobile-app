import 'package:greep/commons/Utils/time_helper.dart';
import 'package:greep/domain/user/model/ride_status.dart';

class DriverLocation {
  final RideStatus rideStatus;
  final String latitude;
  final String driverId;
  final String longitude;
  final DateTime updatedAt;

  DriverLocation({
    required this.latitude,
    required this.driverId,
    required this.longitude,
    required this.rideStatus,
    required this.updatedAt,
  });

  factory DriverLocation.fromServer(dynamic data) {
    return DriverLocation(
        rideStatus: getType(
          data["rideStatus"] ?? "ended",
        ),
        updatedAt: TimeUtil.toDateTime(data["updatedAt"]),
        latitude: data["latitude"] is num ? data["latitude"].toString() : data["latitude"] is String ? data["latitude"]: "",
      longitude: data["longitude"] is num ? data["longitude"].toString() : data["longitude"] is String ? data["longitude"]: "",

      driverId: data["driverId"] ?? "",
    );
  }

  static RideStatus getType(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return RideStatus.pending;
      case "inprogress":
        return RideStatus.inProgress;
      case "ended":
        return RideStatus.ended;
      default:
        return RideStatus.ended;
    }
  }

  @override
  String toString() {
    return 'DriverLocation{rideStatus: $rideStatus, latitude: $latitude, driverId: $driverId, longitude: $longitude, updatedAt: $updatedAt}';
  }
}
