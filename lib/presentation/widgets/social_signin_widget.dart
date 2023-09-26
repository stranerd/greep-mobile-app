import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
class SocialSigninWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final String icon;
  const SocialSigninWidget({Key? key,required this.onTap, required this.text, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),

          border: Border.all(color: const Color(0xFFE0E2E4),width: 2,),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon.endsWith("svg") ? SvgPicture.asset(icon,height: 25.r,width: 25.r,): Image.asset(icon, width: 25.r,height: 25.r,),
            kHorizontalSpaceRegular,
            TextWidget(text,)
          ],
        ),
      ),
    );
  }
}
