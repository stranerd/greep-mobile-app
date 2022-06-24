import 'package:equatable/equatable.dart';

class DriverCommission extends Equatable {
  final String driverId;
  final num commission;
  final String driverName;
  final String driverPhoto;

  const DriverCommission({required this.driverId, this.driverPhoto = "", required this.commission,this.driverName = ""});

  factory DriverCommission.fromServer(dynamic data) {
    return DriverCommission(
      driverId: data["driverId"],
      commission: data["commission"],
    );
  }

  @override
  String toString() {
    return 'DriverCommission{driverId: $driverId, commission: $commission, driverName: $driverName, driverPhoto: $driverPhoto}';
  }

  @override
  // TODO: implement props
  List<Object?> get props => [driverId];
}
