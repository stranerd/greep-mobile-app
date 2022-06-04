import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/ui_helpers.dart';

class RecordCard extends StatelessWidget {
  const RecordCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.titleStyle,
    this.width,
    required this.subtitleStyle,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final double? width;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kDefaultSpacing * 0.75),
      height: 80,
      width: width ?? Get.width * 0.3,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: kGreyColor2,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: titleStyle),
          const SizedBox(height: 8.0),
          Text(subtitle, style: kDefaultTextStyle.copyWith(
            fontSize: 12
          )),
        ],
      ),
    );
  }
}
