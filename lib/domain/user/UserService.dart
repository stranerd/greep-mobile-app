import 'package:grip/application/response.dart';
import 'package:grip/domain/user/user_client.dart';

class UserService {
  final UserClient _client;

  UserService(this._client);

  Future<ResponseEntity> fetchUser() async {
    var response = await _client.fetchUser();
    if (!response.isError) {}
    return response;
  }
}
