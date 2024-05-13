import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomRadioToggleWidget extends StatelessWidget {
  final bool isOn;
  const CustomRadioToggleWidget({Key? key, required this.isOn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24.r,
      height: 24.r,
      child: SvgPicture.asset(
        "assets/icons/radio-${isOn ? "on" : "off"}.svg",
        fit: BoxFit.cover,
      ),
    );
  }
}
