import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:greep/application/transactions/response/transaction_summary.dart';
import 'package:greep/application/transactions/transaction_summary_cubit.dart';
import 'package:greep/commons/money.dart';
import 'package:greep/presentation/driver_section/widgets/record_card.dart';
import 'package:greep/presentation/widgets/transaction_summary_builder.dart';
import 'package:greep/utils/constants/app_styles.dart';

class TransactionIntervalSummaryWidget extends StatelessWidget {
  final String userId;
  final DateTime from;
  final DateTime to;

  const TransactionIntervalSummaryWidget(
      {Key? key, required this.userId, required this.to, required this.from})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<TransactionSummaryCubit, TransactionSummaryState>(

      builder: (context, state) {
        if (state is TransactionSummaryStateDone) {
          TransactionSummary transactionSummary = GetIt.I<
              TransactionSummaryCubit>()
              .calculateInterval(DateTime(from.year, from.month, from.day), to);

          return TransactionSummaryBuilder(
              transactionSummary: transactionSummary);
        }
        return Container();
      },
    );
  }
}
