import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grip/commons/Utils/input_validator.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/presentation/auth/forgot_password/change_forgot_password_success.dart';
import 'package:grip/presentation/widgets/input_text_field.dart';
import 'package:grip/presentation/widgets/submit_button.dart';

class ChangeForgotPasswordScreen extends StatefulWidget {
  const ChangeForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangeForgotPasswordScreen> createState() =>
      _ChangeForgotPasswordScreenState();
}

class _ChangeForgotPasswordScreenState extends State<ChangeForgotPasswordScreen>
    with InputValidator {
  String password = "";
  String confirmPassword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        leadingWidth: 30,
        toolbarHeight: 30,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(kDefaultSpacing),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Reset Password",
                    style: TextStyle(fontSize: 30,
                    fontFamily: "Poppins-Bold"),
                  ),
                  Text(
                    "Choose a new password",
                    style: kDefaultTextStyle,
                  ),
                  kVerticalSpaceLarge,
                  Column(children: [
                    LoginTextField(
                      title: "Enter password",
                      validator: emptyFieldValidator,
                      isPassword: true,
                      onChanged: (String value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                    kVerticalSpaceRegular,
                    LoginTextField(
                      title: "Confirm password",
                      validator: emptyFieldValidator,
                      isPassword: true,
                      onChanged: (String value) {
                        setState(() {
                          confirmPassword = value;
                        });
                      },
                    ),
                  ]),
                  kVerticalSpaceLarge,

                  SubmitButton(
                      text: "Continue",
                      onSubmit: () {
                        Get.offAll(() => const ChangeForgotPasswordSuccess());
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
