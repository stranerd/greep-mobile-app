import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'secure_storage.dart';

abstract class ISecureStorageManager {
  Future<bool> hasAccessToken();
  Future<void> setUserToken(UserToken token);
  Future<String?> getUserToken();
  Future<void> removeUserToken();
  Future<void> setUserProfile(String userProfileString);
}

class SecureStorageManager extends ISecureStorageManager {
  final _userTokenKey = 'DCG_USER_TOKEN';
  final _userProfileKey = 'USER_PROFILE_KEY';

  final storage = const FlutterSecureStorage();

  SecureStorageManager();

  @override
  Future<bool> hasAccessToken() async {
    return storage.containsKey(key: _userTokenKey);
  }

  @override
  Future<void> setUserToken(UserToken token) async {
    return storage.write(key: _userTokenKey, value: token.token);
  }

  @override
  Future<String?> getUserToken() async {
    return storage.read(key: _userTokenKey);
  }

  @override
  Future<void> removeUserToken() async {
    return storage.delete(key: _userTokenKey);
  }

  @override
  Future<void> setUserProfile(String userProfileString) {
    return storage.write(key: _userProfileKey, value: userProfileString);
  }
}
