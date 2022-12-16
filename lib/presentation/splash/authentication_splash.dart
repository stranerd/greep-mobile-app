import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as g;
import 'package:greep/application/auth/AuthenticationCubit.dart';
import 'package:greep/application/user/user_cubit.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/scaffold_messenger_service.dart';
import 'package:greep/presentation/driver_section/home_page.dart';
import 'package:greep/presentation/driver_section/nav_pages/nav_bar/nav_bar_view.dart';
import 'package:greep/presentation/splash/splash.dart';
import 'package:greep/presentation/widgets/email_verification_bottom_sheet.dart';

class AuthenticationSplashScreen extends StatefulWidget {
  final bool isNewUser;
  const AuthenticationSplashScreen({Key? key, this.isNewUser = false}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<AuthenticationSplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("On authentication Splash Screen");
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        print(state);
        if (state is UserStateFetched) {
          if (widget.isNewUser){
            g.Get.offAll(const EmailVerificationBottomSheet(),
                transition: g.Transition.cupertino);
          }
          else {
            g.Get.offAll(() => const NavBarView(),
                transition: g.Transition.fadeIn);
          }

        }
        if (state is UserStateError) {
          if (state.isSocket || state.isConnectionTimeout) {
            Fluttertoast.showToast(msg: state.errorMessage ?? "Please check your internet");
          } else {
            Fluttertoast.showToast(msg: "token expired, please login again");
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
