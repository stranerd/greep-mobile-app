class ManagerRequest {
  final String managerId;
  final String docId;
  final String managerName;
  final num commission;

  ManagerRequest({required this.managerId, required this.commission, required this.managerName, required this.docId});

  factory ManagerRequest.fromServer(dynamic data, {String docId = ""}) {
    return ManagerRequest(
        managerId: data["managerId"], commission: data["commission"], managerName: data["managerName"], docId: docId);
  }

  @override
  String toString() {
    return 'ManagerRequest{managerId: $managerId, commission: $commission}';
  }
}
