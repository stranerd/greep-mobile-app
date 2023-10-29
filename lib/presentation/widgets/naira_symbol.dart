import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';


class NairaSymbol extends StatelessWidget {
  final double? width;
  final double? height;
  final Color color;

  const NairaSymbol({Key? key, required this.width, this.color = Colors.black, required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/icons/naira.svg",
      width: width ?? 14.r,
      height: height ?? 14.r,
      color: color,
      fit: BoxFit.cover,
    );
  }
}
