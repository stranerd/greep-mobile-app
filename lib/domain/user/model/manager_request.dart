class ManagerRequest {
  final String managerId;
  final String docId;
  final String driverId;
  final String managerName;
  final num commission;

  ManagerRequest({required this.managerId,required this.driverId, required this.commission, required this.managerName, required this.docId});

  factory ManagerRequest.fromServer(dynamic data, {String docId = ""}) {
    return ManagerRequest(
        managerId: data["managerId"],
        driverId: data["driverId"],
        commission: num.tryParse(data["commission"])??0,
        managerName: data["managerName"], docId: docId);
  }

  @override
  String toString() {
    return 'ManagerRequest{managerId: $managerId, commission: $commission}';
  }
}
