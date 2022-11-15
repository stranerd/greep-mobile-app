import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/auth/AuthenticationCubit.dart';
import 'package:grip/application/auth/SignupCubit.dart';
import 'package:grip/application/customers/user_customers_cubit.dart';
import 'package:grip/application/driver/drivers_cubit.dart';
import 'package:grip/application/driver/manager_drivers_cubit.dart';
import 'package:grip/application/driver/manager_requests_cubit.dart';
import 'package:grip/application/driver/new_manager_accepts_cubit.dart';
import 'package:grip/application/driver/new_manager_requests_cubit.dart';
import 'package:grip/application/fcm/fcm_notification_service.dart';
import 'package:grip/application/local_notification/local_notification_service.dart';
import 'package:grip/application/transactions/customer_statistics_cubit.dart';
import 'package:grip/application/transactions/transaction_summary_cubit.dart';
import 'package:grip/application/transactions/user_transactions_cubit.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/scaffold_messenger_service.dart';
import 'package:grip/commons/themes.dart';
import 'package:grip/ioc.dart';
import 'package:grip/presentation/splash/splash.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await dotenv.load(fileName: ".env");

  var ioc = IoC();

  if (Platform.isIOS) {
    String serverToken = dotenv.env['FIREBASEOPTIONS_APIKEY']??"";

    await Firebase.initializeApp(
      name: "Greep",
      options: FirebaseOptions(
        apiKey: serverToken,
        appId: "1:891214249172:ios:028e8f16aa47a69dbe0f41",
        messagingSenderId: "891214249172",
        projectId: "greepio",
      ),
    );
  }
  else {

    await Firebase.initializeApp();
  }

  try {
    FirebaseMessaging.instance.requestPermission();

    FirebaseMessaging.instance.getToken().then((value) {});
  }
  catch (_){}
  GestureBinding.instance.resamplingEnabled = true;

  FCMNotificationService.initialize();

  LocalNotificationService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: GetIt.I<AuthenticationCubit>(),
        ),
        BlocProvider.value(
          value: GetIt.I<UserCubit>(),
        ),
        BlocProvider.value(
          value: GetIt.I<DriversCubit>(),
        ),
        BlocProvider.value(
          value: GetIt.I<SignupCubit>(),
        ),
        BlocProvider.value(
          value: GetIt.I<UserTransactionsCubit>(),
        ),
        BlocProvider.value(
          value: GetIt.I<ManagerDriversCubit>(),
        ),
        BlocProvider.value(
          value: GetIt.I<TransactionSummaryCubit>(),
        ),
        BlocProvider.value(
          value: GetIt.I<CustomerStatisticsCubit>(),
        ),
        BlocProvider.value(
          value: GetIt.I<NewManagerRequestsCubit>(),
        ),
        BlocProvider.value(
          value: GetIt.I<NewManagerAcceptsCubit>(),
        ),
        BlocProvider.value(
          value: GetIt.I<UserCustomersCubit>(),
        ),
        BlocProvider.value(
          value: GetIt.I<ManagerRequestsCubit>(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(414, 896),
        minTextAdapt: true,
        builder: (_,__) => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          color: kPrimaryColor,
          home: const SplashScreen(),
          scaffoldMessengerKey: ScaffoldMessengerService.scaffoldMessengerKey,
        ),
      ),
    );
  }
}
