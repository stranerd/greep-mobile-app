import 'package:grip/application/response.dart';
import 'package:grip/application/user/driver/accept_manager_request.dart';
import 'package:grip/application/user/driver/add_driver_request.dart';
import 'package:grip/domain/user/model/User.dart';
import 'package:grip/domain/user/model/manager_request.dart';
import 'package:grip/domain/user/user_client.dart';

class UserService {
  final UserClient _client;

  UserService(this._client);

  Future<ResponseEntity> fetchUser() async {
    var response = await _client.fetchUser();
    if (!response.isError) {}
    return response;
  }

  Future<ResponseEntity<List<User>>> fetchUserDrivers(String userId)async{
    return await _client.fetchUserDrivers(userId);
  }

  Future<ResponseEntity> addDriver(AddDriverRequest request) async{
    var response = await _client.sendOrRemoveDriverRequest(request);
    return response;

  }

  Future<ResponseEntity> acceptManager(AcceptManagerRequest request) async{
    var response = await _client.acceptOrRejectManager(request);
    return response;

  }


  Future<ResponseEntity<ManagerRequest>> getManagerRequests(String userId) async {
    return await _client.fetchManagerRequests(userId);
  }
}
