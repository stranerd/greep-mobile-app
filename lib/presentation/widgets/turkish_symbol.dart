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
      "assets/icons/turkish.svg",
      width: (width ?? 13 * 0.75),
      height: (height ?? 13 * 0.75),
      color: color ?? kBlackColor,
      fit: BoxFit.cover,
    );
  }
}
