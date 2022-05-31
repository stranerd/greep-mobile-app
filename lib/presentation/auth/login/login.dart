import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grip/commons/Utils/input_validator.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/presentation/driver_section/home_page.dart';
import 'package:grip/presentation/widgets/input_text_field.dart';
import 'package:grip/presentation/widgets/submit_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with InputValidator {
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        leadingWidth: 30,
        toolbarHeight: 30,
      ),
      body: Container(
        padding: EdgeInsets.all(kDefaultSpacing),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    "Welcome Back",
                    style: kDefaultTextStyle.copyWith(fontSize: 25),
                  ),
                  kVerticalSpaceSmall,
                  Text(
                    "Enter your email to sign in your account ",
                    style: kDefaultTextStyle,
                  ),
                ],
              ),
              Column(
                children: [
                  LoginTextField(
                    title: "Email",
                    validator: validateEmail,
                    isPassword: false,
                    onChanged: (String value) {
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                  kVerticalSpaceRegular,
                  LoginTextField(
                    title: "Password",
                    validator: emptyFieldValidator,
                    isPassword: true,
                    onChanged: (String value) {
                      setState(() {
                        password = value;
                      });
                    },
                  ),
                  kVerticalSpaceSmall,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        // Get.to(() => const ForgotPasswordScreen());
                      },
                      child: Text(
                        "Forgot Password?",
                        style: kDefaultTextStyle,
                      ),
                      style: TextButton.styleFrom(
                        textStyle: kDefaultTextStyle.copyWith(
                            decoration: TextDecoration.underline),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                      ),
                    ),
                  )
                ],
              ),
              SubmitButton(text: "Login", onSubmit: () {
                Get.to(() => DriverHomePage());
              }),
              kVerticalSpaceRegular,
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    // Get.to(() => const ForgotPasswordScreen());
                  },
                  child: Text(
                    "Forgot Password?",
                    style: kDefaultTextStyle,
                  ),
                  style: TextButton.styleFrom(
                    textStyle: kDefaultTextStyle.copyWith(
                        decoration: TextDecoration.underline),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                  ),
                ),
              ),
              kVerticalSpaceRegular,

            ],
          ),
        ),
      ),
    );
  }
}
