import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/transactions/response/transaction_summary.dart';
import 'package:grip/application/transactions/transaction_summary_cubit.dart';
import 'package:grip/commons/money.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/domain/transaction/transaction.dart';
import 'package:grip/presentation/driver_section/widgets/empty_result_widget.dart';
import 'package:grip/presentation/widgets/text_widget.dart';
import 'package:grip/presentation/widgets/turkish_symbol.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_styles.dart';
import '../widgets/transactions_card.dart';
import 'transaction_details.dart';

class RangeTransactionsScreen extends StatefulWidget {
  final String userId;
  final DateTime from;
  final DateTime to;

  const RangeTransactionsScreen(
      {Key? key, required this.userId, required this.to, required this.from})
      : super(key: key);

  @override
  State<RangeTransactionsScreen> createState() =>
      _RangeTransactionsScreenState();
}

class _RangeTransactionsScreenState extends State<RangeTransactionsScreen> {
  List<Transaction> transactions = [];
  late TransactionSummary transactionSummary;

  @override
  void initState() {
    transactions = GetIt.I<TransactionSummaryCubit>().filterTransactions(
      widget.from,
      widget.to,
    );

    transactionSummary =
        GetIt.I<TransactionSummaryCubit>().getIntervalSummary(transactions);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 16,
            ),
            color: AppColors.black),
        title: Text(
          'Range',
          style: AppTextStyles.blackSizeBold14,
        ),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: Padding(
        padding:  EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "${DateFormat("${DateFormat.DAY} ${DateFormat.ABBR_MONTH} ${DateFormat.YEAR}").format(widget.from)} - ${DateFormat("${DateFormat.DAY} ${DateFormat.ABBR_MONTH} ${DateFormat.YEAR}").format(widget.to)} ",
                style: AppTextStyles.blackSizeBold12),
             SizedBox(
              height: 8.0.h,
            ),
            kVerticalSpaceRegular,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                kHorizontalSpaceRegular,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextWidget(
                      "Income: ",
                      style: AppTextStyles.blackSize10,
                    ),
                    TurkishSymbol(
                      width: 8,
                      height: 8,
                      color: AppTextStyles.blackSize10.color,
                    ),
                    TextWidget(
                      transactionSummary.income.toMoney,
                      style: AppTextStyles.blackSize10,
                    )
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextWidget(
                      "Trips: ${transactionSummary.tripAmount == 0 ? "" : "+"}",
                      style: AppTextStyles.greenSize10,
                    ),
                    TurkishSymbol(
                      width: 8,
                      height: 8,
                      color: AppTextStyles.greenSize10.color,
                    ),
                    TextWidget(
                      transactionSummary.tripAmount.toMoney,
                      style: AppTextStyles.greenSize10,
                    )
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextWidget(
                      "Expenses: ${transactionSummary.expenseAmount == 0 ? "" : "-"}",
                      style: AppTextStyles.redSize10,
                    ),
                    TurkishSymbol(
                      width: 8,
                      height: 8,
                      color: AppTextStyles.redSize10.color,
                    ),
                    TextWidget(
                      transactionSummary.expenseAmount.toMoney,
                      style: AppTextStyles.redSize10,
                    )
                  ],
                ),
              ],
            ),
            kVerticalSpaceRegular,
            if (transactions.isEmpty)
              SizedBox(
                  height: Get.height * 0.7,
                  child:
                      const EmptyResultWidget(text: "No transactions found")),
            if (transactions.isNotEmpty)
              Expanded(
                  child: ListView(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                children: transactions.map((e) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionDetails(
                            transaction: e,
                          ),
                        ),
                      );
                    },
                    child: TransactionCard(
                      transaction: e,
                      withBigAmount: false,
                      subTrailingStyle: AppTextStyles.blackSize12,
                      titleStyle: AppTextStyles.blackSize14,
                      subtitleStyle: AppTextStyles.blackSize12,
                      trailingStyle: AppTextStyles.greenSize14,
                    ),
                  );
                }).toList(),
              )),
          ],
        ),
      ),
    );
  }
}
