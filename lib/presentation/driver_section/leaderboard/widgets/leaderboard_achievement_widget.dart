import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:greep/presentation/widgets/box_shadow_container.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class LeaderboardAchievementWidget extends StatelessWidget {
  final String asset;
  final String title;
  final String subtitle;
  const LeaderboardAchievementWidget({Key? key, required this.asset, required this.title, required this.subtitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BoxShadowContainer(
        horizontalPadding: 12,
        verticalPadding: 12,
        child: Row(
      children: [
        SvgPicture.asset(asset,width:40.r ,height: 40.r,),
        SizedBox(width: 8.w,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(title,fontSize: 16.sp,weight: FontWeight.bold,),
              TextWidget(subtitle,fontSize: 12.sp,color: AppColors.veryLightGray,),
            ],
          ),
        )
      ],
    ));
  }
}
