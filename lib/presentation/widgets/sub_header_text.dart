import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greep/presentation/widgets/text_widget.dart';

class SubHeaderText extends StatelessWidget {
  const SubHeaderText({Key? key, required this.text}) : super(key: key);
final String text;
  @override
  Widget build(BuildContext context) {
    return TextWidget(
      text,
      weight: FontWeight.w700,
      fontSize: 16.sp,
    );
  }
}
