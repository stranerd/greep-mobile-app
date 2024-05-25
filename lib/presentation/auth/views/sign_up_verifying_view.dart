import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:greep/application/auth/AuthenticationCubit.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/ioc.dart';
import 'package:greep/presentation/auth/home/auth_home.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/loading_widget.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class SignUpVerifyingView extends StatelessWidget {
  const SignUpVerifyingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: 1.sh,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                ),
                child: BackIcon(
                  isArrow: true,
                  onTap: () {
                    Get.offAll(AuthHomeScreen());
                    getIt<AuthenticationCubit>().signout();
                  },
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LoadingWidget(
                      isGreep: true,
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    const TextWidget(
                      "Waiting for verification",
                      weight: FontWeight.w700,
                      fontSize: 23,
                    ),
                    kVerticalSpaceSmall,
                    const Align(
                      alignment: Alignment.center,
                      child: TextWidget(
                        "Please allow us some time to process your verification.",
                        textAlign: TextAlign.center,
                        color: AppColors.black,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
