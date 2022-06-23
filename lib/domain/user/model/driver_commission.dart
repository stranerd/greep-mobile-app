class DriverCommission {
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
}
