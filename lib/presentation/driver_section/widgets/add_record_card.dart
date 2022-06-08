import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grip/commons/ui_helpers.dart';

class AddRecord extends StatelessWidget {
  const AddRecord(
      {Key? key,
      required this.color,
      required this.icon,
      required this.title,
        this.width,
      required this.textStyle})
      : super(key: key);

  final Color color;
  final String icon;
  final double? width;
  final String title;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? Get.width * 0.45,
      padding: const EdgeInsets.all(kDefaultSpacing),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: color,
          width: 0.7,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(icon, width: 20, height: 20),
          kHorizontalSpaceRegular,
          Text(
            title,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
