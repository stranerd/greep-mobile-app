import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/auth/AuthenticationCubit.dart';
import 'package:grip/application/auth/AuthenticationState.dart';
import 'package:grip/application/driver/drivers_cubit.dart';
import 'package:grip/application/driver/manager_drivers_cubit.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/presentation/driver_section/add_driver_screen.dart';
import 'package:grip/presentation/driver_section/drivers/drivers_screen.dart';
import 'package:grip/presentation/driver_section/nav_pages/settings/commission/total_income.dart';
import 'package:grip/presentation/driver_section/widgets/settings_home_item.dart';
import 'package:grip/presentation/splash/splash.dart';
import 'package:grip/presentation/widgets/splash_tap.dart';
import 'package:grip/utils/constants/app_styles.dart';

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
          title: Text(
            "Settings",
            style: AppTextStyles.blackSizeBold14,
          ),
          centerTitle: false,
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: SafeArea(
            child: BlocBuilder<DriversCubit, DriversState>(
              builder: (context, state) {
                return Column(
                  children: [
                    SplashTap(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileView(),
                          ),
                        );
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const DriversScreen(),
                                  ),
                                );
                              },
                              child: const SettingsHomeItem(
                                  title: "Drivers",
                                  icon: "assets/icons/local_taxi.svg"),
                            ),
                            kVerticalSpaceSmall,
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const TotalIncome(),
                                    ),
                                  );
                                },
                                child: const SettingsHomeItem(
                                    title: "Total Income",
                                    icon: "assets/icons/monetization_on.svg"),
                              ),
                              const SizedBox(height: 8),
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const CommissionHome(),
                                    ),
                                  );
                                },
                                child: const SettingsHomeItem(
                                    title: "Commission",
                                    icon: "assets/icons/monetization_on.svg"),
                              ),
                              const SizedBox(height: 8),
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
                            builder: (context) => const AboutHome(),
                          ),
                        );
                      },
                      child: const SettingsHomeItem(
                          title: "About", icon: "assets/icons/info.svg"),
                    ),
                    const SizedBox(height: 8),
                    SplashTap(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ContactUs(),
                          ),
                        );
                      },
                      child: const SettingsHomeItem(
                          title: "Contact Us",
                          icon: "assets/icons/headphones.svg"),
                    ),
                    kVerticalSpaceLarge,
                    kVerticalSpaceLarge,
                    TextButton(
                        onPressed: signout,
                        child: Text(
                          "Sign Out",
                          style: kErrorColorTextStyle,
                        ))
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void signout() {
    GetIt.I<AuthenticationCubit>().signout();
  }
}
