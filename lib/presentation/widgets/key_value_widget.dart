import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class KeyValueWidget extends StatelessWidget {
  final String title;
  final String value;
  final Widget? widgetValue;
  final double? fontSize;
  final Color? titleColor;
  const KeyValueWidget({Key? key, required this.title, required this.value, this.widgetValue,

    this.fontSize,
    this.titleColor

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
          title,
          color: titleColor,
          fontSize: fontSize,
        ),
         widgetValue??
            TextWidget(
          value,
          fontSize: fontSize,
              weight: FontWeight.w500,
              selectable: true,


        )
      ],
    );

  }
}
