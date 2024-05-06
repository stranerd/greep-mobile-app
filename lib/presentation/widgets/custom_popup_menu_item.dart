import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class CustomPopupMenuItem extends StatelessWidget {
  final String? icon;
  final String text;
  final Color textColor;

  const CustomPopupMenuItem({
    Key? key,
     this.icon,
    required this.text,
    this.textColor = AppColors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         if (icon!=null) Row(
           children: [
             SvgPicture.asset(
                icon!,
                color: textColor,
                width: 18.r,
                height: 18.r,
              ),
             SizedBox(width: 10.w,),

           ],
         ),
          TextWidget(
            text,
            color: textColor,
            fontSize: 12.sp,
          ),

        ],
      ),
    );
  }
}
