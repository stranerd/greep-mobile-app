import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as g;
import 'package:get/get.dart';
import 'package:greep/application/user/user_cubit.dart';
import 'package:greep/application/user/user_cubit.dart';
import 'package:greep/commons/Utils/utils.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/driver_section/leaderboard/leaderboard_screen.dart';
import 'package:greep/presentation/driver_section/nav_pages/settings/account/view_profile.dart';
import 'package:greep/presentation/driver_section/nav_pages/settings/home_page.dart';
import 'package:greep/presentation/driver_section/notifications/notifications_screen.dart';
import 'package:greep/presentation/widgets/profile_photo_widget.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget{
  final String title;

  const CustomAppbar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white
            ),
            height: kToolbarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 16.w,),
                  child: title.isEmpty
                      ? SvgPicture.asset("assets/icons/greep_logo.svg",)
                      : TextWidget(
                    title,
                    weight: FontWeight.w700,
                    fontSize: 18.sp,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SplashTap(
                      onTap: () {
                        Get.to(() => const NotificationsScreen());
                      },
                      child: SvgPicture.asset(
                        "assets/icons/notification.svg",
                      ),
                    ),
                    SizedBox(width: 16.w,),

                    SplashTap(
                      onTap: () {
                        Get.to(() => const LeaderboardScreen());

                      },
                      child: SvgPicture.asset(
                        "assets/icons/leaderboard.svg",
                      ),
                    ),
                    SizedBox(width: 16.w,),
                    SplashTap(
                        onTap: () {
                          g.Get.to(
                                  () =>
                              const SettingsHome(),
                              transition: g
                                  .Transition
                                  .fadeIn);
                        },
                        child: ProfilePhotoWidget(url: state
                        is UserStateFetched
                            ? state
                            .user
                            .photoUrl
                            : "",initials: Utils.getInitials(state is UserStateFetched ? state.user.fullName : ""),)
                    ),
                    kHorizontalSpaceRegular
                  ],
                )
              ],
            ),

          );
        },
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
