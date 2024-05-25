import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as g;
import 'package:get/get.dart';
import 'package:greep/application/auth/AuthenticationCubit.dart';
import 'package:greep/application/auth/email_verification/email_verification_cubit.dart';
import 'package:greep/application/location/location_cubit.dart';
import 'package:greep/application/location/location_state.dart';
import 'package:greep/application/user/auth_user_cubit.dart';
import 'package:greep/application/user/user_cubit.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/scaffold_messenger_service.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/ioc.dart';
import 'package:greep/presentation/auth/home/auth_home.dart';
import 'package:greep/presentation/auth_finish_signup.dart';
import 'package:greep/presentation/driver_section/home_page.dart';
import 'package:greep/presentation/driver_section/nav_pages/nav_bar/nav_bar_view.dart';
import 'package:greep/presentation/splash/splash.dart';
import 'package:greep/presentation/widgets/code_verification_bottom_sheet.dart';
import 'package:greep/presentation/widgets/email_verification_bottom_sheet.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class AuthenticationSplashScreen extends StatefulWidget {
  final bool isNewUser;
  final String? email;
  final String? password;

  const AuthenticationSplashScreen(
      {Key? key, this.isNewUser = false, this.email, this.password})
      : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<AuthenticationSplashScreen> {
  late LocationCubit locationCubit;
  late EmailVerificationCubit emailVerificationCubit;

  @override
  void initState() {
    locationCubit = getIt();
    emailVerificationCubit = getIt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthUserCubit, AuthUserState>(
      listener: (context, state) async {
        if (state is AuthUserStateFetched) {
          if (!state.user.isVerified){
            emailVerificationCubit.sendVerificationCode(state.user.email);
            var isVerified = await Get.bottomSheet<bool>(
                CodeVerificationBottomSheet(
                  onResendCode: (){
                    emailVerificationCubit.sendVerificationCode(state.user.email);

                  },
                  verificationMode: VerificationMode.signup,
                  onCompleted: (code) {
                    return emailVerificationCubit.confirmVerificationCode(
                        token: code);
                  },
                  email: state.user.email,
                ),
                isScrollControlled: true,
                ignoreSafeArea: false);
            if (isVerified ?? false) {
              if (widget.isNewUser){
              Get.offAll(
                const AuthFinishSignup(),
              );}
              else {
                Get.offAll(NavBarView());
              }
            } else {
              getIt<AuthenticationCubit>().signout();
              Get.off(() => AuthHomeScreen());
            }
          }
           else {
            if (locationCubit.state is LocationStateOff) {
              showModalBottomSheet(
                  context: context,
                  isDismissible: false,
                  isScrollControlled: true,
                  builder: (context) {
                    return Container(
                      padding: const EdgeInsets.all(kDefaultSpacing),
                      decoration: const BoxDecoration(
                        color: kWhiteColor,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          kVerticalSpaceLarge,
                          Image.asset(
                            "assets/images/about_greep.png",
                            scale: 2,
                          ),
                          kVerticalSpaceLarge,
                          TextWidget(
                            "Allow “Greep” to access your location?",
                            weight: FontWeight.bold,
                            fontSize: 20.sp,
                          ),
                          kVerticalSpaceRegular,
                          TextWidget(
                            "Your location data will be used to give you a realtime ride experience of your trips and allow managers to see your trip history and realtime trip progress",
                            weight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                          kVerticalSpaceLarge,
                          const Divider(
                            color: AppColors.lightBlue,
                          ),
                          GestureDetector(
                            onTap: () async {
                              var isOn = await locationCubit.subscribe();
                              if (isOn) {
                                locationCubit.emitOn();
                              } else {}
                              g.Get.offAll(
                                () => const NavBarView(),
                                transition: g.Transition.fadeIn,
                              );
                            },
                            child: Column(
                              children: [
                                kVerticalSpaceSmall,
                                TextWidget(
                                  "Allow",
                                  color: AppColors.blue,
                                  fontSize: 18.sp,
                                  weight: FontWeight.bold,
                                ),
                                kVerticalSpaceSmall,
                              ],
                            ),
                          ),
                          const Divider(
                            color: AppColors.lightBlue,
                          ),
                          GestureDetector(
                            onTap: () {
                              g.Get.offAll(
                                () => const NavBarView(),
                                transition: g.Transition.fadeIn,
                              );
                            },
                            child: Column(
                              children: [
                                kVerticalSpaceSmall,
                                TextWidget(
                                  "Don't Allow",
                                  color: AppColors.blue,
                                  fontSize: 18.sp,
                                ),
                                kVerticalSpaceSmall,
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            } else {
              g.Get.offAll(
                () => const NavBarView(),
                transition: g.Transition.fadeIn,
              );
            }
          }
        }
        if (state is AuthUserStateError) {
          print("user state error  ${state.errorMessage}");
          if (state.isSocket || state.isConnectionTimeout) {
            Fluttertoast.showToast(
                msg: state.errorMessage ?? "Please check your internet");
          } else {
            Fluttertoast.showToast(msg: "token expired, please login again");
          }
          context.read<AuthenticationCubit>().signout();
          Future.delayed(const Duration(seconds: 2),
              () => g.Get.offAll(() => const SplashScreen()));
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
