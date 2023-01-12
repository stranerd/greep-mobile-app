import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:greep/Commons/colors.dart';
import 'package:greep/application/auth/AuthenticationCubit.dart';
import 'package:greep/application/auth/AuthenticationState.dart';
import 'package:greep/application/driver/drivers_cubit.dart';
import 'package:greep/application/driver/manager_drivers_cubit.dart';
import 'package:greep/application/user/user_cubit.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/driver_section/add_driver_screen.dart';
import 'package:greep/presentation/driver_section/drivers/drivers_screen.dart';
import 'package:greep/presentation/driver_section/nav_pages/settings/about/privacy_policy.dart';
import 'package:greep/presentation/driver_section/nav_pages/settings/about/terms_and_conditions.dart';
import 'package:greep/presentation/driver_section/nav_pages/settings/commission/total_income.dart';
import 'package:greep/presentation/driver_section/widgets/settings_home_item.dart';
import 'package:greep/presentation/splash/splash.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';
import 'package:greep/utils/constants/app_styles.dart';

import 'about/about_home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'account/view_profile.dart';
import 'commission/commission.dart';
import 'contact_us.dart';

class SettingsHome extends StatelessWidget {
  const SettingsHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationStateNotAuthenticated) {
          Get.offAll(
                () => const SplashScreen(),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: TextWidget(
            "Settings",
            style: AppTextStyles.blackSizeBold16,
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: SafeArea(
            child: Padding(
              padding:  EdgeInsets.fromLTRB(16.r, 16.r, 16.r, 0),
              child: BlocBuilder<DriversCubit, DriversState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      SplashTap(
                        onTap: () {
                          Get.to(() => const ProfileView());
                        },
                        child: const SettingsHomeItem(
                            title: "Account", icon: "assets/icons/person.svg"),
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<UserCubit, UserState>(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SplashTap(
                                onTap: () {
                                  Get.to(() => const DriversScreen());
                                },
                                child: const SettingsHomeItem(
                                    title: "Drivers",
                                    icon: "assets/icons/local_taxi.svg"),
                              ),
                                                             SizedBox(height: 8.h),

                            ],
                          );
                        },
                      ),
                      BlocBuilder<DriversCubit, DriversState>(
                        builder: (context, state) {
                          if (state is DriversStateManager) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SplashTap(
                                  onTap: () {
                                    Get.to(() => const TotalIncome());
                                  },
                                  child: const SettingsHomeItem(
                                      title: "Total Income",
                                      icon: "assets/icons/monetization_on.svg"),
                                ),
                                 SizedBox(height: 8.h),
                              ],
                            );
                          }
                          return Container();
                        },
                      ),
                      BlocBuilder<UserCubit, UserState>(
                        builder: (context, state) {
                          if (state is UserStateFetched &&
                              state.user.hasManager) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SplashTap(
                                  onTap: () {
                                    Get.to(() => const CommissionHome());
                                  },
                                  child: const SettingsHomeItem(
                                      title: "Commission",
                                      icon: "assets/icons/monetization_on.svg"),
                                ),
                                 SizedBox(height: 8.h),
                              ],
                            );
                          }
                          return Container();
                        },
                      ),
                      SplashTap(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PrivacyPolicy(),
                            ),
                          );
                        },
                        child: const SettingsHomeItem(
                            title: "Privacy Policy", icon: "assets/icons/privacy.svg"),
                      ),
                      kVerticalSpaceSmall,
                      SplashTap(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TermsAndConditions(),
                            ),
                          );
                        },
                        child: const SettingsHomeItem(
                            title: "Services Agreement", icon: "assets/icons/terms.svg"),
                      ),
                      kVerticalSpaceSmall,
                      SplashTap(
                        onTap: () {
                          Get.to(() => const AboutHome());
                        },
                        child: const SettingsHomeItem(
                            title: "About Us", icon: "assets/icons/info.svg"),
                      ),
                       SizedBox(height: 8.h),
                      SplashTap(
                        onTap: () {
                          Get.to(() => const ContactUs());

                        },
                        child: const SettingsHomeItem(
                            title: "Contact Us",
                            icon: "assets/icons/headphones.svg"),
                      ),
                      kVerticalSpaceLarge,
                      Divider(),
                      kVerticalSpaceRegular,
                      Container(
                        padding: EdgeInsets.only(left: 10.w),
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                            onTap: () => signout(context),
                            child: TextWidget(

                              "Sign Out",
                              textAlign: TextAlign.left,
                              style: kErrorColorTextStyle,
                            )),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signout(context) async{
    bool shouldDelete = await showDialog<bool?>(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return Dialog(
              child: Container(
                padding:
                const EdgeInsets.all(kDefaultSpacing),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Are you sure you want sign out?",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: kDefaultTextStyle.copyWith(
                          height: 1.35),
                    ),
                    kVerticalSpaceRegular,
                    kVerticalSpaceLarge,
                    Flexible(
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    padding:
                                    EdgeInsets.zero,
                                    backgroundColor:
                                    kPrimaryColor,
                                    minimumSize:
                                    const Size(150, 50)),
                                onPressed: () {
                                  Get.back(result: false);
                                },
                                child: Text(
                                  "Cancel",
                                  style: kBoldTextStyle
                                      .copyWith(
                                      color:
                                      kWhiteColor),
                                )),
                          ),
                          kHorizontalSpaceSmall,
                          Flexible(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  backgroundColor:
                                  AppColors.red,
                                  minimumSize:
                                  const Size(150, 50)),
                              child: Text(
                                "Sign out",
                                style: kWhiteTextStyle,
                              ),
                              onPressed: () {
                                Get.back(result: true);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        }) ??
        false;

    if (shouldDelete) {
      GetIt.I<AuthenticationCubit>().signout();

  } else {
  Get.back();
  }
  }
}
