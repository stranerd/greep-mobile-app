import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/widgets/text_widget.dart';

class LoginTextField extends StatefulWidget {
  final String title;
  final bool isPassword;
  final Function(String) validator;
  final Function(String) onChanged;
  final bool withTitle;
  final int? minLines;
  final TextInputType? inputType;
  final TextEditingController? customController;
  final bool withBorder;
  final String? hintText;
  final bool enabled;
  final TextStyle? textStyle;

  const LoginTextField({
    Key? key,
    this.title = "",
    required this.validator,
    this.isPassword = false,
    this.inputType,
    this.withTitle = true,
    this.minLines,
    this.textStyle,
    this.enabled = true,
    this.hintText,
    this.withBorder = true,
    this.customController,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  late TextEditingController editingController;
  bool isObscure = true;

  @override
  void initState() {
    editingController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.withTitle)
            Column(
              children: [
                TextWidget(
                  widget.title,
                ),
                kVerticalSpaceTiny,
              ],
            ),
          TextFormField(
            onChanged: widget.onChanged,
            minLines: widget.minLines ?? 1,
            maxLines: widget.minLines ?? 1,

            keyboardType: widget.inputType,
            controller: widget.customController ?? editingController,
            cursorColor: kPrimaryColor,
            enabled: widget.enabled,
            style: widget.textStyle ?? kDefaultTextStyle.copyWith(
              fontSize: 14.sp
            ),
            // style: Theme.of(context).textTheme.bodyText1,
            obscureText: widget.isPassword && isObscure,
            decoration: InputDecoration(
              hintStyle: kSubtitleTextStyle.copyWith(
                fontSize: 14.sp
              ),
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                            isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: kBlackColor),
                        onPressed: toggleObscurity,
                      )
                    : null,
                filled: widget.withBorder ? false : true,
                fillColor: kBorderColor,
                hintText: widget.hintText,
                focusedBorder: !widget.withBorder
                    ? InputBorder.none
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r,),
                        borderSide:
                             const BorderSide(color: Color(0xFFE0E2E4), width: 2),
                      ),
                // isDense: true,
                border: !widget.withBorder
                    ? InputBorder.none
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r,),
                        borderSide:
                             const BorderSide(color: Color(0xFFE0E2E4), width: 2),
                      ),
                contentPadding: EdgeInsets.only(
                  top: 5.h,bottom: 5.h,right: 16.w,left: 16.w
                ),
                enabledBorder: !widget.withBorder
                    ? InputBorder.none
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r,),
                        borderSide:
                             const BorderSide(color: Color(0xFFE0E2E4), width: 2),
                      ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: kErrorColor, width: 2),
                )),
            validator: (val) => widget.validator(val!),
          )
        ],
      ),
    );
  }

  void toggleObscurity() {
    setState(() {
      isObscure = !isObscure;
    });
  }
}
