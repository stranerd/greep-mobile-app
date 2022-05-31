import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grip/commons/Utils/input_validator.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/presentation/driver_section/home_page.dart';
import 'package:grip/presentation/widgets/input_text_field.dart';
import 'package:grip/presentation/widgets/social_signin_widget.dart';
import 'package:grip/presentation/widgets/submit_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with InputValidator {
  String email = "";
  String password = "";
  String confirmPassword = "";

  bool isSignin = true;

  late TapGestureRecognizer _tapGestureRecognizer;

  @override
  void initState() {
    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        setState(() {
          isSignin = !isSignin;
        });
      };

    super.initState();
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(kDefaultSpacing),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                kVerticalSpaceRegular,
                Text(
                  isSignin ? "Welcome back!" : "Create account",
                  style: const TextStyle(
                    fontFamily: "Poppins-Bold",
                    fontSize: 30,
                  ),
                ),
                kVerticalSpaceTiny,
                if (isSignin)
                  Text(
                    "Login to continue",
                    style: kDefaultTextStyle,
                  ),
                kVerticalSpaceLarge,
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
                    kVerticalSpaceRegular,
                   if(!isSignin) LoginTextField(
                      title: "Confirm password",
                      validator: emptyFieldValidator,
                      isPassword: true,
                      onChanged: (String value) {
                        setState(() {
                          confirmPassword = value;
                        });
                      },
                    ),
                  ],
                ),
                kVerticalSpaceRegular,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SubmitButton(
                        text: !isSignin ? "Create Account": "Login",
                        onSubmit: () {
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
                    SocialSigninWidget(
                      onTap: () {},
                      text: "Google",
                      icon: "assets/icons/google.png",
                    ),
                    kVerticalSpaceRegular,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: isSignin
                                ? 'Don\'t have an account? '
                                : 'Have an account? ',
                            style: kDefaultTextStyle,
                            children: <TextSpan>[
                              TextSpan(
                                  text: isSignin ? ' Create account' : ' Log in',
                                  recognizer: _tapGestureRecognizer,
                                  style: kDefaultTextStyle.copyWith(
                                      decoration: TextDecoration.underline)),
                            ],
                          ),
                          style: TextStyle(color: Colors.black.withOpacity(0.5)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
