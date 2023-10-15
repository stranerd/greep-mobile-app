import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_styles.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackIcon(isArrow: true,),
        title: TextWidget(
          "Terms & Conditions",
          fontSize: 16.sp,
          weight: FontWeight.bold,
        ),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget("Terms & Condition", fontSize: 16.sp,weight: FontWeight.bold,),
              kVerticalSpaceSmall,
              Text.rich(TextSpan(
                  style: kDefaultTextStyle,
                  children: [
                    TextSpan(text: "  At Stranerd, accessible from stranerd.com, one of our main priorities is the privacy of our visitors."
                        " This Terms & Condition document contains types of information that is collected and recorded by Stranerd and how we use it."
                        " If you have additional questions or require more information about our Terms & Condition, do not hesitate to contact us. "
                        "This Terms & Condition applies only to our online activities and is valid for visitors to our website with regards to the information that they shared and/or collect in Stranerd. "
                        "This policy is not applicable to any information collected offline or via channels otherthan this website."),

                    TextSpan(text: "\n\nConsent\n\n", style: kBoldTextStyle2),
                    TextSpan(text: """  By using our website, you hereby consent to our Terms & Condition and agree to its terms."""),
                    TextSpan(
                        text: "\n\nInformation we collect\n\n", style: kBoldTextStyle2),
                    TextSpan(text: """  The personal information that you are asked to provide,and the reasons why you are asked to provide it, will be made clear to you at the point we ask you to provide your personal information.""")
                  ]))
            ],
          ),
        ),
      ),
    );
  }

}
