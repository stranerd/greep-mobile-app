import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/presentation/auth/home/auth_home.dart';
import 'package:grip/presentation/widgets/submit_button.dart';

class ChangeForgotPasswordSuccess extends StatelessWidget {
  const ChangeForgotPasswordSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Get.offAll(() => const AuthHomeScreen());
        return Future.value(true);
      },
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(kDefaultSpacing),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              kVerticalSpaceRegular,
              Text("Your password has been reset successfully", style: kDefaultTextStyle,),
              kVerticalSpaceLarge,
              kVerticalSpaceLarge,
              SubmitButton(text: "Continue to Login", onSubmit: (){
                Get.to(() => const AuthHomeScreen());
              }),

            ],
          ),
        ),
      ),
    );
  }
}
