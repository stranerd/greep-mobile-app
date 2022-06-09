import 'package:grip/application/response.dart';
import 'package:grip/domain/user/model/User.dart';
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
}
