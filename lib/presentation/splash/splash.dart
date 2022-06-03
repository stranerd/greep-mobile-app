import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:grip/application/auth/AuthenticationCubit.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/presentation/auth/home/auth_home.dart';
import 'package:grip/presentation/driver_section/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {
  var isFirstTime = true;

  @override
  void initState() {
    SharedPreferences.getInstance().then((pref) {
      if (pref.get("FirstRun") != null && pref.get("FirstRun") == true) {
        print("firstRun is not null");
        setState(() {
          isFirstTime = true;
        });
      } else if (pref.get("FirstRun") != null &&
          pref.get("FirstRun") == false) {
        setState(() {
          isFirstTime = false;
        });
      }
      Future.delayed(const Duration(milliseconds: 800), () => loadApp());
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Get.width,
        decoration: const BoxDecoration(
          color: kWhiteColor
        ),
        height: Get.height,
        child: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
        ));
    // return FullScreenSpinner(opacityColor: Colors.white);
  }

  Future<void> loadApp() async {
    // if (isFirstTime) {
    //   print("It is first time");
    //   Get.offAll(() => const AuthHomeScreen());
    //   return;
    // }
    //
    // print("It is  not first time");

    var authenticationCubit = BlocProvider.of<AuthenticationCubit>(context);
    var isAuthenticated = await authenticationCubit.checkAuth();
    if (isAuthenticated) {
      Get.offAll(() => const DriverHomePage());

    } else {
      Get.offAll(() => const AuthHomeScreen());

    }
  }
}
