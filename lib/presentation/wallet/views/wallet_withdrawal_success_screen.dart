import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/transaction/transaction.dart';
import 'package:greep/domain/transaction/wallet_transaction.dart';
import 'package:greep/presentation/driver_section/nav_pages/nav_bar/nav_bar_view.dart';
import 'package:greep/presentation/wallet/views/wallet_transaction_details_screen.dart';
import 'package:greep/presentation/widgets/box_shadow_container.dart';
import 'package:greep/presentation/widgets/money_widget.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/presentation/widgets/time_dot_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class WalletWithdrawalSuccessScreen extends StatelessWidget {
  final WalletTransaction transaction;

  const WalletWithdrawalSuccessScreen({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: 1.sw,
          height: 1.sh,
          padding: EdgeInsets.all(
            16.r,
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100.h,
                      ),
                      TextWidget(
                        "Withdrawal successful",
                        fontSize: 20.sp,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      MoneyWidget(
                        amount: transaction.amount,
                        weight: FontWeight.bold,
                        size: 40,
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      BoxShadowContainer(
                          child: Column(
                        children: [
                          _buidItem(
                            "From",
                            "Wallet",
                          ),
                          SizedBox(
                            height: 24.h,
                          ),
                          _buidItem("Payment Type", "Cash"),
                          SizedBox(
                            height: 24.h,
                          ),
                          _buidItem(
                            "Time",
                            "",
                            widgetValue: TimeDotWidget(
                              date: transaction.date,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
              Positioned(
                  bottom: 0,
                  width: 1.sw - 32.w,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SubmitButton(
                        text: "View receipt",
                        onSubmit: () {
                          Get.to(() => WalletTransactionDetailsScreen(
                              transaction: transaction));
                        },
                        backgroundColor: Colors.white,
                        isBorder: true,
                        textStyle: kDefaultTextStyle.copyWith(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      SubmitButton(
                          text: "Done",
                          onSubmit: () {
                           Get.offAll(NavBarView());
                          })
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buidItem(String title, String value, {Widget? widgetValue}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
          title,
          color: AppColors.veryLightGray,
          fontSize: 14.sp,
        ),
        (widgetValue != null)
            ? widgetValue
            : TextWidget(
                value,
                fontSize: 14.sp,
              )
      ],
    );
  }
}
