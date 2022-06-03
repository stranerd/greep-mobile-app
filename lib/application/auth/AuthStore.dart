import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStore {
  static const String prefName = "cred";
  late Map<String, dynamic> _token;

  static final AuthStore _instance = AuthStore._privateConstructor();

  AuthStore._privateConstructor();

  factory AuthStore() {
    return _instance;
  }

  Map<String, dynamic> get token {
    return _token;
  }

  void setToken(Map<String, dynamic> credentials) async {
    var storage = FlutterSecureStorage();
    await storage.write(key: prefName, value: jsonEncode(credentials));
    this._token = credentials;
  }

  Future<Map<String, dynamic>> getAuthToken() async {
    var pref = FlutterSecureStorage();
    var token = await pref.read(key: prefName);
    if (token == null) {
      return {};
    }
    var jsonDecode2 = jsonDecode(token);

    return jsonDecode2 as Map<String, dynamic>;
  }

  void deleteToken() async {
    var pref = FlutterSecureStorage();
    pref.delete(key: prefName);
  }
}
