import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/utils/constants/app_colors.dart';

class BoxShadowContainer extends StatelessWidget {
  const BoxShadowContainer(
      {Key? key,
      this.height,
      this.backgroundColor,
      this.verticalPadding = 16,
      this.horizontalPadding = 16,
      required this.child,
      this.width,
      this.margin})
      : super(key: key);
  final double? height;
  final double? width;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final Widget child;
  final double verticalPadding;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding.w,
        vertical: verticalPadding.h,
      ),
      decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          border: Border.all(width: 2,color: Color(0xFFF1F3F7)),
          borderRadius: BorderRadius.circular(12.r)),
      child: child,
    );
  }
}
