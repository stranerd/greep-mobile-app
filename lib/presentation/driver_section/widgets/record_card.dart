import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/transaction/TransactionData.dart';
import 'package:greep/domain/transaction/transaction.dart';
import 'package:greep/presentation/driver_section/widgets/empty_result_widget.dart';
import 'package:greep/presentation/driver_section/widgets/transaction_list_card.dart';
import 'package:greep/presentation/driver_section/widgets/transactions_card.dart';
import 'package:greep/presentation/widgets/app_dialog.dart';
import 'package:greep/presentation/widgets/money_widget.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/presentation/widgets/turkish_symbol.dart';
import 'package:greep/utils/constants/app_colors.dart';

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
        padding: EdgeInsets.all(14.5.r),
        height: 80.h,
        width: widget.width ?? 0.31.sw,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
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
            color: Color(0xFFF1F3F7),
            width: 2.w,
          ),
        ),
        child: Column(
          crossAxisAlignment: widget.centerAlign
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidget(
                  widget.initial,
                  fontSize: 16.sp,
                  style: widget.titleStyle,
                ),
                MoneyWidget(
                  amount: num.tryParse(widget.title) ?? 0,
                  withSymbol: widget.withSymbol,
                  size: 16,
                  color: widget.titleStyle.color,
                )
              ],
            ),
            SizedBox(height: 4.0.h),
            TextWidget(
              widget.subtitle,
              color: AppColors.veryLightGray,
              fontSize: 12.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _openDialog()  {
    if (widget.onTap != null) {
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
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return AppDialog(
              title: widget.subtitle,
              height: trans.isEmpty ? 200.h : 0.7.sh,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        return TransactionListCard(
                          transaction: e,
                          withLeading: true,
                        );
                      }).toList(),
                    ))
                ],
              ),
            );
          });
    }
  }
}
