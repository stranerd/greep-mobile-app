import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/widgets/text_widget.dart';

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

  const SubmitButton(
      {Key? key,
      this.isLoading = false,
        this.borderRadius = kDefaultSpacing * 0.3,
      required this.text,
      this.fontSize = 22,
        this.padding = kDefaultSpacing,
      required this.onSubmit,
        this.backgroundColor,
        this.textStyle,
      this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bgcolor = backgroundColor!=null? backgroundColor! : kPrimaryColor;
    return LayoutBuilder(
      builder: (context, constraints) => GestureDetector(
        onTap: enabled ? onSubmit : null,
        child: Container(
          width: constraints.maxWidth,
          padding: EdgeInsets.all(padding.r),
          decoration: BoxDecoration(
            borderRadius:  BorderRadius.all(Radius.circular(borderRadius.r)),
            color: enabled ? bgcolor : bgcolor.withOpacity(0.3),
          ),
          child: Center(
            child: !isLoading
                ? FittedBox(
                    child: TextWidget(
                      text,
                      style: textStyle!=null? textStyle! :kWhiteTextStyle,
                    ),
                  )
                : const CircularProgressIndicator(
                    color: kWhiteColor,
                  ),
          ),
        ),
      ),
    );
  }
}
