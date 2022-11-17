import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/widgets/text_widget.dart';

import '../../../utils/constants/app_styles.dart';

class SettingsHomeItem extends StatelessWidget {
  const SettingsHomeItem({Key? key, required this.title, required this.icon})
      : super(key: key);

  final String title;
  final String icon;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kDefaultSpacing),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: kLightGrayColor,
      ),
      child: Row(
        children: [
          SvgPicture.asset(icon, width: 18.w, height: 18.w,),
           SizedBox(width: 20.0.w),
          TextWidget(title, style: AppTextStyles.blackSize16),
          const Spacer(),
           Icon(Icons.arrow_forward_ios, size: 16.r),
        ],
      ),
    );
  }

}
