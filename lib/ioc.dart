import 'package:get_it/get_it.dart';
import 'package:grip/application/auth/AuthenticationCubit.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/domain/auth/AuthenticationClient.dart';
import 'package:grip/domain/auth/AuthenticationService.dart';
import 'package:grip/domain/user/UserService.dart';
import 'package:grip/domain/user/user_client.dart';

class IoC {

  late AuthenticationCubit _authenticationCubit;
  late AuthenticationService _authenticationService;
  late UserService _userService;
  late UserCubit _userCubit;
  var getIt = GetIt.instance;



  IoC(){
    _authenticationService = AuthenticationService(authenticationClient: AuthenticationClient());
    _authenticationCubit = AuthenticationCubit(_authenticationService);
    _userService = UserService(UserClient());
    _userCubit = UserCubit(authenticationCubit: _authenticationCubit, userService: _userService);


    getIt.registerLazySingleton(() => _authenticationCubit);
    getIt.registerSingleton(_userCubit);
  }


}
