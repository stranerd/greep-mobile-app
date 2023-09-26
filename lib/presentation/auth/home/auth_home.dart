import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as g;
import 'package:get_it/get_it.dart';
import 'package:greep/application/auth/AuthenticationCubit.dart';
import 'package:greep/application/auth/AuthenticationState.dart';
import 'package:greep/application/auth/SignupCubit.dart';
import 'package:greep/application/auth/SignupState.dart';
import 'package:greep/application/auth/request/LoginRequest.dart';
import 'package:greep/application/location/location_cubit.dart';
import 'package:greep/commons/Utils/input_validator.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/scaffold_messenger_service.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/auth/forgot_password/forgot_password.dart';
import 'package:greep/presentation/auth_finish_signup.dart';
import 'package:greep/presentation/driver_section/home_page.dart';
import 'package:greep/presentation/splash/authentication_splash.dart';
import 'package:greep/presentation/widgets/input_text_field.dart';
import 'package:greep/presentation/widgets/social_signin_widget.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class AuthHomeScreen extends StatefulWidget {
  const AuthHomeScreen({Key? key}) : super(key: key);

  @override
  _AuthHomeScreenState createState() => _AuthHomeScreenState();
}

class _AuthHomeScreenState extends State<AuthHomeScreen> with InputValidator {
  String email = "";
  String password = "";
  String confirmPassword = "";
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic> fieldErrors = {};

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

  void _login() {
    fieldErrors = {};
    setState(() {});
    if (formKey.currentState!.validate()) {
      BlocProvider.of<AuthenticationCubit>(context)
          .login(LoginRequest(email: email.trim(), password: password));
    }
  }

  void _signup() {
    fieldErrors = {};
    setState(() {});
    if (formKey.currentState!.validate()) {
      BlocProvider.of<SignupCubit>(context)
          .testSignup(LoginRequest(email: email.trim(), password: password));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationStateAuthenticated) {
          g.Get.offAll(
            () => AuthenticationSplashScreen(
              isNewUser: state.isSignup,
            ),
            transition: g.Transition.fadeIn,
          );
        }
        if (state is AuthenticationStateError) {
          Fluttertoast.showToast(
            msg: state.errorMessage,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(kDefaultSpacing),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      kVerticalSpaceRegular,
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextWidget(
                              isSignin ? "Welcome back!" : "Create an account",
                              fontFamily: "Poppins-Bold",
                              fontSize: 22.sp,
                            ),
                               TextWidget(
                                (isSignin) ? "Login to continue" : "Join the Greep Family",
                                color: AppColors.veryLightGray,
                              ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      SocialSigninWidget(
                        onTap: () {
                          GetIt.I<AuthenticationCubit>().signinWithGoogle();
                        },
                        text: "Continue with Google",
                        icon: "assets/icons/google-colored.svg",
                      ),
                      kVerticalSpaceRegular,
                      if (Platform.isIOS)
                        SocialSigninWidget(
                          onTap: () {
                            GetIt.I<AuthenticationCubit>().loginWithApple();
                          },
                          text: "Continue with Apple",
                          icon: "assets/icons/apple.png",
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
                            validator: (String s) {
                              if (s.length < 8) {
                                return "Password must contain atleast 8 characters";
                              }
                              return null;
                            },
                            isPassword: true,
                            onChanged: (String value) {
                              setState(() {
                                password = value;
                              });
                            },
                          ),
                          kVerticalSpaceRegular,
                          if (!isSignin)
                            LoginTextField(
                              title: "Confirm password",
                              validator: (String s) {
                                if (!isSignin) {
                                  if (s.length < 8) {
                                    return "Password must contain at least 8 characters";
                                  }
                                  if (s != password) {
                                    return "Passwords do not match";
                                  }
                                  return null;
                                }
                                return null;
                              },
                              isPassword: true,
                              onChanged: (String value) {
                                setState(() {
                                  confirmPassword = value;
                                });
                              },
                            ),
                        ],
                      ),
                      if (fieldErrors.isNotEmpty)
                        Column(
                          children: [
                            kVerticalSpaceRegular,
                            Container(
                              padding:
                                  const EdgeInsets.all(kDefaultSpacing * 0.5),
                              decoration: BoxDecoration(
                                  color: kErrorColor.withOpacity(0.1),
                                  border: Border.all(color: kErrorColor)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: fieldErrors.keys.map((e) {
                                  return Wrap(
                                    children: [
                                      Text(
                                        "* $e: ${fieldErrors[e]}",
                                        style: kErrorColorTextStyle,
                                      )
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      kVerticalSpaceRegular,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          isSignin
                              ? SubmitButton(
                                  isLoading:
                                      state is AuthenticationStateLoading,
                                  enabled: state is! AuthenticationStateLoading,
                                  text: "Login",
                                  textStyle: kDefaultTextStyle.copyWith(
                                      fontSize: 14.sp, color: Colors.white),
                                  backgroundColor: kBlackColor,
                                  onSubmit: _login,
                                )
                              : BlocConsumer<SignupCubit, SignupState>(
                                  listenWhen: (_, __) {
                                    return ModalRoute.of(context)?.isCurrent ??
                                        false;
                                  },
                                  listener: (context, state) {
                                    if (state is SignupStateReady) {
                                      g.Get.to(
                                          () => AuthFinishSignup(
                                                email: email,
                                                password: password,
                                              ),
                                          transition: g.Transition.fadeIn);
                                    }
                                    if (state is SignupStateError) {
                                      setState(() {
                                        fieldErrors = state.fieldErrors;
                                      });

                                      Fluttertoast.showToast(
                                          msg: state.errorMessage ??
                                              "Sign up failed");
                                    }
                                  },
                                  builder: (context, state) {
                                    return SubmitButton(
                                        isLoading: state is SignupStateLoading,
                                        enabled: state is! SignupStateLoading,
                                        text: "Create Account",
                                        textStyle: kDefaultTextStyle.copyWith(
                                            fontSize: 14.sp,
                                            color: Colors.white),
                                        backgroundColor: kBlackColor,
                                        onSubmit: _signup);
                                  },
                                ),
                          kVerticalSpaceRegular,
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () {
                                g.Get.to(() => const ForgotPasswordScreen(),
                                    transition: g.Transition.fadeIn);
                              },
                              style: TextButton.styleFrom(
                                textStyle: kDefaultTextStyle.copyWith(
                                    decoration: TextDecoration.underline),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                              ),
                              child: const TextWidget(
                                "Forgot Password?",
                                color: AppColors.blue,
                              ),
                            ),
                          ),
                          kVerticalSpaceRegular,
                          Align(
                            alignment: Alignment.center,
                            child: Text.rich(
                              TextSpan(
                                text: isSignin
                                    ? 'Don\'t have an account? '
                                    : 'Have an account? ',
                                style:
                                    kDefaultTextStyle.copyWith(fontSize: 14.sp),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: isSignin
                                          ? ' Create account'
                                          : ' Log in',
                                      recognizer: _tapGestureRecognizer,
                                      style: kDefaultTextStyle.copyWith(
                                          fontSize: 14.sp,
                                          color: AppColors.blue,
                                          decoration:
                                              TextDecoration.underline)),
                                ],
                              ),
                              style: kDefaultTextStyle.copyWith(
                                fontSize: 14.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
