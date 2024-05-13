import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:greep/presentation/wallet/cash_withdrawal_screen.dart';
import 'package:greep/presentation/wallet/through_an_agent_withdrawal_screen.dart';
import 'package:greep/presentation/widgets/app_dialog.dart';
import 'package:greep/presentation/widgets/box_shadow_container.dart';
import 'package:greep/presentation/widgets/custom_radio_toggle_widget.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:greep/presentation/widgets/text_widget.dart';

class WalletWithdrawOptionsSheet extends StatefulWidget {
  const WalletWithdrawOptionsSheet({Key? key}) : super(key: key);

  @override
  State<WalletWithdrawOptionsSheet> createState() =>
      _WalletWithdrawOptionsSheetState();
}

class _WalletWithdrawOptionsSheetState
    extends State<WalletWithdrawOptionsSheet> {
  int selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: "Withdraw",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SplashTap(
            onTap: () {
              setState(() {
                selectedIndex = 0;
              });
            },
            child: BoxShadowContainer(
              child: Row(
                children: [
                  CustomRadioToggleWidget(
                    isOn: selectedIndex == 0,
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  TextWidget(
                    "Through an agent",
                    weight: FontWeight.bold,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          SplashTap(
            onTap: () {
              setState(() {
                selectedIndex = 1;
              });
            },
            child: BoxShadowContainer(
              child: Row(
                children: [
                  CustomRadioToggleWidget(
                    isOn: selectedIndex == 1,
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  TextWidget(
                    "Naira Transfer",
                    weight: FontWeight.bold,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          SubmitButton(
            text: "Accept",
            enabled: selectedIndex <= 1,
            onSubmit: () {
              if (selectedIndex == 0) {
                Get.off(
                  ThroughAnAgentWithdrawalScreen(),
                );
                return;
              }
              if (selectedIndex == 1){
                Get.off(CashWithdrawalScreen());
              }
            },
          ),
        ],
      ),
    );
  }
}
