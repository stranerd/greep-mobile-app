import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:greep/Commons/colors.dart';
import 'package:greep/application/auth/email_verification/email_verification_cubit.dart';
import 'package:greep/application/auth/password/request/confirm_reset_pin_request.dart';
import 'package:greep/application/auth/password/reset_password_cubit.dart';
import 'package:greep/application/user/user_util.dart';
import 'package:greep/commons/Utils/utils.dart';
import 'package:greep/commons/Utils/validators.dart';
import 'package:greep/commons/scaffold_messenger_service.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/ioc.dart';
import 'package:greep/presentation/widgets/app_dialog.dart';
import 'package:greep/presentation/widgets/in_app_notification_widget.dart';
import 'package:greep/presentation/widgets/input_text_field.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ResetTransactionPINSheet extends StatefulWidget {
  const ResetTransactionPINSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<ResetTransactionPINSheet> createState() =>
      _ResetTransactionPINSheetState();
}

class _ResetTransactionPINSheetState extends State<ResetTransactionPINSheet>
    with ScaffoldMessengerService {
  bool isError = false;
  bool isLoading = false;
  String? errorMessage;

  var RESENDINTERVAL = 60;
  String code = "";

  late Timer _timer;
  int _start = 60;
  String pin = "";

  late PasswordCrudCubit passwordCrudCubit;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 1) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  TextEditingController pinEditingController = TextEditingController();

  @override
  void initState() {
    passwordCrudCubit = getIt()..sendPINResetCode();
    startTimer();

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    pinEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: passwordCrudCubit,
      child: BlocConsumer<PasswordCrudCubit, PasswordCrudState>(
        listener: (context, state) {
          if (state is PasswordCrudStateCodeSent) {
            showInAppNotification(context, title: "Reset PIN", body: "Code sent to email");

            _timer.cancel();
            startTimer();
          }

          if (state is PasswordCrudStateError) {
            showInAppNotification(context, title: "Reset PIN", body:  state.errorMessage.toLowerCase().contains("invalid")
                ? "Incorrect code"
                : state.errorMessage,isSuccess: false);

          }

          if (state is PasswordCrudStateSuccess) {
            Get.back();

            showInAppNotification(context, title: "Reset PIN", body: "Reset PIN successful");
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(

              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: AppDialog(
              title: "Forgot PIN",
              child: Container(
                padding: EdgeInsets.all(kDefaultSpacing),
                decoration: const BoxDecoration(
                  color: kWhiteColor,
                ),
                // height: Get.height,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      "Code has been sent to ${Utils.obscureContact(getUser().email)}",
                      color: AppColors.veryLightGray,
                    ),
                    SizedBox(height: 30.h,),
                    TextWidget("Verification code"),
                    SizedBox(height: 8.h,),
                    LayoutBuilder(builder: (context, constr) {
                      return PinCodeTextField(
                        controller: pinEditingController,
                        onChanged: (String value) {
                          setState(() {
                            code = value;
                          });
                          if (value.length < 6) {
                            setState(() {
                              isError = false;
                            });
                          }
                        },
                        length: 6,
                        textStyle: kDefaultTextStyle.copyWith(
                            fontWeight: FontWeight.bold),
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderWidth: 0.5,
                          borderRadius: BorderRadius.circular(
                            kDefaultSpacing * 0.5,
                          ),
                          fieldHeight: 50.r,
                          fieldWidth: 50.r,
                          inactiveColor: AppColors.veryLightGray,
                          // selectedColor: kGreenColor,
                          activeColor: AppColors.black,
                        ),
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        onCompleted: (str) async {
                          print(str);
                          // passwordCrudCubit.confirmVerificationCode( token: str.trim());
                        },
                        appContext: context,
                      );
                    }),
                    SizedBox(height: 16.h,),
                    InputTextField(
                      validator: requiredValidator,
                      isPassword: true,
                      inputType: TextInputType.number,
                      onChanged: (s) {
                        setState(() {
                          pin = s;
                        });
                      },
                      maxTextLength: 4,
                      title: "New PIN",
                      hintText: "****",
                    ),
                    SizedBox(height: 20.h,),
                    Align(
                      alignment: Alignment.center,
                      child: _timer.isActive
                          ? RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Resend code in ",
                              style: kDefaultTextStyle),
                          TextSpan(
                              text: " ${_start.toString()}",
                              style: kBoldTextStyle)
                        ]),
                      )
                          : Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Didn't received code? ",
                              style: kDefaultTextStyle.copyWith(
                                fontSize: 14.sp,

                              ),
                            ),
                            TextSpan(
                              text: "Resend",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _start = RESENDINTERVAL;
                                  pinEditingController.clear();
                                  passwordCrudCubit.sendPINResetCode();
                                },
                              style: kBoldTextStyle.copyWith(
                                color: AppColors.blue,
                                fontSize: 14.sp,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h,),
                    SubmitButton(
                      text: "Confirm",
                      textStyle: kBoldWhiteTextStyle,
                      isLoading: state is PasswordCrudStateLoading,
                      enabled: (state is! PasswordCrudStateLoading) &&
                          (code.length == 6) && pin.length == 4,
                      onSubmit: () {
                        passwordCrudCubit.confirmResetPIN(
                          ConfirmResetPINRequest(token: code, pin: pin),
                        );
                      },
                      backgroundColor: AppColors.green,
                      borderRadius: kDefaultSpacing * 0.5,
                    ),
                    SizedBox(height: 16.h,),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
