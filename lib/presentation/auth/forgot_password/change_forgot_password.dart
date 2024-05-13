import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:greep/application/auth/password/reset_password_cubit.dart';
import 'package:greep/commons/Utils/input_validator.dart';
import 'package:greep/commons/scaffold_messenger_service.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/auth/forgot_password/change_forgot_password_success.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/input_text_field.dart';
import 'package:greep/presentation/widgets/submit_button.dart';

class ChangeForgotPasswordScreen extends StatefulWidget {
  final String token;
  final PasswordCrudCubit resetPasswordCubit;

  const ChangeForgotPasswordScreen(
      {Key? key, required this.token, required this.resetPasswordCubit})
      : super(key: key);

  @override
  State<ChangeForgotPasswordScreen> createState() =>
      _ChangeForgotPasswordScreenState();
}

class _ChangeForgotPasswordScreenState extends State<ChangeForgotPasswordScreen>
    with InputValidator, ScaffoldMessengerService {
  String password = "";
  String confirmPassword = "";
  final formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.resetPasswordCubit,
      child: Builder(
        builder: (context) {
          return BlocConsumer<PasswordCrudCubit, PasswordCrudState>(
            listener: (context, state) {
              if (state is PasswordCrudStateError) {
                if (state.errorMessage.contains("invalid")){
                  error = "Incorrect verification code";
                }
                error = state.errorMessage;
              }

              if (state is PasswordCrudStateSuccess) {
                Get.offAll(() => const ChangeForgotPasswordSuccess());
              }
            },
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  leading: const BackIcon(isArrow: true,),
                  leadingWidth: 30,
                  toolbarHeight: 30,
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(kDefaultSpacing),
                      child: Form(
                        key: formKey,
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
                              InputTextField(
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
                              InputTextField(
                                title: "Confirm password",
                                validator: (String s){
                                  if (password.isEmpty){
                                    return emptyFieldValidator(s);}
                                  if (password.length < 8){
                                    return "Passwords must be 8 digits or more";
                                  }
                                    return s == password ? null : "Password do not match";

                                },
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
                                isLoading: state is PasswordCrudStateLoading,
                                enabled: state is! PasswordCrudStateLoading,
                                onSubmit: _confirmPasswordChange),
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
      ),
    );
  }

  void _confirmPasswordChange() {
    if (formKey.currentState!.validate()){
    widget.resetPasswordCubit.confirmResetPasswordChange(
        password: password, token: "\"${widget.token}\"");
  }
  }
}
