import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/themes.dart';
import 'package:grip/presentation/auth/home/auth_home.dart';
import 'package:grip/presentation/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(414, 896),
        minTextAdapt: true,
        builder: () => GetMaterialApp(
              debugShowCheckedModeBanner: false,
              theme: theme,
              color: kPrimaryColor,
              home: const AuthHomeScreen(),
            ));
  }
}
