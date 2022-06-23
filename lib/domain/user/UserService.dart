import 'package:grip/application/response.dart';
import 'package:grip/application/driver/request/accept_manager_request.dart';
import 'package:grip/application/driver/request/add_driver_request.dart';
import 'package:grip/application/user/request/EditUserRequest.dart';
import 'package:grip/domain/user/model/User.dart';
import 'package:grip/domain/user/model/driver_commission.dart';
import 'package:grip/domain/user/model/manager_request.dart';
import 'package:grip/domain/user/user_client.dart';

class UserService {
  final UserClient _client;

  const UserService(this._client);

  Future<ResponseEntity> fetchUser(String userId) async {
    var response = await _client.fetchUser(userId);
    if (!response.isError) {}
    return response;
  }

  Future<ResponseEntity<List<DriverCommission>>> fetchUserDriverCommissions(
      String userId) async {
    return await _client.fetchUserDriverCommissions(userId);
  }

  Future<ResponseEntity> removeDriver(String driverId) async {
    return await _client.removeDriver(driverId);
  }

  Future<ResponseEntity<List<User>>> fetchUserDrivers(String userId) async {
    return await _client.fetchUserDrivers(userId);
  }

  Future<ResponseEntity> addDriver(AddDriverRequest request) async {
    var response = await _client.sendOrRemoveDriverRequest(request);
    return response;
  }

  Future<ResponseEntity> acceptManager(AcceptManagerRequest request) async {
    var response = await _client.acceptOrRejectManager(request);
    return response;
  }

  Future<ResponseEntity<ManagerRequest>> getManagerRequests(
      String userId) async {
    return await _client.fetchManagerRequests(userId);
  }

  Future<ResponseEntity> editUser(EditUserRequest request) async {
    return await _client.editUser(request);
  }

}
