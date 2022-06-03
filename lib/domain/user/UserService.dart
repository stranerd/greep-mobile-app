import 'package:grip/application/response.dart';
import 'package:grip/domain/user/user_client.dart';

class UserService {
  final UserClient _client;

  UserService(this._client);

  Future<ResponseEntity> fetchUser(String userId) async {
    var response = await _client.fetchUser(userId);
    print("fetched user data ${response}");
    if (!response.isError) {}
    return response;
  }
}
