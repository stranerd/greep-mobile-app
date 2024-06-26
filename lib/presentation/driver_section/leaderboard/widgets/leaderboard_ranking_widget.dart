import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greep/domain/user/model/User.dart';
import 'package:greep/presentation/widgets/box_shadow_container.dart';
import 'package:greep/presentation/widgets/profile_photo_widget.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class LeaderboardRankingWidget extends StatelessWidget {
  final User user;
  final int index;
  const LeaderboardRankingWidget({Key? key, required this.user, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BoxShadowContainer(
        verticalPadding: 12,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                TextWidget(
                  "$index",
                  fontSize: 16.sp,
                  weight: FontWeight.bold,
                ),
                SizedBox(
                  width: 12.w,
                ),
                ProfilePhotoWidget(
                  url: user.photoUrl,
                  radius: 20,
                  initials: "",
                ),

                SizedBox(
                  width: 12.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      user.firstName,
                      fontSize: 16.sp,
                      weight: FontWeight.bold,
                    ),
                    TextWidget(
                      "Recruit",
                      color: AppColors.veryLightGray,
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextWidget(
                  "0",
                  fontSize: 16.sp,
                ),
                SvgPicture.asset(
                  "assets/icons/arrowup-bold.svg",
                ),
              ],
            )
          ],
        ));
  }
}
