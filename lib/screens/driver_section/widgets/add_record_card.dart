import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddRecord extends StatelessWidget {
  const AddRecord(
      {Key? key,
      required this.color,
      required this.icon,
      required this.title,
      required this.textStyle})
      : super(key: key);

  final Color color;
  final String icon;
  final String title;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 50, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: color,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
            child: SvgPicture.asset(icon, width: 18.w, height: 18.h),
          ),
          Text(
            title,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
