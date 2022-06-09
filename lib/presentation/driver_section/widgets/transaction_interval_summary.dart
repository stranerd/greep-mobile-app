import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/transactions/response/transaction_summary.dart';
import 'package:grip/application/transactions/transaction_summary_cubit.dart';
import 'package:grip/commons/money.dart';
import 'package:grip/presentation/driver_section/widgets/record_card.dart';
import 'package:grip/presentation/widgets/transaction_summary_builder.dart';
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
    return TransactionSummaryBuilder(transactionSummary: transactionSummary);
  }
}
