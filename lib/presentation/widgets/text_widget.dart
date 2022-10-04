import 'package:flutter/material.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(this.text,{Key? key, this.color, this.overflow,  this.style, this.fontSize, this.textAlign}) : super(key: key);
  final Color? color;
  final String text;
  final TextStyle? style;
  final TextOverflow? overflow;
  final double? fontSize;
  final TextAlign? textAlign;


  @override
  Widget build(BuildContext context) {
    return Text(text, style: style == null ? kDefaultTextStyle.copyWith(
      color: color,
      fontSize: fontSize == null ? kDefaultSpacing.sp : fontSize!.sp,


    ) : style!.copyWith(
      color: color,
      fontSize: style!.fontSize == null ? kDefaultSpacing.sp : style!.fontSize!.sp
    ),
    textAlign: textAlign,
      overflow: overflow,
    );
  }
}
