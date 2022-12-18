import 'package:greep/application/transactions/trip_direction_builder_cubit.dart';
import 'package:greep/commons/Utils/time_helper.dart';
import 'package:greep/domain/user/model/ride_status.dart';

class DriverLocation {
  final RideStatus rideStatus;
  final String latitude;
  final String driverId;
  final String longitude;
  final String address;
  final DateTime updatedAt;
  final DirectionProgress? gotDirection;
  final DirectionProgress? startDirection;
  final DirectionProgress? endDirection;

  DriverLocation({
    this.gotDirection,
    this.startDirection,
    this.endDirection,
    required this.address,
    required this.latitude,
    required this.driverId,
    required this.longitude,
    required this.rideStatus,
    required this.updatedAt,
  });

  factory DriverLocation.fromServer(dynamic data) {
    return DriverLocation(
      address: data["address"]??"",
      rideStatus: getType(
        data["rideStatus"] ?? "ended",
      ),
      updatedAt: TimeUtil.toDateTime(data["updatedAt"]),
      latitude: data["latitude"] is num
          ? data["latitude"].toString()
          : data["latitude"] is String
              ? data["latitude"]
              : "",
      longitude: data["longitude"] is num
          ? data["longitude"].toString()
          : data["longitude"] is String
              ? data["longitude"]
              : "",
      driverId: data["driverId"] ?? "",
      gotDirection: data["directions"] == null
          ? null
          : data["directions"]["got"] == null
              ? null
              : DirectionProgress.fromMap(data["directions"]["got"]),
      startDirection: data["directions"] == null
          ? null
          : data["directions"]["start"] == null
              ? null
              : DirectionProgress.fromMap(data["directions"]["start"]),
      endDirection: data["directions"] == null
          ? null
          : data["directions"]["end"] == null
              ? null
              : DirectionProgress.fromMap(data["directions"]["end"]),
    );
  }

  factory DriverLocation.zero() {
    return DriverLocation(
        latitude: "0",
        address: "",
        driverId: "0",
        longitude: "0",
        rideStatus: RideStatus.ended,
        updatedAt: DateTime.now());
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
    return 'DriverLocation{rideStatus: $rideStatus,address: $address, latitude: $latitude, driverId: $driverId, longitude: $longitude, updatedAt: $updatedAt, gotDirection: $gotDirection, startDirection: $startDirection, endDirection: $endDirection}';
  }
}
