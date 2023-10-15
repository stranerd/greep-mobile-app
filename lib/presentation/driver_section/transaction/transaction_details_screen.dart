import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

class TransactionDetailsScreen extends StatefulWidget {
  final Transaction transaction;

  const TransactionDetailsScreen(
      {Key? key,
      required this.transaction})
      : super(key: key);
  @override
  _TransactionDetailsScreenState createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: BackIcon(isArrow: true,),
        title: TextWidget(
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
                              "Trip with ${widget.transaction.data.customerName}",
                              color: AppColors.veryLightGray,
                              fontSize: 12.sp,
                            )
                          ],
                        ),
                        const ProfilePhotoWidget(
                          url: "",
                          radius: 22,
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
                          kVerticalSpaceRegular,
                          _buidItem(
                            "Extra Charges",
                            "N/A",
                            widgetValue: MoneyWidget(
                              amount: 0,
                              flipped: true,
                              size: 14,
                            ),
                          ),
                          kVerticalSpaceRegular,
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
                                amount: widget.transaction.data.paidAmount ?? 0,
                                flipped: true,
                                size: 14,
                              )),
                          kVerticalSpaceRegular,
                          _buidItem(
                              "Payment Type",
                              widget.transaction.data.paymentType?.name ??
                                  "wallet"),
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
                        kVerticalSpaceRegular,
                        _buidItem("TransactionID", widget.transaction.id),
                        kVerticalSpaceRegular,
                        _buidItem(
                          "Time",
                          "",
                          widgetValue: TimeDotWidget(
                            date: widget.transaction.timeAdded,
                            color: AppColors.black,
                          ),
                        ),
                        kVerticalSpaceRegular,
                      ],
                    )),
                    kVerticalSpaceRegular,
                    BoxShadowContainer(
                        child: _buidItem(
                      "Balance",
                      "",
                      widgetValue: MoneyWidget(
                        amount: 0,
                        flipped: true,
                      ),
                    )),
                    kVerticalSpaceLarge,
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: 1.sw,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                  ),
                  margin: EdgeInsets.all(5.r),
                  child: SubmitButton(
                    text: "Pay \$70",
                    onSubmit: () async {
                      var result = await showDialog<bool?>(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) {
                            return ConfirmationDialog(
                                icon: SvgPicture.asset(
                                  "assets/icons/wallet-2.svg",
                                  color: AppColors.black,
                                  width: 33.w,
                                  height: 33.h,
                                ),
                                content: Text.rich(
                                  const TextSpan(children: [
                                    TextSpan(
                                      text:
                                          "You're about to pay 70 ₺ from your wallet",
                                    )
                                  ]),
                                  style: kDefaultTextStyle.copyWith(
                                    fontSize: 17.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                yesText: "Pay",
                                noText: "Cancel");
                          });
                    },
                  ),
                ),
              )
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
