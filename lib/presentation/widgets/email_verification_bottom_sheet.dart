import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:greep/application/auth/email_verification/email_verification_cubit.dart';
import 'package:greep/application/user/user_util.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/scaffold_messenger_service.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/ioc.dart';
import 'package:greep/presentation/driver_section/home_page.dart';
import 'package:greep/presentation/driver_section/nav_pages/nav_bar/nav_bar_view.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EmailVerificationBottomSheet extends StatefulWidget {

  const EmailVerificationBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<EmailVerificationBottomSheet> createState() =>
      _EmailVerificationBottomSheetState();
}

class _EmailVerificationBottomSheetState
    extends State<EmailVerificationBottomSheet>
    with ScaffoldMessengerService {
  bool isError = false;
  bool isLoading = false;
  String? errorMessage;

  late EmailVerificationCubit emailVerificationCubit;
  var RESENDINTERVAL = 60;
  String pin = "";

  late Timer _timer;
  int _start = 60;

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
    emailVerificationCubit = getIt()
      ..sendVerificationCode(getUser().email);
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
      value: emailVerificationCubit,

      child: BlocConsumer<EmailVerificationCubit, EmailVerificationState>(
        listener: (context, state) {
          if (state is EmailVerificationCodeSent){
            success = "Email verification code sent";
            _timer.cancel();
            startTimer();

          }

          if (state is EmailVerificationStateError){
            error = state.errorMessage;

          }

          if (state is EmailVerificationSuccess){
            success = "Email verification successful";
            Get.offAll(const NavBarView());
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Container(
              padding: EdgeInsets.all(kDefaultSpacing),
              decoration: const BoxDecoration(
                color: kWhiteColor,
              ),
              height: Get.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  kVerticalSpaceLarge,
                  Center(
                      child: Image.asset(
                        "assets/images/email_verification.png",
                        width: 250.w,
                        height: 250.h,
                      )),
                  kVerticalSpaceLarge,
                  kVerticalSpaceLarge,
                  Container(
                    width: Get.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextWidget(
                          "Verify your email",
                          weight: FontWeight.bold,
                        ),
                        kVerticalSpaceMedium,
                        TextWidget(
                          "Please enter the 4 digit code sent to",
                          style: kDefaultTextStyle,
                        ),
                        kVerticalSpaceSmall,
                        TextWidget(
                          getUser().email,
                          color: kGreenColor,
                          style: kDefaultTextStyle,
                        ),
                      ],
                    ),
                  ),
                  kVerticalSpaceLarge,
                  LayoutBuilder(builder: (context, constr) {
                    return PinCodeTextField(
                      controller: pinEditingController,
                      onChanged: (String value) {
                        setState(() {
                          pin = value;

                        });
                        if (value.length < 6) {
                          setState(() {
                            isError = false;
                          });
                        }
                      },
                      length: 6,
                      textStyle:
                      kPrimaryTextStyle.copyWith(fontWeight: FontWeight.bold),
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderWidth: 0.5,
                        borderRadius: BorderRadius.circular(
                          kDefaultSpacing * 0.5,
                        ),
                        fieldHeight: 70.h,
                        fieldWidth: 55.w,
                        inactiveColor: kGreenColor,
                        // selectedColor: kGreenColor,
                        activeColor: kPrimaryColor,
                      ),
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      onCompleted: (str) async {
                        emailVerificationCubit.confirmVerificationCode( token: str.trim());
                      },
                      appContext: context,
                    );
                  }),
                  kVerticalSpaceRegular,
                  Align(
                    alignment: Alignment.center,
                    child:  _timer.isActive
                        ? RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Resend code in ",
                            style: kDefaultTextStyle),
                        TextSpan(
                            text: " ${_start.toString()}",
                            style: kBoldTextStyle)
                      ]),
                    ) : Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Didn't received code? ",
                            style: kDefaultTextStyle.copyWith(
                              fontSize: kDefaultSpacing.sp,
                            ),
                          ),
                          TextSpan(
                            text: "Resend",
                            recognizer: TapGestureRecognizer()..onTap = () {
                              _start = RESENDINTERVAL;
                              pinEditingController.clear();
                              emailVerificationCubit.sendVerificationCode(getUser().email);

                            },
                            style: kBoldTextStyle.copyWith(
                              color: AppColors.green,
                              fontSize: kDefaultSpacing.sp,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  kVerticalSpaceRegular,
                  SubmitButton(
                    text: "Confirm",
                    textStyle: kBoldWhiteTextStyle,
                    isLoading: state is EmailVerificationStateLoading,
                    enabled: (state is! EmailVerificationStateLoading) && (pin.length ==6),
                    onSubmit: () {
                      emailVerificationCubit.confirmVerificationCode(token: pin);
                    },
                    backgroundColor: AppColors.green,
                    borderRadius: kDefaultSpacing * 0.5,
                  ),
                  kVerticalSpaceRegular,

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
