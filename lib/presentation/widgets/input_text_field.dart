import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class InputTextField extends StatefulWidget {
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
  final bool isSearch;
  final Widget? suffix;
  final String? prefixIcon;
  final String? initialValue;
  final double? prefixSize;
  final double? suffixSize;

  final String? suffixIcon;

  const InputTextField({
    Key? key,
    this.title = "",
    required this.validator,
    this.isPassword = false,
    this.inputType,
    this.withTitle = true,
    this.minLines,
    this.textStyle,
    this.suffixIcon,
    this.suffixSize,
    this.enabled = true,
    this.hintText,
    this.withBorder = true,
    this.customController,
    required this.onChanged,
    this.isSearch = false,
    this.suffix,
    this.prefixIcon,
    this.initialValue,
    this.prefixSize,
  }) : super(key: key);

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
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
                SizedBox(height: 8.h,),
              ],
            ),
          TextFormField(
            onChanged: widget.onChanged,
            minLines: widget.minLines ?? 1,
            maxLines: widget.minLines ?? 1,

            keyboardType: widget.inputType,
            controller: widget.customController ??
                (widget.initialValue == null ? editingController : null),
            cursorColor: kPrimaryColor,
            enabled: widget.enabled,
            style:
                widget.textStyle ?? kDefaultTextStyle.copyWith(fontSize: 14.sp),
            // style: Theme.of(context).textTheme.bodyText1,
            obscureText: widget.isPassword && isObscure,
            decoration: InputDecoration(
                hintStyle: kSubtitleTextStyle.copyWith(fontSize: 14.sp),
                suffixIcon: widget.suffixIcon != null
                    ? Padding(
                  padding: EdgeInsets.only(
                      right: 16.0.w, ),
                  child: SvgPicture.asset(
                    widget.suffixIcon!,
                    width: widget.suffixSize ?? 15.r,
                    height: widget.suffixSize ?? 15.r,
                    fit: BoxFit.cover,
                  ),
                ): widget.isPassword
                    ? IconButton(
                        icon: Icon(
                            isObscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: kBlackColor),
                        onPressed: toggleObscurity,
                      )
                    : null,
                filled: widget.withBorder ? false : true,
                fillColor: kBorderColor,
                hintText: widget.hintText,
                suffixIconConstraints:
                    BoxConstraints(maxWidth: 40.r, maxHeight: 30.r),
                prefixIcon: widget.prefixIcon != null
                    ? Padding(
                        padding: EdgeInsets.only(
                            right: 8.0.w, bottom: 2.h, left: 12.w),
                        child: SvgPicture.asset(
                          widget.prefixIcon!,
                          width: widget.prefixSize ?? 15.r,
                          height: widget.prefixSize ?? 15.r,
                        ),
                      )
                    : widget.isSearch
                        ? Padding(
                            padding: EdgeInsets.only(
                                right: 8.0.w,
                                bottom: 2.h,
                                left: kDefaultSpacing.w),
                            child: SvgPicture.asset(
                              "assets/icons/search.svg",
                              width: 24.r,
                              height: 24.r,
                              color: AppColors.veryLightGray,
                            ),
                          )
                        : null,
                prefixIconConstraints: BoxConstraints(
                  minWidth: 30.r,
                  minHeight: 30.r,
                ),
                suffix: widget.suffix,

                focusedBorder: !widget.withBorder
                    ? InputBorder.none
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          12.r,
                        ),
                        borderSide: const BorderSide(
                            color: Color(0xFFE0E2E4), width: 2),
                      ),
                // isDense: true,
                border: !widget.withBorder
                    ? InputBorder.none
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          12.r,
                        ),
                        borderSide: const BorderSide(
                            color: Color(0xFFE0E2E4), width: 2),
                      ),
                contentPadding: EdgeInsets.only(
                    top: 12.h, bottom: 5.h, right: 16.w, left: 16.w),
                enabledBorder: !widget.withBorder
                    ? InputBorder.none
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          12.r,
                        ),
                        borderSide: const BorderSide(
                            color: Color(0xFFE0E2E4), width: 2),
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
