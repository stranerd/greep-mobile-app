import 'package:get_it/get_it.dart';
import 'package:grip/application/auth/AuthenticationCubit.dart';
import 'package:grip/application/auth/SignupCubit.dart';
import 'package:grip/application/customers/user_customers_cubit.dart';
import 'package:grip/application/driver/manager_drivers_cubit.dart';
import 'package:grip/application/driver/new_manager_accepts_cubit.dart';
import 'package:grip/application/driver/new_manager_requests_cubit.dart';
import 'package:grip/application/transactions/customer_statistics_cubit.dart';
import 'package:grip/application/transactions/transaction_crud_cubit.dart';
import 'package:grip/application/transactions/transaction_summary_cubit.dart';
import 'package:grip/application/transactions/user_transactions_cubit.dart';
import 'package:grip/application/driver/drivers_cubit.dart';
import 'package:grip/application/driver/manager_requests_cubit.dart';
import 'package:grip/application/user/user_crud_cubit.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/domain/auth/AuthenticationClient.dart';
import 'package:grip/domain/auth/AuthenticationService.dart';
import 'package:grip/domain/customer/customer_client.dart';
import 'package:grip/domain/customer/customer_service.dart';
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
  late ManagerRequestsCubit _managerRequestsCubit;
  late NewManagerRequestsCubit _newManagerRequestsCubit;
  late ManagerDriversCubit _managerDriversCubit;
  late CustomerService _customerService;
  late UserCustomersCubit _userCustomersCubit;
  late NewManagerAcceptsCubit _newManagerAcceptsCubit;
  var getIt = GetIt.instance;

  IoC() {
    _authenticationService =
        AuthenticationService(authenticationClient: AuthenticationClient());
    _authenticationCubit = AuthenticationCubit(_authenticationService);
    _userService = UserService(UserClient());
    _userCubit = UserCubit(
        authenticationCubit: _authenticationCubit, userService: _userService);
    _customerService = CustomerService(CustomerClient());
    _driversCubit =
        DriversCubit(userCubit: _userCubit, userService: _userService);
    _transactionService = TransactionService(TransactionClient());
    _userTransactionsCubit = UserTransactionsCubit(
        transactionService: _transactionService,
        driversCubit: _driversCubit,
        authenticationCubit: _authenticationCubit);

    _signupCubit = SignupCubit(
      authenticationCubit: _authenticationCubit,
      authenticationService: _authenticationService,
    );

    _managerRequestsCubit = ManagerRequestsCubit(
      userCubit: _userCubit,
      userService: _userService,
    );

    _newManagerRequestsCubit = NewManagerRequestsCubit(userCubit: _userCubit);
    _newManagerAcceptsCubit = NewManagerAcceptsCubit(userCubit: _userCubit);


    _managerDriversCubit = ManagerDriversCubit(
      driversCubit: _driversCubit,
      userService: _userService,
    );

    _userCustomersCubit = UserCustomersCubit(customerService: _customerService, transactionsCubit: _userTransactionsCubit);

    getIt.registerLazySingleton(() => _authenticationCubit);
    getIt.registerSingleton(_authenticationService);

    getIt.registerSingleton(_userCubit);
    getIt.registerSingleton(_driversCubit);

    getIt.registerSingleton(_userTransactionsCubit);

    getIt.registerSingleton(_signupCubit);
    getIt.registerSingleton(_managerRequestsCubit);
    getIt.registerSingleton(_newManagerRequestsCubit);
    getIt.registerSingleton(_newManagerAcceptsCubit);

    getIt.registerSingleton(_managerDriversCubit);
    getIt.registerSingleton(TransactionSummaryCubit(
        userTransactionsCubit: _userTransactionsCubit,
        driversCubit: _driversCubit));
    getIt.registerSingleton(CustomerStatisticsCubit(
        transactionsCubit: _userTransactionsCubit,
        driversCubit: _driversCubit,
        authenticationCubit: _authenticationCubit));
    getIt.registerFactory(() => TransactionCrudCubit(
          transactionService: _transactionService,
        ));
    getIt.registerSingleton(_userCustomersCubit);


    getIt.registerFactory(() => UserCrudCubit(
          userService: _userService,
        ));
  }
}
