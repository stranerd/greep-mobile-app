import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:greep/domain/transaction/transaction.dart';
import 'package:greep/presentation/driver_section/security/sheets/reset_transaction_pin_sheet.dart';
import 'package:greep/presentation/widgets/app_dialog.dart';
import 'package:greep/presentation/widgets/money_widget.dart';
import 'package:greep/presentation/widgets/number_dialer.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class ConfirmSendMoneyPinSheet extends StatefulWidget {
  final num amount;
  final Function(String) onFinish;

  const ConfirmSendMoneyPinSheet(
      {Key? key, required this.amount, required this.onFinish})
      : super(key: key);

  @override
  State<ConfirmSendMoneyPinSheet> createState() =>
      _ConfirmSendMoneyPinSheetState();
}

class _ConfirmSendMoneyPinSheetState extends State<ConfirmSendMoneyPinSheet> {
  String pin = "";

  @override
  Widget build(BuildContext context) {
    return AppDialog(
        title: "Input PIN to pay",
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MoneyWidget(
              amount: widget.amount,
              flipped: true,
              weight: FontWeight.bold,
              size: 28,
            ),
            SizedBox(
              height: 16.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) => dot(
                  color: AppColors.lightGray,
                  index: index,
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(context: context, builder: (context){
                  return ResetTransactionPINSheet();
                });
              },
              child: TextWidget(
                "Forgot PIN?",fontSize: 14,
                color: AppColors.blue,
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Flexible(
              child: NumberDialer(
                onClear: () {
                  if (pin.isNotEmpty) {
                    setState(() {
                      pin = pin.substring(0, pin.length - 1);
                    });
                  }
                },
                onSelect: (s) {
                  if (pin.length < 4) {
                    setState(() {
                      pin = "$pin$s";
                    });
                  }
                  print(pin);
                },
                onValue: (_) {},
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            SubmitButton(
                text: "Next",
                enabled: pin.isNotEmpty && pin.length == 4,
                onSubmit: () {
                  Get.back();
                  widget.onFinish(pin);
                  // Get.off(() => SendMoneyTransactionSuccessScreen(transaction: UserTransaction.random(),),);
                }),
          ],
        ));
  }

  Widget dot({required Color color, required int index}) {
    return Container(
      width: 18.r,
      height: 18.r,
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: ShapeDecoration(
        color: pin.length > index ? AppColors.black : AppColors.lightGray,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
          8.r,
        )),
      ),
    );
  }
}
