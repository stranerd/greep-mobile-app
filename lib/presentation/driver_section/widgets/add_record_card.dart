import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';
import 'package:greep/utils/constants/app_styles.dart';

class AddRecord extends StatelessWidget {
  const AddRecord(
      {Key? key,
      required this.svg,
      required this.title,
        this.width,
      })
      : super(key: key);

  final Widget svg;
  final double? width;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? Get.width * 0.45,
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: kDefaultSpacing * 0.5, horizontal: kDefaultSpacing * 1.5),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 1,
            blurRadius: 0.5,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          svg,
          kHorizontalSpaceRegular,
          TextWidget(
            title,
            style:kDefaultTextStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }
}
