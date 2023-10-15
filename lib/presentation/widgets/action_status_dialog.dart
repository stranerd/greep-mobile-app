import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class ActionStatusDialog extends StatelessWidget {
  final Function? onTap;
  final String text;
  final String tapText;
  final bool isSuccess;

  const ActionStatusDialog(
      {Key? key,
      this.onTap,
      required this.text,
      required this.tapText,
      this.isSuccess = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(0),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r)
      ),
      child: Container(
        width: 0.9.sw,
        constraints: BoxConstraints(
          minHeight: 218.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget(
              text,
              fontSize: 14.sp,
            ),
            SizedBox(
              height: 32.h,
            ),
            SubmitButton(
              height: 45.h,
              width: 100.w,
              backgroundColor: isSuccess ?AppColors.green : AppColors.red,
              text: tapText,
              onSubmit: () {
                if (onTap != null) {
                  onTap!();
                } else {
                  Get.back();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
