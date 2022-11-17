import 'package:flutter/material.dart';
import 'package:greep/application/transactions/response/transaction_summary.dart';
import 'package:greep/commons/money.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/driver_section/widgets/record_card.dart';
import 'package:greep/utils/constants/app_styles.dart';

class TransactionSummaryBuilder extends StatelessWidget {
  final TransactionSummary transactionSummary;
  const TransactionSummaryBuilder({Key? key,required this.transactionSummary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RecordCard(
            initial: transactionSummary.income < 0 ? "-":"",
            width: constraints.maxWidth * 0.31,
            title: transactionSummary.income.abs().toMoney,
            subtitle: "Income",
            subtitleStyle: AppTextStyles.blackSize12,
            titleStyle: AppTextStyles.blackSize16,
            withSymbol: true,
          ),
          RecordCard(
            initial:transactionSummary.tripAmount == 0?"": "+",
            title: transactionSummary.tripAmount.toMoney,
            width: constraints.maxWidth * 0.31,
            transactions: transactionSummary.transactions,
            subtitle: "Trips",
            withSymbol: true,
            subtitleStyle: AppTextStyles.blackSize12,
            titleStyle: AppTextStyles.greenSize16,
          ),
          RecordCard(
            initial:transactionSummary.expenseAmount == 0 ? "":"-" ,
            title: transactionSummary.expenseAmount.toMoney,
            subtitle: "Expenses",
            width: constraints.maxWidth * 0.31,
            withSymbol: true,
            transactions: transactionSummary.transactions,
            subtitleStyle: AppTextStyles.blackSize12,
            titleStyle: kErrorColorTextStyle,
          ),
        ],
      );
    });
  }
}
