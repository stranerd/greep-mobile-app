import 'package:flutter/material.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(this.text,{Key? key, this.color, this.weight, this.overflow,  this.style, this.fontSize, this.textAlign, this.letterSpacing}) : super(key: key);
  final Color? color;
  final String text;
  final TextStyle? style;
  final TextOverflow? overflow;
  final double? fontSize;
  final TextAlign? textAlign;
  final FontWeight? weight;
  final double? letterSpacing;


  @override
  Widget build(BuildContext context) {
    return Text(text, style: style == null ? kDefaultTextStyle.copyWith(
      color: color,
      fontSize: fontSize == null ? kDefaultSpacing : fontSize!.sp,
      fontWeight: weight,
      letterSpacing: letterSpacing

    ) : style!.copyWith(
      color: color,
      fontSize: style!.fontSize == null ? kDefaultSpacing : style!.fontSize!.sp,
      fontWeight: weight,
      letterSpacing: letterSpacing
    ),
    textAlign: textAlign,
      overflow: overflow,
    );
  }
}
