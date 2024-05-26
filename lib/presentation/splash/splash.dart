import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:greep/application/auth/AuthenticationCubit.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/presentation/auth/home/auth_home.dart';
import 'package:greep/presentation/auth/onboarding/OnboardingSlides.dart';
import 'package:greep/presentation/auth/onboarding/OnboardingSlides2.dart';
import 'package:greep/presentation/driver_section/home_page.dart';
import 'package:greep/presentation/driver_section/nav_pages/nav_bar/nav_bar_view.dart';
import 'package:greep/presentation/splash/authentication_splash.dart';
import 'package:greep/presentation/widgets/loading_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);


  @override
  _SplashScreenState createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {
  var isFirstTime = true;

  @override
  void initState() {
    SharedPreferences.getInstance().then((pref) {
      print(pref.get("FirstRun"));
      if (pref.get("FirstRun") == null || pref.get("FirstRun") == true) {
        print("firstRun is not null");
          isFirstTime = true;
      } else if (pref.get("FirstRun") != null &&
          pref.get("FirstRun") == false) {
          isFirstTime = false;
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
        child: Center(
          child: LoadingWidget(
            size: 50.r,
            isGreep: true,

          ),
        ));
    // return FullScreenSpinner(opacityColor: Colors.white);
  }

  Future<void> loadApp() async {
    // print("isfirst time: $isFirstTime");
    if (isFirstTime) {
      Get.offAll(() => const OnboardingSlides2());
      return;
    }

    var authenticationCubit = BlocProvider.of<AuthenticationCubit>(context);
    var isAuthenticated = await authenticationCubit.checkAuth();
    if (isAuthenticated) {
      Get.offAll(() => const AuthenticationSplashScreen());

    } else {
      Get.offAll(() => const AuthHomeScreen());

    }
  }


}
