import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/utils/constants/app_colors.dart';
import 'package:grip/utils/constants/app_styles.dart';

class AddRecord extends StatelessWidget {
  const AddRecord(
      {Key? key,
      required this.icon,
      required this.title,
        this.width,
      })
      : super(key: key);

  final String icon;
  final double? width;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? Get.width * 0.45,
      padding: const EdgeInsets.all(kDefaultSpacing),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: AppColors.black,
          width: 0.7,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(icon, width: 25, height: 25),
          kHorizontalSpaceRegular,
          Text(
            title,
            style: AppTextStyles.blackSize14,
          ),
        ],
      ),
    );
  }
}
