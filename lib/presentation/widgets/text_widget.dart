import 'package:flutter/material.dart';
import 'package:greep/Commons/colors.dart';
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
        this.fontStyle,
        this.decoration,
    this.fontSize,
        this.selectable = false,
        this.fontFamily,
    this.textAlign,
    this.letterSpacing,
    this.maxLines, this.softWrap,
  }) : super(key: key);
  final Color? color;
  final bool? softWrap;
  final String text;
  final TextStyle? style;
  final TextOverflow? overflow;
  final bool selectable;
  final double? fontSize;
  final TextAlign? textAlign;
  final String? fontFamily;
  final FontWeight? weight;
  final double? letterSpacing;
  final FontStyle? fontStyle;
  final int? maxLines;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    var textStyle = style == null
          ? kDefaultTextStyle.copyWith(
              color: color ?? kBlackColor,
              fontFamily: fontFamily,
          fontStyle: fontStyle,
              decoration: decoration,

              fontWeight: weight,
              fontSize: fontSize ?? 14.sp,
              letterSpacing: letterSpacing)
          : style!.copyWith(
              fontSize: fontSize ?? 14.sp,
              fontFamily: fontFamily,
          decoration: decoration,
              fontWeight: weight,
              fontStyle: fontStyle,
              letterSpacing: letterSpacing);
      if (selectable) {
        return SelectableText(
          text,
          style: textStyle,
          textAlign: textAlign,
          maxLines: maxLines,
        );
    }
    return Text(
      text,
      style: textStyle,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
    );
  }
}
