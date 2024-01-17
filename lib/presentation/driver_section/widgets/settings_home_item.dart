import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

import '../../../utils/constants/app_styles.dart';

class SettingsHomeItem extends StatelessWidget {
  const SettingsHomeItem({Key? key, required this.title, required this.icon,this.withIcon = true, this.color, this.withTrail = true})
      : super(key: key);

  final String title;
  final String icon;
  final Color? color;
  final bool withTrail;
  final bool withIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          12.r,
        ),
        border: Border.all(width: 2.w,color: AppColors.lightGray),
        color: Colors.white,
      ),
      child: Row(
        children: [
          if (withIcon)Row(
            children: [
              SvgPicture.asset(
                icon,
                width: 24.r,
                height: 24.r,
                color: color,
              ),
              SizedBox(width: 12.0.w),
            ],
          ),
          TextWidget(
            title,
            fontSize: 14.sp,
            color: color,
          ),
          if(withTrail)const Spacer(),
          if (withTrail)SvgPicture.asset(
            "assets/icons/arrowright.svg",
            color: AppColors.veryLightGray,
          ),
        ],
      ),
    );
  }
}
