import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/auth/AuthenticationCubit.dart';
import 'package:grip/application/auth/SignupCubit.dart';
import 'package:grip/application/transactions/customer_statistics_cubit.dart';
import 'package:grip/application/transactions/transaction_summary_cubit.dart';
import 'package:grip/application/transactions/user_transactions_cubit.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/scaffold_messenger_service.dart';
import 'package:grip/commons/themes.dart';
import 'package:grip/ioc.dart';
import 'package:grip/presentation/splash/splash.dart';

void main() {
  var ioc = IoC();
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
          value: GetIt.I<SignupCubit>(),
        ),
        BlocProvider.value(
          value: GetIt.I<UserTransactionsCubit>(),
        ),
        BlocProvider.value(
          value: GetIt.I<TransactionSummaryCubit>(),
        ),
        BlocProvider.value(
          value: GetIt.I<CustomerStatisticsCubit>(),
        ),
      ],
      child: ScreenUtilInit(
          designSize: const Size(414, 896),
          minTextAdapt: true,
          builder: () => GetMaterialApp(
                debugShowCheckedModeBanner: false,
                theme: theme,
                color: kPrimaryColor,
                home: const SplashScreen(),
                scaffoldMessengerKey:
                    ScaffoldMessengerService.scaffoldMessengerKey,
              )),
    );
  }
}
