import 'package:flutter/material.dart';
import 'package:grip/application/transactions/response/commission_summary.dart';
import 'package:grip/commons/Utils/utils.dart';
import 'package:grip/commons/money.dart';
import 'package:grip/utils/constants/app_styles.dart';
import 'package:intl/intl.dart';

class CommissionSummaryItem extends StatelessWidget {
  final CommissionSummary commissionSummary;
  final bool isMonthly;
  const CommissionSummaryItem({Key? key, required this.commissionSummary, this.isMonthly = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime date = commissionSummary.transactions.first.timeAdded;
    String day = "";
    if (isMonthly){
      day = DateFormat("${DateFormat.MONTH} ${DateFormat.YEAR}").format(date);
    }
    else {
    if (areDatesEqual(DateTime.now(), date)) {
      day = "Today";
    } else if (areDatesEqual(
        DateTime.now()
            .subtract(const Duration(days: 1)),
        date)) {
      day = "Yesterday";
    } else {
      day = isMonthly ? DateFormat("${DateFormat.MONTH} ${DateFormat.YEAR}").format(date) :DateFormat(
          "${DateFormat.ABBR_WEEKDAY}, ${DateFormat.DAY} ${DateFormat.MONTH} ${DateFormat.YEAR}")
          .format(date);
    }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(day,
            style:
            AppTextStyles.blackSizeBold12),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
              16, 16, 16, 16),
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(8),
            border: Border.all(
              color: const Color.fromRGBO(
                  221, 226, 224, 1),
              width: 1.0,
            ),
          ),
          child: Text("N${commissionSummary.commission.toMoney}",
              style: AppTextStyles.greenSize16),
        ),
      ],
    );
  }
}
