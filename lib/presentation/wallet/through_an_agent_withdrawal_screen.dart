import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greep/presentation/widgets/amount_selector_widget.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/box_shadow_container.dart';
import 'package:greep/presentation/widgets/custom_appbar.dart';
import 'package:greep/presentation/widgets/input_text_field.dart';
import 'package:greep/presentation/widgets/text_widget.dart';

class ThroughAnAgentWithdrawalScreen extends StatefulWidget {
  const ThroughAnAgentWithdrawalScreen({Key? key}) : super(key: key);

  @override
  _ThroughAnAgentWithdrawalScreenState createState() =>
      _ThroughAnAgentWithdrawalScreenState();
}

class _ThroughAnAgentWithdrawalScreenState
    extends State<ThroughAnAgentWithdrawalScreen> {
  num selectedNum = 0;

  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TextWidget(
          "Through an agent",
          weight: FontWeight.bold,
          fontSize: 18.sp,
        ),
        leading: const BackIcon(
          isArrow: true,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: 16.h,
          horizontal: 16.w,
        ),
        child: Column(
          children: [
            AmountSelectorWidget(onValue: (s) {
              selectedNum = num.tryParse(s) ?? 0;
              setState(() {});
            }),
            SizedBox(
              height: 100.h,
            ),
            Container(
              alignment: Alignment.centerLeft,
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    "Agent",
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  BoxShadowContainer(
                    width: double.maxFinite,
                    child: TextWidget("There are currently no available agents"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
