import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/auth/AuthenticationCubit.dart';
import 'package:grip/application/auth/AuthenticationState.dart';
import 'package:grip/application/auth/SignupCubit.dart';
import 'package:grip/application/auth/SignupState.dart';
import 'package:grip/application/auth/request/LoginRequest.dart';
import 'package:grip/commons/Utils/input_validator.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/scaffold_messenger_service.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/presentation/auth/forgot_password/forgot_password.dart';
import 'package:grip/presentation/auth_finish_signup.dart';
import 'package:grip/presentation/driver_section/home_page.dart';
import 'package:grip/presentation/splash/authentication_splash.dart';
import 'package:grip/presentation/widgets/input_text_field.dart';
import 'package:grip/presentation/widgets/social_signin_widget.dart';
import 'package:grip/presentation/widgets/submit_button.dart';

class AuthHomeScreen extends StatefulWidget {
  const AuthHomeScreen({Key? key}) : super(key: key);

  @override
  _AuthHomeScreenState createState() => _AuthHomeScreenState();
}

class _AuthHomeScreenState extends State<AuthHomeScreen>
    with InputValidator, ScaffoldMessengerService {
  String email = "";
  String password = "";
  String confirmPassword = "";
  final formKey = GlobalKey<FormState>();
  Map<String,dynamic> fieldErrors = {};

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
    setState(() {
    });
    if (formKey.currentState!.validate()) {
      BlocProvider.of<AuthenticationCubit>(context)
          .login(LoginRequest(email: email.trim(), password: password));
    }
  }

  void _signup() {
    fieldErrors = {};
    setState(() {
    });
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
          Get.offAll(() => const AuthenticationSplashScreen());
        }
        if (state is AuthenticationStateError) {
          error = state.errorMessage;
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
                            validator: (String s){
                              if (s.length < 8){
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
                                  if (s.length < 8){
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
                              padding: const EdgeInsets.all(kDefaultSpacing * 0.5),
                              decoration: BoxDecoration(
                                color: kErrorColor.withOpacity(0.1),
                                border: Border.all(color: kErrorColor)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: fieldErrors.keys.map((e) {
                                  return Wrap(
                                    children: [
                                      Text("* $e: ${fieldErrors[e]}"

                                        ,style: kErrorColorTextStyle,)
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
                                  text:  "Login",
                                  backgroundColor: kGreenColor,
                                  onSubmit: _login, )
                              : BlocConsumer<SignupCubit, SignupState>(
                                  listener: (context, state) {
                                    if (state is SignupStateReady){
                                      Get.to(() =>  AuthFinishSignup(email: email,password: password,));

                                    }
                                    if (state is SignupStateError){
                                      setState(() {
                                        fieldErrors = state.fieldErrors;
                                      });
                                      error = state.errorMessage?? "Sign up failed";
                                    }

                                  },
                                  builder: (context, state) {
                                    return SubmitButton(
                                        isLoading:
                                            state is SignupStateLoading,
                                        enabled: state
                                            is! SignupStateLoading,
                                        text: "Create Account",
                                        backgroundColor: kGreenColor,
                                        onSubmit: _signup
                                        );
                                  },
                                ),
                          kVerticalSpaceRegular,
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () {
                                Get.to(() => const ForgotPasswordScreen());
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
                            onTap: () {
                              GetIt.I<AuthenticationCubit>().signinWithGoogle();
                            },
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
                                        text: isSignin
                                            ? ' Create account'
                                            : ' Log in',
                                        recognizer: _tapGestureRecognizer,
                                        style: kDefaultTextStyle.copyWith(
                                            decoration:
                                                TextDecoration.underline)),
                                  ],
                                ),
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.5)),
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
          ),
        );
      },
    );
  }
}
