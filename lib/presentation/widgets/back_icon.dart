import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';

class BackIcon extends StatelessWidget {
  final double size;
  final EdgeInsets? padding;
  final Function? onTap;
  final bool isArrow;
  final String? icon;
  final Color? color;
  const BackIcon({Key? key, this.size = 30, this.color, this.padding, this.icon, this.onTap, this.isArrow = false,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if (onTap == null){
          Get.back();
        }
        else {
          onTap!();
        }
      },
      child: Container(
        alignment: Alignment.centerLeft,
        padding: padding,
        // decoration: BoxDecoration(color: Colors.w),
        child: SvgPicture.asset(
          icon ?? (isArrow ?"assets/icons/arrowleft.svg" :"assets/icons/close.svg"),
          width: size.r,
          height: size.r,
          color: color,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
