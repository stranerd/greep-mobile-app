import 'package:get_it/get_it.dart';
import 'package:grip/application/auth/AuthenticationCubit.dart';
import 'package:grip/application/auth/SignupCubit.dart';
import 'package:grip/application/transactions/customer_statistics_cubit.dart';
import 'package:grip/application/transactions/transaction_crud_cubit.dart';
import 'package:grip/application/transactions/transaction_summary_cubit.dart';
import 'package:grip/application/transactions/user_transactions_cubit.dart';
import 'package:grip/application/user/drivers_cubit.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/domain/auth/AuthenticationClient.dart';
import 'package:grip/domain/auth/AuthenticationService.dart';
import 'package:grip/domain/transaction/transaction_client.dart';
import 'package:grip/domain/transaction/transaction_service.dart';
import 'package:grip/domain/user/UserService.dart';
import 'package:grip/domain/user/user_client.dart';

class IoC {
  late AuthenticationCubit _authenticationCubit;
  late AuthenticationService _authenticationService;
  late UserService _userService;
  late UserCubit _userCubit;
  late UserTransactionsCubit _userTransactionsCubit;
  late TransactionService _transactionService;
  late TransactionCrudCubit _transactionCrudCubit;
  late DriversCubit _driversCubit;
  late SignupCubit _signupCubit;
  var getIt = GetIt.instance;

  IoC() {
    _authenticationService =
        AuthenticationService(authenticationClient: AuthenticationClient());
    _authenticationCubit = AuthenticationCubit(_authenticationService);
    _userService = UserService(UserClient());
    _userCubit = UserCubit(
        authenticationCubit: _authenticationCubit, userService: _userService);
    _driversCubit = DriversCubit(userCubit: _userCubit, userService: _userService);
    _transactionService = TransactionService(TransactionClient());
    _userTransactionsCubit = UserTransactionsCubit(
        transactionService: _transactionService,
        driversCubit: _driversCubit,
        authenticationCubit: _authenticationCubit);
    _signupCubit = SignupCubit(authenticationCubit: _authenticationCubit, authenticationService: _authenticationService,);

    getIt.registerLazySingleton(() => _authenticationCubit);
    getIt.registerSingleton(_authenticationService);

    getIt.registerSingleton(_userCubit);
    getIt.registerSingleton(_driversCubit);

    getIt.registerSingleton(_userTransactionsCubit);

    getIt.registerSingleton(_signupCubit);


    getIt.registerSingleton(
        TransactionSummaryCubit(userTransactionsCubit: _userTransactionsCubit,driversCubit: _driversCubit));
    getIt.registerSingleton(CustomerStatisticsCubit(
        transactionsCubit: _userTransactionsCubit,
        driversCubit: _driversCubit,
        authenticationCubit: _authenticationCubit));
    getIt.registerFactory(() => TransactionCrudCubit(transactionService: _transactionService,)
    );
  }
}
