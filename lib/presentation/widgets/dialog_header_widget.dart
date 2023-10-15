import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class DialogHeaderWidget extends StatelessWidget {
  final String title;

  const DialogHeaderWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kDefaultSpacing.r),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(
          width: 0.50.w,
          color: const Color(0xFFEDEEEF),
        ),
      )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextWidget(
            title,
            weight: FontWeight.w600,
            fontSize: 18.sp,
            color: AppColors.black,
          ),
          const BackIcon(),
        ],
      ),
    );
  }
}
