import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:greep/application/auth/password/reset_password_cubit.dart';
import 'package:greep/commons/Utils/input_validator.dart';
import 'package:greep/commons/scaffold_messenger_service.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/auth/forgot_password/change_forgot_password.dart';
import 'package:greep/presentation/widgets/code_verification_bottom_sheet.dart';
import 'package:greep/presentation/widgets/input_text_field.dart';
import 'package:greep/presentation/widgets/submit_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with InputValidator, ScaffoldMessengerService {
  String email = "";
  String code = "";
  final formKey = GlobalKey<FormState>();
  late ResetPasswordCubit _resetPasswordCubit;

  @override
  void initState() {
    _resetPasswordCubit = GetIt.I<ResetPasswordCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _resetPasswordCubit,
      child: Builder(
        builder: (context) {
          return BlocConsumer<ResetPasswordCubit, ResetPasswordState> (
            listener: (context, state)async {
              if (state is ResetPasswordCodeSent){
                var isVerified = await Get.bottomSheet<bool>(
                    CodeVerificationBottomSheet(
                      onCompleted: confirmCode,
                      email: email,
                    ),
                    isScrollControlled: true,
                    ignoreSafeArea: false);
                if (isVerified ?? false) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeForgotPasswordScreen(token: code,resetPasswordCubit: _resetPasswordCubit,
                      ),
                    ),
                  );
                } else {}
              }
              if (state is ResetPasswordStateError){
                error = state.errorMessage;
              }
            },
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  leading: const BackButton(),
                  leadingWidth: 30,
                  toolbarHeight: 30,
                ),
                body: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.all(kDefaultSpacing),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Forgot Password",
                            style: TextStyle(
                                fontSize: 30, fontFamily: "Poppins-Bold"),
                          ),
                          Text(
                            "Enter the email associated with your account",
                            style: kDefaultTextStyle,
                          ),
                          kVerticalSpaceLarge,
                          Column(children: [
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
                          ]),
                          kVerticalSpaceLarge,
                          SubmitButton(
                              text: "Reset",
                              isLoading: state is ResetPasswordStateLoading,
                              enabled: state is! ResetPasswordStateLoading,
                              onSubmit:_sendResetPasswordCode),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }


  Future<String?> confirmCode(String code) async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
     this.code = code;
    });
      return null;
  }

  void _sendResetPasswordCode() {
    if (formKey.currentState!.validate()){
    _resetPasswordCubit.sendResetCode(email);
    }
  }
}
