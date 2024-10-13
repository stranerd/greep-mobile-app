import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:greep/commons/extensions/string_extension.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/utils/constants/app_colors.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class AppPhoneNumber {
  final String code;
  final String number;

  AppPhoneNumber({required this.code, required this.number});


  String get fullNumber{
    return "$code$number";
  }

  Map<String, dynamic> toMap() {
    return {
      'code': this.code,
      'number': this.number,
    };
  }

  factory AppPhoneNumber.fromMap(Map<String, dynamic> map) {
    return AppPhoneNumber(
      code: map['code'] ?? "",
      number: map['number'] ?? "",
    );
  }
}

class CustomPhoneField extends StatelessWidget {
  final String initialCountry;
  final Function(AppPhoneNumber) onChanged;
  final String initialValue;
  const CustomPhoneField({Key? key, required this.initialCountry, required this.onChanged, required this.initialValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  IntlPhoneField(
      disableLengthCheck: false,
      initialCountryCode: initialCountry,
      validator: (value) {
        print("number: ${value!.number}");
        var isTenWithoutZero = ((value.number.startsWith("0") &&
            value.number.length == 11) || ((!value.number.startsWith("0") &&
            value.number.length == 10)));
        var isNotNumeric = GetUtils.isNumericOnly(
            value.number.trim());

        print("ten: $isTenWithoutZero , number: $isNotNumeric , ");
        if (value!.completeNumber.isEmpty) {
          return 'This field is required';
        } else if (!isTenWithoutZero ||
            !isNotNumeric) {
          return 'Please enter a valid phone number';
        }
        return null;
      },

      style: kDefaultTextStyle.copyWith(
        fontSize: 16.sp,
      ),
      initialValue: initialValue,
      // inputFormatters: [LengthLimitingTextInputFormatter(11)],
      autovalidateMode:
      AutovalidateMode.onUserInteraction,
      dropdownIconPosition: IconPosition.trailing,
      dropdownTextStyle: kDefaultTextStyle.copyWith(
        color: AppColors.black,
        fontSize: 16.sp,
      ),
      dropdownIcon: Icon(
        Icons.keyboard_arrow_down_outlined,
        color: AppColors.gray2,
        size: 15.r,
      ),
      flagsButtonPadding: EdgeInsets.only(
        left: 14.w,
      ),
      decoration: InputDecoration(
        // alignLabelWithHint: true,
        floatingLabelBehavior:
        FloatingLabelBehavior.never,
        hintStyle: kDefaultTextStyle.copyWith(
          fontSize: 14.sp,
          color: AppColors.veryLightGray,
        ),

        labelStyle: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(
          color: const Color(
            0xff868484,
          ),
          fontSize: 16.sp,
        ),
        labelText: 'Phone number',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              12.r,
            ),
          ),
          borderSide: BorderSide(
            color: AppColors.gray2,
            width: 2.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              12.r,
            ),
          ),
          borderSide: BorderSide(
            color: AppColors.gray2,
            width: 2.w,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              12.r,
            ),
          ),
          borderSide: BorderSide(
            color: AppColors.gray2,
            width: 2.w,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              12.r,
            ),
          ),
          borderSide: BorderSide(
            color: AppColors.gray2,
            width: 2.w,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              12.r,
            ),
          ),
          borderSide: BorderSide(
            color: AppColors.gray2,
            width: 2.w,
          ),
        ),
        fillColor: AppColors.white,
        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.all(
          15.r,
        ),
      ),
      // initialCountryCode: initialCountry,
      onChanged: (phone) {
        String phoneNumber = phone.number.removeLeadingZero();
        onChanged(AppPhoneNumber(code: phone.countryCode, number: phoneNumber));

      },
    );
  }
}
