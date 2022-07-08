import 'package:flutter_test/flutter_test.dart';
import 'package:grip/domain/user/UserService.dart';
import 'package:grip/domain/user/user_client.dart';
import 'package:mocktail/mocktail.dart';

class MockUserService extends Mock implements UserService {
  final UserClient mockUserClient;

  MockUserService({required this.mockUserClient});
}

class MockUserClient extends Mock implements UserClient {}

void main() {
  late UserService userService;
  late UserClient userClient;

  setUp(() {
    userClient = MockUserClient();
    userService = MockUserService(mockUserClient: userClient);
  });


  test("Test Checking Authentication", () async {
    print("testing");
    dynamic auths =  await userClient.fetchUserDrivers("ddfd");
    print("check auth result $auths");
    expect(true,auths.isEmpty);
  });
}
