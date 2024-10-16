import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/application/auth/email_verification/email_verification_cubit.dart';
import 'package:greep/commons/Utils/utils.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/ioc.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/in_app_notification_widget.dart';
import 'package:greep/presentation/widgets/number_dialer.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

enum VerificationMode {
  signup,
  password,
}

class CodeVerificationBottomSheet extends StatefulWidget {
  final Function(String code) onCompleted;
  final Function onResendCode;
  final String email;
  final VerificationMode verificationMode;

  const CodeVerificationBottomSheet({
    Key? key,
    required this.onCompleted,
    required this.onResendCode,
    required this.email,
    required this.verificationMode,
  }) : super(key: key);

  @override
  State<CodeVerificationBottomSheet> createState() =>
      _CodeVerificationBottomSheetState();
}

class _CodeVerificationBottomSheetState
    extends State<CodeVerificationBottomSheet> {
  bool isError = false;
  bool isLoading = false;
  String? errorMessage;
  late EmailVerificationCubit emailVerificationCubit;
  // late PasswordCrudCubit passwordCrudCubit;

  bool shouldResendCode = false;
  TextEditingController codeController = TextEditingController();
  CountdownController countdownController = CountdownController();

  @override
  void initState() {
    super.initState();
    // passwordCrudCubit = getIt();
    emailVerificationCubit = getIt();
    if (widget.verificationMode == VerificationMode.signup) {
      emailVerificationCubit.sendVerificationCode(widget.email);
    } else if (widget.verificationMode == VerificationMode.password) {
      // passwordCrudCubit.
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      countdownController.start();



    });
  }

  @override
  void dispose() {
    super.dispose();
    codeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: emailVerificationCubit,
        ),

      ],
      child: BlocConsumer<EmailVerificationCubit, EmailVerificationState>(
        listener: (context, state) {},
        builder: (context, emailState) {
          return Container(
            decoration: const BoxDecoration(
              color: kWhiteColor,
            ),
            height: Get.height,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: BackIcon(
                        isArrow: true,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Center(
                      child: Column(
                        children: [
                          TextWidget(
                            "Verification Code",
                            fontSize: 22.sp,
                            weight: FontWeight.bold,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          TextWidget(
                            "Code has been sent to ${Utils.obscureContact(widget.email)}",
                            color: AppColors.veryLightGray,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    PinCodeTextField(
                      onChanged: (String value) {
                        if (value.length < 6) {
                          setState(() {
                            isError = false;
                          });
                        }
                      },
                      readOnly: true,
                      length: 6,
                      textStyle: kPrimaryTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 28.sp,
                      ),
                      controller: codeController,
                      pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(
                            12.r,
                          ),
                          fieldHeight: 50.r,
                          fieldWidth: 50.r,
                          // inactiveFillColor: AppColors.black,
                          inactiveColor: AppColors.gray2,
                          activeColor: AppColors.gray2,
                          selectedColor: AppColors.black),
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      onCompleted: (str) async {},
                      appContext: context,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Center(
                      child: Countdown(
                        controller: countdownController,
                        seconds: 120,

                        build: (BuildContext context, double time) =>
                            TextWidget(
                              formatDuration(
                                time.toInt(),
                              ),
                              fontSize: 18.sp,
                              weight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                        onFinished: () {
                          setState(() {
                            shouldResendCode = true;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 33.h,
                    ),
                    Center(
                      child: Text.rich(TextSpan(children: [
                        TextSpan(
                            text: "Didn't receive the code? ",
                            style: kDefaultTextStyle.copyWith(
                                fontSize: 14.sp)),
                        TextSpan(
                            text: "Resend",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                              widget.onResendCode();
                              },
                            style: kDefaultTextStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                color: shouldResendCode
                                    ? AppColors.blue
                                    : AppColors.veryLightGray,
                                fontSize: 14.sp))
                      ])),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    NumberDialer(
                      onClear: () {
                        if (codeController.text.isNotEmpty) {
                          codeController.text =
                          "${codeController.text.substring(0, codeController.text.length - 1)}";
                          setState(() {});
                        }
                      },
                      onSelect: (a) {
                        print("on select $a");
                        if (codeController.text.length < 6) {
                          codeController.text = "${codeController.text}$a";
                          setState(() {});
                        }
                      },
                      onValue: (s) {},
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    SubmitButton(
                      text: "Next",
                      isLoading: isLoading || emailState is EmailVerificationStateLoading ,
                      enabled: codeController.text.length == 6 && !isLoading,
                      onSubmit: () async {
                        setState(() {
                          isLoading = true;
                        });
                        String? message =
                        await widget.onCompleted(codeController.text);
                        setState(() {
                          isLoading = false;
                        });
                        if (message != null) {
                          setState(() {
                            isError = true;
                            errorMessage = message;
                          });
                          showInAppNotification(context,
                              title: "Verification Code", body: message,isSuccess: false,);
                        } else {
                          Get.back(result: true);
                        }
                      },
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      )


    );
  }

  String formatDuration(int seconds) {
    Duration duration = Duration(seconds: seconds);
    int minutes = duration.inMinutes;
    int remainingSeconds = duration.inSeconds % 60;

    String formattedDuration =
        '${minutes.toString().padLeft(1, '0')}:${remainingSeconds.toString().padLeft(2, '0')}s';

    return formattedDuration;
  }
}
