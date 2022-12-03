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
          data["status"] ?? "ended",
        ),
        updatedAt: TimeUtil.toDateTime(data["updatedAt"]),
        latitude: data["latitude"] ?? "",
        longitude: data["longitude"] ?? "",
        driverId: data["driverId"] ?? "",
    );
  }

  static RideStatus getType(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return RideStatus.pending;
      case "inProgress":
        return RideStatus.inProgress;
      case "ended":
        return RideStatus.ended;
      default:
        return RideStatus.ended;
    }
  }
}
