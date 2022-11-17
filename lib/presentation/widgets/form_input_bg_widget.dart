import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/ui_helpers.dart';

class FormInputBgWidget extends StatelessWidget {
  final Widget child;
  const FormInputBgWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: kDefaultSpacing * 0.5, horizontal: kDefaultSpacing),
    height: Get.mediaQuery.orientation == Orientation.landscape ? 120.h :  50.h,
    alignment: Alignment.centerLeft,
    decoration: BoxDecoration(
    color: kBorderColor,
    borderRadius: BorderRadius.circular(5.r),
    ),
    child: child,);
  }
}
