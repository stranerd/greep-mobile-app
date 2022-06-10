class ManagerRequest {
  final String managerId;
  final num commission;

  ManagerRequest({required this.managerId, required this.commission});

  factory ManagerRequest.fromServer(dynamic data) {
    return ManagerRequest(
        managerId: data["managerId"], commission: data["commission"]);
  }

  @override
  String toString() {
    return 'ManagerRequest{managerId: $managerId, commission: $commission}';
  }
}
