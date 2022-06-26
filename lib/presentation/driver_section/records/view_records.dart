import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/transactions/response/transaction_summary.dart';
import 'package:grip/application/transactions/transaction_summary_cubit.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/commons/Utils/utils.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/money.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/presentation/driver_section/widgets/empty_result_widget.dart';
import 'package:grip/presentation/widgets/driver_selector_widget.dart';
import 'package:grip/presentation/widgets/transaction_summary_builder.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_styles.dart';
import '../widgets/record_card.dart';

class ViewAllRecords extends StatefulWidget {
  const ViewAllRecords({Key? key}) : super(key: key);

  @override
  State<ViewAllRecords> createState() => _ViewAllRecordsState();
}

class _ViewAllRecordsState extends State<ViewAllRecords> {
  Map<DateTime, TransactionSummary> transactions = {};

  TransactionSummary totalIncome = TransactionSummary.Zero();

  @override
  void initState() {
    transactions = GetIt.I<TransactionSummaryCubit>()
        .getDailyTransactions();

    totalIncome = GetIt.I<TransactionSummaryCubit>()
        .totalSummary();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionSummaryCubit, TransactionSummaryState>(
  listener: (context, state) {
    transactions = GetIt.I<TransactionSummaryCubit>()
        .getDailyTransactions();

    totalIncome = GetIt.I<TransactionSummaryCubit>()
        .totalSummary();
  },
  builder: (context, state) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios, size: 16)),
        ),
        body: Column(
          children: [
            DriverSelectorRow(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1, color: AppColors.black)),
                child: TabBar(
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black,
                  ),
                  labelColor: Colors.white,
                  labelStyle: AppTextStyles.whiteSize12,
                  unselectedLabelColor: Colors.black,
                  unselectedLabelStyle: AppTextStyles.blackSize12,
                  tabs: const [
                    Tab(
                      height: 35,
                      text: 'Recent',
                    ),
                    Tab(
                      height: 35,
                      text: 'All time',
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(kDefaultSpacing),
                child: TabBarView(
                  children: [
                    Builder(builder: (context) {
                      if (transactions.isEmpty) {
                        return const EmptyResultWidget(
                          text: 'No transactions',
                        );
                      } else if (transactions.length == 1 &&
                          transactions[transactions.keys.first]!
                              .transactions
                              .isEmpty) {
                        return const EmptyResultWidget(
                          text: 'No transactions',
                        );
                      } else {
                        return ListView.separated(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (c, i) {
                              DateTime date = transactions.keys.toList()[i];
                              String day = "";
                              if (areDatesEqual(DateTime.now(), date)) {
                                day = "Today";
                              } else if (areDatesEqual(
                                  DateTime.now()
                                      .subtract(const Duration(days: 1)),
                                  date)) {
                                day = "Yesterday";
                              } else {
                                day = DateFormat(
                                        "${DateFormat.ABBR_WEEKDAY}, ${DateFormat.DAY} ${DateFormat.MONTH} ${DateFormat.YEAR}")
                                    .format(date);
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    day,
                                    style:
                                        kBoldTextStyle2.copyWith(fontSize: 13),
                                  ),
                                  kVerticalSpaceSmall,
                                  TransactionSummaryBuilder(
                                      transactionSummary: transactions[date]!)
                                ],
                              );
                            },
                            separatorBuilder: (_, __) => kVerticalSpaceRegular,
                            itemCount: transactions.length);
                      }
                    },),
                    Column(
                      children: [
                        RecordCard(
                          title: "N${totalIncome.amount.toMoney}",
                          subtitle: "Total Income",
                          width: Get.width * 0.9,
                          titleStyle: kDefaultTextStyle.copyWith(
                            color: kGreenColor
                          ),
                          subtitleStyle: const TextStyle(),
                          transactions: totalIncome.transactions,
                        ),
                        kVerticalSpaceSmall,
                        RecordCard(
                          title: totalIncome.trips.toString(),
                          subtitle: "Total Trips",
                          width: Get.width * 0.9,
                          titleStyle: TextStyle(),
                          subtitleStyle: TextStyle(),
                          transactions: totalIncome.transactions,
                        ),
                        kVerticalSpaceSmall,
                        RecordCard(
                          title: totalIncome.expenses.toString(),
                          subtitle: "Total Expenses",
                          width: Get.width * 0.9,
                          titleStyle: TextStyle(),
                          subtitleStyle: TextStyle(),
                          transactions: totalIncome.transactions,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  },
);
  }
}
