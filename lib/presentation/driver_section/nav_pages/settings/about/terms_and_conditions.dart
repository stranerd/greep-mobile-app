import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/utils/constants/app_styles.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 16,
          ),
        ),
        title: Text(
          "Terms & Conditions",
          style: AppTextStyles.blackSizeBold14,
        ),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Terms & Condition", style: AppTextStyles.blackSizeBold16),
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
