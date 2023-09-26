import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as g;
import 'package:greep/application/auth/AuthenticationCubit.dart';
import 'package:greep/application/location/location_cubit.dart';
import 'package:greep/application/location/location_state.dart';
import 'package:greep/application/user/user_cubit.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/scaffold_messenger_service.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/ioc.dart';
import 'package:greep/presentation/driver_section/home_page.dart';
import 'package:greep/presentation/driver_section/nav_pages/nav_bar/nav_bar_view.dart';
import 'package:greep/presentation/splash/splash.dart';
import 'package:greep/presentation/widgets/email_verification_bottom_sheet.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class AuthenticationSplashScreen extends StatefulWidget {
  final bool isNewUser;

  const AuthenticationSplashScreen({Key? key, this.isNewUser = false})
      : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<AuthenticationSplashScreen> {
  late LocationCubit locationCubit;

  @override
  void initState() {
    locationCubit = getIt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserStateFetched) {
          if (widget.isNewUser) {
            g.Get.offAll(const EmailVerificationBottomSheet(),
                transition: g.Transition.cupertino);
          } else {
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
                          const TextWidget(
                            "Allow “Greep” to access your location?",
                            weight: FontWeight.bold,
                            fontSize: 22,
                          ),
                          kVerticalSpaceRegular,
                          const TextWidget(
                            "Your location data will be used to give you a realtime ride experience of your trips and allow managers to see your trip history and realtime trip progress",
                            weight: FontWeight.w500,
                            fontSize: 18,
                          ),
                          kVerticalSpaceLarge,
                          const Divider(
                            color: AppColors.lightBlue,
                          ),
                          GestureDetector(
                            onTap: () async{
                              var isOn = await locationCubit.subscribe();
                              if (isOn) {
                                locationCubit.emitOn();
                              }
                              else {
                              }
                              g.Get.back();
                              g.Get.offAll(
                                    () => const NavBarView(),
                                transition: g.Transition.fadeIn,
                              );
                            },
                            child: Column(
                              children: [
                                kVerticalSpaceSmall,
                                const TextWidget(
                                  "Allow",
                                  color: AppColors.blue,
                                  fontSize: 20,
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
                              g.Get.back();
                              g.Get.offAll(
                                () => const NavBarView(),
                                transition: g.Transition.fadeIn,
                              );
                            },
                            child: Column(
                              children: [
                                kVerticalSpaceSmall,
                                const TextWidget(
                                  "Don't Allow",
                                  color: AppColors.blue,
                                  fontSize: 20,
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
        if (state is UserStateError) {
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
