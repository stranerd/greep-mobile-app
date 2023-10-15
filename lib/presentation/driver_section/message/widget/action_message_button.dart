import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greep/utils/constants/app_colors.dart';

class ActionMessageButton extends StatelessWidget {
  final bool isTyping;
  final Function onTap;

  const ActionMessageButton(
      {Key? key, required this.isTyping, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25.r,
      height: 25.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0x0C101828),
            blurRadius: 2.r,
            offset: const Offset(0, 1),
            spreadRadius: 0,
          )
        ],
      ),
      child: SvgPicture.asset(
        "assets/icons/send.svg",
        colorFilter: ColorFilter.mode(
          isTyping ? AppColors.black : AppColors.veryLightGray,
          BlendMode.srcIn,
        ),
        fit: BoxFit.cover,
      ),
    );
  }
}
