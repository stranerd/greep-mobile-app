import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as g;
import 'package:greep/application/auth/AuthenticationCubit.dart';
import 'package:greep/application/user/user_cubit.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/scaffold_messenger_service.dart';
import 'package:greep/presentation/driver_section/home_page.dart';
import 'package:greep/presentation/driver_section/nav_pages/nav_bar/nav_bar_view.dart';
import 'package:greep/presentation/splash/splash.dart';

class AuthenticationSplashScreen extends StatefulWidget {
  const AuthenticationSplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<AuthenticationSplashScreen>
    with ScaffoldMessengerService {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserStateFetched) {
            g.Get.offAll(() => const NavBarView(),
                transition: g.Transition.fadeIn);
        }
        if (state is UserStateError) {
          if (state.isSocket || state.isConnectionTimeout) {
            error = state.errorMessage ?? "Please check your internet";
          } else {
            error = "token expired, please login again";
          }
          context.read<AuthenticationCubit>().signout();
          Future.delayed(const Duration(seconds: 2), () => g.Get.offAll(() => const SplashScreen()));
        }
      },
      child: Container(
          width: g.Get.width,
          decoration: const BoxDecoration(color: kWhiteColor),
          height: g.Get.height,
          child: const Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            ),
          )),
    );
    // return FullScreenSpinner(opacityColor: Colors.white);
  }
}
