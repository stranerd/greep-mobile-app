import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

import '../../../../../utils/constants/app_styles.dart';

class AccountItemCard extends StatelessWidget {

  const AccountItemCard(
      {Key? key,
      required this.title,
      required this.subtitle,
      this.isSelectable = false})
      : super(key: key);
  final String title;
  final String subtitle;
  final bool isSelectable;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 12.h),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 2.w,color: AppColors.lightGray),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            title,
            fontSize: 12.sp,
            color: AppColors.veryLightGray,
          ),
          isSelectable
              ? SelectableText(
                  subtitle,
                  style: AppTextStyles.blackSize16.copyWith(
                    fontSize: 16.sp
                  ),

                )
              : TextWidget(
                  subtitle,
            fontSize: 16.sp,
                ),
        ],
      ),
    );
  }
}
