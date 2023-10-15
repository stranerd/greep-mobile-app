import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CodeVerificationBottomSheet extends StatefulWidget {
  final Function(String code) onCompleted;
  final String email;

  const CodeVerificationBottomSheet({
    Key? key,
    required this.onCompleted,
    required this.email,
  }) : super(key: key);

  @override
  State<CodeVerificationBottomSheet> createState() =>
      _CodeVerificationBottomSheetState();
}

class _CodeVerificationBottomSheetState
    extends State<CodeVerificationBottomSheet> {
  bool isError = false;
  bool isLoading = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: kWhiteColor,
        ),
        height: Get.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              leading: const BackIcon(isArrow: true,),
            ),
            kVerticalSpaceLarge,
            Center(
              child: Text(
                "Code Verification",
                style: kSubtitleTextStyle.copyWith(
                  fontSize: 30,
                ),
              ),
            ),
            kVerticalSpaceLarge,
            kVerticalSpaceLarge,
            Container(
              width: Get.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "A code has been sent to ",
                    style: kSubtitleTextStyle,
                  ),
                  kVerticalSpaceSmall,
                  Text(
                    widget.email,
                    style: kPrimaryTextStyle,
                  ),
                ],
              ),
            ),
            kVerticalSpaceLarge,
            PinCodeTextField(
              onChanged: (String value) {
                if (value.length < 6) {
                  setState(() {
                    isError = false;
                  });
                }
              },
              length: 6,
              textStyle:
                  kPrimaryTextStyle.copyWith(fontWeight: FontWeight.bold),
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(
                  kDefaultSpacing * 0.5,
                ),
                fieldHeight: 50,
                fieldWidth: 50,
                inactiveColor: kPrimaryColor,
                activeColor: kPrimaryColor,
              ),
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              onCompleted: (str) async {
                setState(() {
                  isLoading = true;
                });
                String? message = await widget.onCompleted(str);
                setState(() {
                  isLoading = false;
                });
                if (message != null) {
                  setState(() {
                    isError = true;
                    errorMessage = message;
                  });
                } else {
                  Get.back(result: true);
                }
              },
              appContext: context,
            ),
            kVerticalSpaceRegular,
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
            if (isError)
              Center(
                  child: Text(
                errorMessage!,
                style: kErrorColorTextStyle,
              )),
          ],
        ),
      ),
    );
  }
}
