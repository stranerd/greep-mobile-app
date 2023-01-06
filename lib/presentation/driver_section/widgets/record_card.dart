import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/transaction/TransactionData.dart';
import 'package:greep/domain/transaction/transaction.dart';
import 'package:greep/presentation/driver_section/widgets/empty_result_widget.dart';
import 'package:greep/presentation/driver_section/widgets/transactions_card.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/presentation/widgets/turkish_symbol.dart';

class RecordCard extends StatefulWidget {
  const RecordCard({
    Key? key,
    required this.title,
    required this.subtitle,
    this.withSymbol = false,
    required this.titleStyle,
    required this.initial,
    this.isSelected = false,
    this.transactions,
    this.centerAlign = true,
    this.onTap,
    this.width,
    required this.subtitleStyle,
  }) : super(key: key);

  final bool withSymbol;
  final String title;
  final String initial;
  final String subtitle;
  final bool centerAlign;
  final List<Transaction>? transactions;
  final double? width;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final Function? onTap;
  final bool isSelected;

  @override
  State<RecordCard> createState() => _RecordCardState();
}

class _RecordCardState extends State<RecordCard> {
  @override
  Widget build(BuildContext context) {
    return SplashTap(
      onTap: _openDialog,
      child: Container(
        padding: EdgeInsets.all((kDefaultSpacing * 0.75).r),
        height: 80.h,
        width: widget.width ?? 0.31.sw,
        decoration: BoxDecoration(
          color: kLightGrayColor,
          borderRadius: BorderRadius.circular(8.0.r),
          boxShadow: widget.isSelected
              ? [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    spreadRadius: 1,
                    blurRadius: 0.5,
                    offset: const Offset(
                      0,
                      4,
                    ), // changes position of shadow
                  ),
                ]
              : null,
          border: Border.all(
            color: kGreyColor2,
            width: 0.5.w,
          ),
        ),
        child: Column(
          crossAxisAlignment: widget.centerAlign
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidget(
                  widget.initial,
                  fontSize: 17,
                  style: widget.titleStyle,
                ),
                if (widget.withSymbol)
                  TurkishSymbol(
                    width: (16.w),
                    height: (16.h),
                    color: widget.titleStyle.color,
                  ),
                TextWidget(
                  widget.title,
                  fontSize: 17,
                  style: widget.titleStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            SizedBox(height: 8.0.h),
            TextWidget(widget.subtitle,
                style: kDefaultTextStyle.copyWith(fontSize: 10)),
          ],
        ),
      ),
    );
  }

  void _openDialog() {
    if (widget.onTap!=null){
      widget.onTap!();
      return;
    }

    List<Transaction> trans = [];
    if (widget.transactions != null) {
      if (widget.subtitle.toLowerCase().contains("trip")) {
        trans = widget.transactions!
            .where((element) =>
                element.data.transactionType == TransactionType.trip)
            .toList();
      } else if (widget.subtitle.toLowerCase().contains("expense")) {
        trans = widget.transactions!
            .where((element) =>
                element.data.transactionType == TransactionType.expense)
            .toList();
      }
    }
    if (["trip", "expense"]
        .any((e) => widget.subtitle.toLowerCase().contains(e))) {
      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kDefaultSpacing)),
              child: Container(
                height: trans.isEmpty ? 200 : Get.height * 0.5,
                padding: const EdgeInsets.all(kDefaultSpacing),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          widget.subtitle,
                          style: kTitleTextStyle,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(
                            Icons.close,
                          ),
                        )
                      ],
                    ),
                    kVerticalSpaceRegular,
                    if (trans.isEmpty)
                      const SizedBox(
                        height: 80,
                        child: const EmptyResultWidget(
                          text: "No Transactions",
                        ),
                      ),
                    if (trans.isNotEmpty)
                      Expanded(
                          child: ListView(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        children: trans.map((e) {
                          return TransactionCard(
                            transaction: e,
                            titleStyle: TextStyle(),
                            subtitleStyle: TextStyle(),
                            trailingStyle: TextStyle(),
                            subTrailingStyle: TextStyle(),
                          );
                        }).toList(),
                      ))
                  ],
                ),
              ),
            );
          });
    }
  }
}
