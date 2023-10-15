import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Commons/colors.dart';

class TurkishSymbol extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;

  const TurkishSymbol({Key? key, this.width, this.color, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/icons/turkish2.svg",
      width: (width ?? 14.r ),
      height: (height ?? 14.r),
      color: color ?? kBlackColor,
      fit: BoxFit.cover,
    );
  }
}
