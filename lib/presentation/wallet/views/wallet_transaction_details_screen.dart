import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greep/domain/transaction/wallet_transaction.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/transaction/transaction.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/box_shadow_container.dart';
import 'package:greep/presentation/widgets/confirmation_dialog.dart';
import 'package:greep/presentation/widgets/money_widget.dart';
import 'package:greep/presentation/widgets/profile_photo_widget.dart';
import 'package:greep/presentation/widgets/sub_header_text.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/presentation/widgets/time_dot_widget.dart';
import 'package:greep/presentation/widgets/turkish_symbol.dart';
import 'package:greep/utils/constants/app_colors.dart';

class WalletTransactionDetailsScreen extends StatefulWidget {
  final WalletTransaction transaction;

  const WalletTransactionDetailsScreen(
      {Key? key,
      required this.transaction})
      : super(key: key);
  @override
  _WalletTransactionDetailsScreenState createState() =>
      _WalletTransactionDetailsScreenState();
}

class _WalletTransactionDetailsScreenState extends State<WalletTransactionDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: BackIcon(isArrow: true,),
        title: const TextWidget(
          "Details",
          weight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      body: SafeArea(
        child: Container(
          height: 1.sh,
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(kDefaultSpacing.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BoxShadowContainer(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                TextWidget(
                                  "+${widget.transaction.amount}",
                                  fontSize: 18.sp,
                                  weight: FontWeight.bold,
                                ),
                                TurkishSymbol(
                                  width: 16.r,
                                  height: 16.r,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            TextWidget(
                              "${widget.transaction.title}",
                              color: AppColors.veryLightGray,
                              fontSize: 12.sp,
                            )
                          ],
                        ),
                        ProfilePhotoWidget(
                          url: "",
                          radius: 22, initials: '',
                        ),
                      ],
                    )),
                    kVerticalSpaceMedium,
                    BoxShadowContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buidItem("Price", "N/A",
                              widgetValue: MoneyWidget(
                                amount: widget.transaction.amount,
                                flipped: true,
                                size: 14,
                              )),
                          SizedBox(height: 24.h,),

                          _buidItem(
                            "Extra Charges",
                            "N/A",
                            widgetValue: MoneyWidget(
                              amount: 0,
                              flipped: true,
                              size: 14,
                            ),
                          ),
                      SizedBox(height: 24.h,),
                          _buidItem(
                            "Discount",
                            "N/A",
                            widgetValue: MoneyWidget(
                              amount: 0,
                              flipped: true,
                              size: 14,
                            ),
                          ),
                          kVerticalSpaceRegular,
                          _buidItem("Payment Amount", "",
                              widgetValue: MoneyWidget(
                                amount: widget.transaction.amount ?? 0,
                                flipped: true,
                                size: 14,
                              )),

                        ],
                      ),
                    ),
                    kVerticalSpaceRegular,
                    BoxShadowContainer(
                        child: Column(
                      children: [
                        _buidItem(
                          "Description",
                          widget.transaction.description,
                        ),
                        SizedBox(height: 24.h,),

                        _buidItem("TransactionID", widget.transaction.id),
                        SizedBox(height: 24.h,),
                        _buidItem(
                          "Time",
                          "",
                          widgetValue: TimeDotWidget(
                            date: widget.transaction.date,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    )),
                    kVerticalSpaceRegular,
                    BoxShadowContainer(
                        child: _buidItem(
                      "Reward",
                      "",
                      widgetValue: TextWidget("0 pts"),),),
                    kVerticalSpaceLarge,
                  ],
                ),
              ),
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
