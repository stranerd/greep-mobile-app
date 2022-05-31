import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/ui_helpers.dart';

class SubmitButton extends StatelessWidget {
  final String text;
  final VoidCallback onSubmit;
  final bool enabled;
  final bool isLoading;
  final double borderRadius;
  final double fontSize;
  final TextStyle? textStyle;
  final Color? backgroundColor;

  const SubmitButton(
      {Key? key,
      this.isLoading = false,
        this.borderRadius = kDefaultSpacing * 0.3,
      required this.text,
      this.fontSize = 22,
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
          padding: const EdgeInsets.all(kDefaultSpacing),
          decoration: BoxDecoration(
            borderRadius:  BorderRadius.all(Radius.circular(borderRadius)),
            color: enabled ? bgcolor : bgcolor.withOpacity(0.3),
          ),
          child: Center(
            child: !isLoading
                ? FittedBox(
                    child: Text(
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
