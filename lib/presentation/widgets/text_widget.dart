import 'package:flutter/material.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(
    this.text, {
    Key? key,
    this.color,
    this.weight,
    this.overflow,
    this.style,
    this.fontSize,
    this.textAlign,
    this.letterSpacing,
    this.maxLines, this.softWrap,
  }) : super(key: key);
  final Color? color;
  final bool? softWrap;
  final String text;
  final TextStyle? style;
  final TextOverflow? overflow;
  final double? fontSize;
  final TextAlign? textAlign;
  final FontWeight? weight;
  final double? letterSpacing;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style == null
          ? kDefaultTextStyle.copyWith(
              color: color,
              fontWeight: weight,
              fontSize: fontSize?.sp,
              letterSpacing: letterSpacing)
          : style!.copyWith(
              color: color,
              fontSize: fontSize?.sp,
              fontWeight: weight,
              letterSpacing: letterSpacing),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
    );
  }
}
