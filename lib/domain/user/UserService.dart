import 'package:grip/application/response.dart';
import 'package:grip/domain/user/user_client.dart';

class UserService {
  final UserClient _client;

  UserService(this._client);

  Future<ResponseEntity> fetchUser() async {
    var response = await _client.fetchUser();
    print("fetched user data ${response}");
    if (!response.isError) {}
    return response;
  }
}
