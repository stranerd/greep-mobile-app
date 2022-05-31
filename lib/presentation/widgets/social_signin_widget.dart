import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/ui_helpers.dart';
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
          borderRadius: BorderRadius.circular(kDefaultSpacing * 0.5),

          border: Border.all(color: kBlackColor,width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, width: 25,height: 25,),
            kHorizontalSpaceRegular,
            Text(text,style: kDefaultTextStyle,)
          ],
        ),
      ),
    );
  }
}
