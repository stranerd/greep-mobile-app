import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class SubmitButton extends StatelessWidget {
  final String text;
  final VoidCallback onSubmit;
  final bool enabled;
  final bool isLoading;
  final double borderRadius;
  final double padding;
  final double fontSize;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final double? height;
  final double widthRatio;
  final double? width;

  final bool isBorder;
  final Color? borderColor;
  const SubmitButton(
      {Key? key,
      this.isLoading = false,
        this.borderRadius = 12,
      required this.text,
      this.fontSize = 22,
        this.isBorder = false,
        this.borderColor,
        this.padding = 12,
      required this.onSubmit,
        this.width,
        this.backgroundColor,
        this.textStyle,
      this.enabled = true, this.height,  this.widthRatio = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bgcolor = backgroundColor!=null? backgroundColor! : kPrimaryColor;
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: enabled ? onSubmit : null,
          child: Container(
            width: width ?? constraints.maxWidth * widthRatio,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: padding.r),
            decoration: BoxDecoration(
              borderRadius:  BorderRadius.all(Radius.circular(borderRadius.r)),
              color: enabled ? bgcolor : bgcolor.withOpacity(0.3),
              border: isBorder
                  ? Border.all(
                width: 1.w,
                color: borderColor ?? AppColors.gray2,
              )
                  : null,
            ),
            child: Center(
              child: !isLoading
                  ? FittedBox(
                      child: TextWidget(
                        text,
                        style: textStyle!=null? textStyle! :kWhiteTextStyle,
                      ),
                    )
                  :  SizedBox(
                height: 20.r,width: 20.r,
                    child: CircularProgressIndicator(
                        color: kWhiteColor,
                      ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
