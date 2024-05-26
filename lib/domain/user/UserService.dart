import 'package:greep/application/response.dart';
import 'package:greep/application/driver/request/accept_manager_request.dart';
import 'package:greep/application/driver/request/add_driver_request.dart';
import 'package:greep/application/user/request/EditUserRequest.dart';
import 'package:greep/application/user/request/update_user_type_request.dart';
import 'package:greep/domain/user/model/User.dart';
import 'package:greep/domain/user/model/auth_user.dart';
import 'package:greep/domain/user/model/driver_commission.dart';
import 'package:greep/domain/user/model/manager_request.dart';
import 'package:greep/domain/user/user_client.dart';

class UserService {
  final UserClient userClient;

  const UserService(this.userClient);

  Future<ResponseEntity<User>> fetchUser(String userId) async {
    var response = await userClient.fetchUser(userId);
    if (!response.isError) {}
    return response;
  }
  Future<ResponseEntity<AuthUser>> fetchAuthUser(String userId) async {
    var response = await userClient.fetchAuthUser(userId);
    if (!response.isError) {}
    return response;
  }

  Future<ResponseEntity<List<DriverCommission>>> fetchUserDriverCommissions(
      String userId) async {
    return await userClient.fetchUserDriverCommissions(userId);
  }

  Future<ResponseEntity> removeDriver(String driverId) async {
    return await userClient.removeDriver(driverId);
  }

  Future<ResponseEntity<List<User>>> fetchUserDrivers(String userId) async {
    return await userClient.fetchUserDrivers(userId);
  }

  Future<ResponseEntity> addDriver(AddDriverRequest request) async {
    var response = await userClient.sendOrRemoveDriverRequest(request);
    return response;
  }

  Future<ResponseEntity> acceptManager(AcceptManagerRequest request) async {
    var response = await userClient.acceptOrRejectManager(request);
    return response;
  }

  Future<ResponseEntity<ManagerRequest>> getManagerRequests(
      String userId) async {
    return await userClient.fetchManagerRequests(userId);
  }

  Future<ResponseEntity<List<User>>> fetchUserRankings({required String rankingType}) async {
    return await userClient.fetchUserRankings(rankingType: rankingType);
  }

  Future<ResponseEntity> editUser(EditUserRequest request) async {
    return await userClient.editUser(request);
  }

  Future<ResponseEntity> updateUserType(UpdateUserTypeRequest request) async {
    return await userClient.updateUserType(request);
  }

  Future<ResponseEntity> deleteUser() async {
    return await userClient.deleteUser();
  }
}
