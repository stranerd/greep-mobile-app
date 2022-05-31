import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grip/commons/Utils/input_validator.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/presentation/auth/forgot_password/change_forgot_password.dart';
import 'package:grip/presentation/widgets/input_text_field.dart';
import 'package:grip/presentation/widgets/submit_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> with InputValidator{
  String email = "";

  @override
  Widget build(BuildContext context) {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Forgot Password", style: TextStyle(
                    fontSize: 30,
                  fontFamily: "Poppins-Bold"
                ),),
                Text("Enter the email associated with your account",style: kDefaultTextStyle,),

                kVerticalSpaceLarge,
                Column(
                    children: [
                      LoginTextField(title: "Email", validator: validateEmail, isPassword: false,onChanged: (String value){
                        setState(() {
                          email = value;
                        });
                      },),]

                ),
                kVerticalSpaceLarge,
                SubmitButton(text: "Reset", onSubmit: (){
                  Get.to(() => const ChangeForgotPasswordScreen());
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
