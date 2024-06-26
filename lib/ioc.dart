import 'package:get_it/get_it.dart';
import 'package:greep/application/auth/AuthenticationCubit.dart';
import 'package:greep/application/auth/SignupCubit.dart';
import 'package:greep/application/auth/email_verification/email_verification_cubit.dart';
import 'package:greep/application/auth/password/reset_password_cubit.dart';
import 'package:greep/application/customers/user_customers_cubit.dart';
import 'package:greep/application/driver/manager_drivers_cubit.dart';
import 'package:greep/application/driver/new_manager_accepts_cubit.dart';
import 'package:greep/application/driver/new_manager_requests_cubit.dart';
import 'package:greep/application/geocoder/geocoder_cubit.dart';
import 'package:greep/application/location/driver_location_status_cubit.dart';
import 'package:greep/application/location/location_cubit.dart';
import 'package:greep/application/notification/user_notification_cubit.dart';
import 'package:greep/application/order/order_crud_cubit.dart';
import 'package:greep/application/order/order_list_cubit.dart';
import 'package:greep/application/order/single_order_cubit.dart';
import 'package:greep/application/product/product_list_cubit.dart';
import 'package:greep/application/transactions/customer_statistics_cubit.dart';
import 'package:greep/application/transactions/transaction_crud_cubit.dart';
import 'package:greep/application/transactions/transaction_summary_cubit.dart';
import 'package:greep/application/transactions/transaction_trips_cubit.dart';
import 'package:greep/application/transactions/trip_direction_builder_cubit.dart';
import 'package:greep/application/transactions/user_transactions_cubit.dart';
import 'package:greep/application/driver/drivers_cubit.dart';
import 'package:greep/application/driver/manager_requests_cubit.dart';
import 'package:greep/application/user/auth_user_cubit.dart';
import 'package:greep/application/user/user_crud_cubit.dart';
import 'package:greep/application/user/user_cubit.dart';
import 'package:greep/application/user/user_list_cubit.dart';
import 'package:greep/application/wallet/conversion_rate_cubit.dart';
import 'package:greep/application/wallet/user_wallet_cubit.dart';
import 'package:greep/application/wallet/wallet_crud_cubit.dart';
import 'package:greep/domain/auth/AuthenticationClient.dart';
import 'package:greep/domain/auth/AuthenticationService.dart';
import 'package:greep/domain/customer/customer_client.dart';
import 'package:greep/domain/customer/customer_service.dart';
import 'package:greep/domain/notification/notification_client.dart';
import 'package:greep/domain/notification/notification_service.dart';
import 'package:greep/domain/order/order_client.dart';
import 'package:greep/domain/order/order_service.dart';
import 'package:greep/domain/product/product_client.dart';
import 'package:greep/domain/product/product_service.dart';
import 'package:greep/domain/transaction/transaction_client.dart';
import 'package:greep/domain/transaction/transaction_service.dart';
import 'package:greep/domain/user/UserService.dart';
import 'package:greep/domain/user/user_client.dart';
import 'package:greep/domain/wallet/wallet_client.dart';
import 'package:greep/domain/wallet/wallet_service.dart';

var getIt = GetIt.instance;

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
  late AuthenticationClient _authenticationClient;
  late NewManagerAcceptsCubit _newManagerAcceptsCubit;

  void initServices() {
    getIt.registerSingleton(
      NotificationService(
        notificationClient: NotificationClient(),
      ),
    );
    getIt.registerSingleton(
      WalletService(
        walletClient: WalletClient(),
      ),
    );
    getIt.registerSingleton(OrderService(orderClient: OrderClient(),),);
    getIt.registerSingleton(ProductService(productClient: ProductClient(),),);
  }

  IoC() {
    initServices();
    getIt.registerLazySingleton(() => LocationCubit());
    _authenticationClient = AuthenticationClient();
    getIt.registerSingleton(_authenticationClient);
    _authenticationService =
        AuthenticationService(authenticationClient: getIt());
    _authenticationCubit = AuthenticationCubit(_authenticationService);
    _userService = UserService(UserClient());

    getIt.registerSingleton(_userService);
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

    getIt.registerLazySingleton(
      () => TripDirectionBuilderCubit(
        locationCubit: getIt(),
      ),
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

    _userCustomersCubit = UserCustomersCubit(
        customerService: _customerService,
        transactionsCubit: _userTransactionsCubit);

    getIt.registerLazySingleton(() => _authenticationCubit);
    getIt.registerSingleton(_authenticationService);

    getIt.registerSingleton(_userCubit);
    getIt.registerSingleton(
      AuthUserCubit(
        authenticationCubit: getIt(),
        userService: getIt(),
      ),
    );
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
    getIt.registerFactory(() => UserListCubit(
      userService: getIt(),
    ));
    getIt.registerSingleton(_userCustomersCubit);

    getIt.registerFactory(() => PasswordCrudCubit(
          authenticationService: _authenticationService,
        ));
    getIt.registerFactory(() => EmailVerificationCubit(
          authenticationService: getIt(),
        ));
    getIt.registerFactory(() => UserCrudCubit(
          userService: _userService,
        ));
    getIt.registerSingleton(
      ConversionRateCubit(walletService: getIt(), userCubit: getIt()),
    );
    getIt.registerFactory(() => TransactionTripsCubit());
    getIt.registerFactory(() => GeoCoderCubit());

    getIt.registerFactory(() => DriverLocationStatusCubit());

    getIt.registerSingleton(
        UserWalletCubit(walletService: getIt(), userCubit: getIt()));
    getIt.registerFactory(() => WalletCrudCubit(
      walletService: getIt(),
    ));
    getIt.registerFactory(
          () => ProductListCubit(productService: getIt()),
    );

    getIt.registerFactory(() =>
        SingleOrderCubit(
          orderService: getIt(),
        ),
    );
    getIt.registerSingleton(
      OrderListCubit(
        orderService: getIt(),
      ),
    );
    getIt.registerFactory(() =>
      OrderCrudCubit(
        orderService: getIt(),
      ),
    );
    getIt.registerSingleton(
      UserNotificationCubit(
        notificationService: getIt(),
      ),
    );
  }
}
