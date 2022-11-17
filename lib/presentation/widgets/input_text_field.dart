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

  const LoginTextField({
    Key? key,
    this.title = "",
    required this.validator,
    this.isPassword = false,
    this.inputType,
    this.withTitle = true,
    this.minLines,
    this.enabled = true,
    this.hintText,
    this.withBorder = false,
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
            // style: Theme.of(context).textTheme.bodyText1,
            obscureText: widget.isPassword && isObscure,
            decoration: InputDecoration(
              hintStyle: kSubtitleTextStyle.copyWith(
                fontSize: 17.sp
              ),
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                            isObscure ? Icons.visibility : Icons.visibility_off,
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
                        borderRadius: BorderRadius.circular((kDefaultSpacing * 0.75).r),
                        borderSide:
                             const BorderSide(color: kGreyColor2, width: 1),
                      ),
                border: !widget.withBorder
                    ? InputBorder.none
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(kDefaultSpacing* 0.75),
                        borderSide:
                             const BorderSide(color: kGreyColor2, width: 1),
                      ),
                enabledBorder: !widget.withBorder
                    ? InputBorder.none
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(kDefaultSpacing* 0.75),
                        borderSide:
                             const BorderSide(color: kGreyColor2, width: 1),
                      ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: kErrorColor, width: 0.5),
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
