import 'package:get_it/get_it.dart';
import 'package:grip/application/auth/AuthenticationCubit.dart';
import 'package:grip/domain/auth/AuthenticationClient.dart';
import 'package:grip/domain/auth/AuthenticationService.dart';

class IoC {

  late AuthenticationCubit _authenticationCubit;
  late AuthenticationService _authenticationService;
  var getIt = GetIt.instance;



  IoC(){
    _authenticationService = AuthenticationService(authenticationClient: AuthenticationClient());
    _authenticationCubit = AuthenticationCubit(_authenticationService);


    getIt.registerLazySingleton(() => _authenticationCubit);
  }


}
