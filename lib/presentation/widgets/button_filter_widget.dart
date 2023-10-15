import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greep/commons/Utils/utils.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class ButtonFilterWidget extends StatelessWidget {
  final bool isActive;
  final String text;
  final Function onTap;
  final Function? onCancel;
  final bool withCancel;

  const ButtonFilterWidget(
      {Key? key,
      required this.isActive,
      required this.text,
      required this.onTap,
      this.onCancel,
      this.withCancel = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textWidget = TextWidget(
      text.capitalizeFirstOfEach,
      fontSize: 12.sp,
      color: isActive ? Colors.white : null,
      textAlign: TextAlign.center,
    );
    return SplashTap(
      onTap: onTap,
      child: Container(
        height: 34.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(width: 1, color: AppColors.black),
          color: isActive ? AppColors.black : Colors.white,
        ),
        child: !withCancel
            ? textWidget
            : ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  textWidget,
                  SizedBox(
                    width: 5.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (onCancel != null) {
                        onCancel!();
                      }
                    },
                    child: Icon(
                      Icons.close,
                      color: isActive ? Colors.white : AppColors.black,
                      size: 15.sp,
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
