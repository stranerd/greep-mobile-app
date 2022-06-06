import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/transactions/response/transaction_summary.dart';
import 'package:grip/application/transactions/transaction_summary_cubit.dart';
import 'package:grip/commons/money.dart';
import 'package:grip/presentation/driver_section/widgets/record_card.dart';
import 'package:grip/utils/constants/app_styles.dart';

class TransactionIntervalSummaryWidget extends StatelessWidget {
  final String userId;
  final DateTime from;
  final DateTime to;

  const TransactionIntervalSummaryWidget(
      {Key? key, required this.userId, required this.to, required this.from})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var transactionSummaryCubit = GetIt.I<TransactionSummaryCubit>();
    TransactionSummary transactionSummary = transactionSummaryCubit.calculate(
        userId, DateTime(from.year, from.month, from.day), to);
    return LayoutBuilder(builder: (context, constraints) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RecordCard(
            width: constraints.maxWidth * 0.31,
            title: "N${transactionSummary.amount.toMoney}",
            subtitle: "Income",
            subtitleStyle: AppTextStyles.blackSize12,
            titleStyle: AppTextStyles.greenSize16,
          ),
          RecordCard(
            title: transactionSummary.trips.toMoney,
            subtitle: "Trips",
            subtitleStyle: AppTextStyles.blackSize12,
            titleStyle: AppTextStyles.blackSize16,
          ),
          RecordCard(
            title: transactionSummary.expenses.toMoney,
            subtitle: "Expenses",
            subtitleStyle: AppTextStyles.blackSize12,
            titleStyle: AppTextStyles.blackSize16,
          ),
        ],
      );
    });
  }
}
