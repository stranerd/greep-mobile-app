import 'package:flutter/material.dart';
import 'package:greep/application/transactions/response/commission_summary.dart';
import 'package:greep/commons/Utils/utils.dart';
import 'package:greep/commons/money.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/presentation/widgets/turkish_symbol.dart';
import 'package:greep/utils/constants/app_styles.dart';
import 'package:intl/intl.dart';

class CommissionSummaryItem extends StatelessWidget {
  final CommissionSummary commissionSummary;
  final bool isMonthly;
  final bool isWeekly;
  final Alignment alignment;
  final Color? backgroundColor;

  const CommissionSummaryItem(
      {Key? key,
      required this.commissionSummary,
      this.isWeekly = false,
      this.backgroundColor,
      this.alignment = Alignment.centerLeft,
      this.isMonthly = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime date = commissionSummary.transactions.isEmpty
        ? DateTime.now()
        : commissionSummary.transactions.first.timeAdded;
    String day = "";

    if (isWeekly) {
      List<DateTime> dateTime = [];
      dateTime.add(
        commissionSummary.transactions.isEmpty
            ? DateTime.now()
            : commissionSummary.transactions.first.timeAdded,
      );
      dateTime.add(
        commissionSummary.transactions.isEmpty
            ? DateTime.now()
            : commissionSummary.transactions.last.timeAdded,
      );

      day = " ${DateFormat(DateFormat.ABBR_WEEKDAY).format(commissionSummary.dateRange.first)} ${commissionSummary.dateRange.first.day} - ${DateFormat(
      "${DateFormat.ABBR_WEEKDAY} ${DateFormat.DAY} ${DateFormat.MONTH} ${DateFormat.YEAR}")
        .format(commissionSummary.dateRange.last)}";
    } else if (isMonthly) {
      day = DateFormat(
              "${DateFormat.MONTH} ${DateFormat.YEAR}")
          .format(date);
    } else {
      if (areDatesEqual(DateTime.now(), date)) {
        day = "Today";
      } else if (areDatesEqual(
          DateTime.now().subtract(const Duration(days: 1)), date)) {
        day = "Yesterday";
      } else {
        day = DateFormat(
                "${DateFormat.ABBR_WEEKDAY}, ${DateFormat.DAY} ${DateFormat.MONTH} ${DateFormat.YEAR}")
            .format(date);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(day, style: AppTextStyles.blackSizeBold14),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          alignment: alignment,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: backgroundColor,
            border: Border.all(
              color: const Color.fromRGBO(221, 226, 224, 1),
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TurkishSymbol(height: 11,width: 11,color: AppTextStyles.greenSize10.color,), TextWidget(commissionSummary.commission.toMoney,
                  style: AppTextStyles.greenSize16),
            ],
          ),
        ),
      ],
    );
  }
}
