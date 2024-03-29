import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/domain/transaction/TransactionData.dart';
import 'package:grip/domain/transaction/transaction.dart';
import 'package:grip/presentation/driver_section/widgets/empty_result_widget.dart';
import 'package:grip/presentation/driver_section/widgets/transactions_card.dart';
import 'package:grip/presentation/widgets/splash_tap.dart';
import 'package:grip/presentation/widgets/text_widget.dart';
import 'package:grip/presentation/widgets/turkish_symbol.dart';

class RecordCard extends StatefulWidget {
  const RecordCard({
    Key? key,
    required this.title,
    required this.subtitle,
    this.withSymbol = false,
    required this.titleStyle,
    required this.initial,
    this.transactions,
    this.centerAlign = true,
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

  @override
  State<RecordCard> createState() => _RecordCardState();
}

class _RecordCardState extends State<RecordCard> {
  @override
  Widget build(BuildContext context) {
    return SplashTap(
      onTap: _openDialog,
      child: Container(
        padding:  EdgeInsets.all((kDefaultSpacing * 0.75).r),
        height: 80.h,
        width: widget.width ?? 0.31.sw,
        decoration: BoxDecoration(
          color: kLightGrayColor,
          borderRadius: BorderRadius.circular(8.0.r),
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
                TextWidget(widget.initial,style: widget.titleStyle.copyWith(fontSize: 18),
                ),
                if (widget.withSymbol)  TurkishSymbol(width: (18.w), height: (18.h),color: widget.titleStyle.color,),
                TextWidget(
                  widget.title,
                  style: widget.titleStyle.copyWith(fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
             SizedBox(height: 8.0.h),
            TextWidget(widget.subtitle,
                style: kDefaultTextStyle.copyWith(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  void _openDialog() {
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
                          child:const Icon(
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
