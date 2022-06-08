import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/transactions/transaction_summary_cubit.dart';
import 'package:grip/domain/transaction/transaction.dart';
import 'package:grip/presentation/driver_section/widgets/empty_result_widget.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_styles.dart';
import '../widgets/transactions_card.dart';
import 'balance.dart';
import 'to_collect_screen.dart';
import 'to_pay_screen.dart';
import 'transaction_details.dart';
import 'view_expense.dart';

class Range extends StatefulWidget {
  final String userId;
  final DateTime from;
  final DateTime to;

  const Range(
      {Key? key, required this.userId, required this.to, required this.from})
      : super(key: key);

  @override
  State<Range> createState() => _RangeState();
}

class _RangeState extends State<Range> {
  List<Transaction> transactions = [];

  @override
  void initState() {
    transactions = GetIt.I<TransactionSummaryCubit>().filterTransactions(
      widget.userId,
      widget.from,
      widget.to,
    );


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
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "${DateFormat("${DateFormat.DAY} ${DateFormat.ABBR_MONTH} ${DateFormat.YEAR}").format(widget.from)} - ${DateFormat("${DateFormat.DAY} ${DateFormat.ABBR_MONTH} ${DateFormat.YEAR}").format(widget.to)} ",
                style: AppTextStyles.blackSizeBold12),
            const SizedBox(
              height: 8.0,
            ),
            if (transactions.isEmpty)SizedBox(
                height: Get.height * 0.7,
                child: const EmptyResultWidget(text: "No transactions found")),
           if (transactions.isNotEmpty) Expanded(child:
            ListView(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              children: transactions.map((e) {
                return  GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  TransactionDetails(transaction: e,),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      border: Border.all(
                          width: 1,
                          color: const Color.fromRGBO(221, 226, 224, 1)),
                    ),
                    child: TransactionCard(
                      title: "Kemi",
                      subtitle: "Mar 19 . 10:54 AM",
                      transaction: e,
                      trailing: "+20\$",
                      subTrailing: "Trip",
                      subTrailingStyle: AppTextStyles.blackSize12,
                      titleStyle: AppTextStyles.blackSize14,
                      subtitleStyle: AppTextStyles.blackSize12,
                      trailingStyle: AppTextStyles.greenSize14,
                    ),
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
