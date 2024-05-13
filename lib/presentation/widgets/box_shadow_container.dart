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
        this.borderColor,
        this.withShadow = false,
      required this.child,
      this.width,
      this.margin})
      : super(key: key);
  final double? height;
  final double? width;
  final EdgeInsets? margin;
  final Color? borderColor;

  final Color? backgroundColor;
  final Widget child;
  final double verticalPadding;
  final bool withShadow;

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
          boxShadow: withShadow ? [
            BoxShadow(
              color: Color(
                  0xff0017260D
              ).withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 3.r,
              offset: Offset(
                0,
                4,
              ),

            )
          ] : null,
          border: withShadow ? null :Border.all(
            width: 2.w,
            color: borderColor ?? Color(0xFFF1F3F7),
          ),
          borderRadius: BorderRadius.circular(12.r)),
      child: child,
    );
  }
}
