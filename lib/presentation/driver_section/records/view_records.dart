import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/transactions/response/transaction_summary.dart';
import 'package:grip/application/transactions/transaction_summary_cubit.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/commons/Utils/utils.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/presentation/driver_section/widgets/empty_result_widget.dart';
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

  @override
  void initState() {
    transactions = GetIt.I<TransactionSummaryCubit>()
        .getDailyTransactions(GetIt.I<UserCubit>().userId!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      text: 'Recent',
                    ),
                    Tab(
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
                          text: 'You have no transactions',
                        );
                      } else if (transactions.length == 1 &&
                          transactions[transactions.keys.first]!
                              .transactions
                              .isEmpty) {
                        return const EmptyResultWidget(
                          text: 'You have no transactions',
                        );
                      } else {
                        return ListView.separated(
                          shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (c,i){
                              DateTime date = transactions.keys.toList()[i];
                              String day = "";
                              if (areDatesEqual(DateTime.now(),date)){
                                day = "Today";
                              }
                              else if (areDatesEqual(DateTime.now().subtract(const Duration(days: 1)),date)){
                                day = "Yesterday";
                              }
                              else {
                                day = DateFormat("${DateFormat.ABBR_WEEKDAY}, ${DateFormat.DAY} ${DateFormat.MONTH} ${DateFormat.YEAR}").format(date);
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(day, style: kBoldTextStyle.copyWith(
                                    fontSize: 14
                                  ),),
                                  kVerticalSpaceSmall,
                                  TransactionSummaryBuilder(transactionSummary: transactions[date]!)
                                ],
                              );
                            },
                            separatorBuilder: (_,__)=>kVerticalSpaceSmall,
                            itemCount: transactions.length);
                      }
                    }),
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 1.0,
                              color: AppColors.lightGray,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("\$126580",
                                  style: AppTextStyles.greenSize16),
                              const SizedBox(
                                height: 4.0,
                              ),
                              Text("Total Income",
                                  style: AppTextStyles.blackSize12),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 1.0,
                              color: AppColors.lightGray,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("9842", style: AppTextStyles.blackSize16),
                              const SizedBox(
                                height: 4.0,
                              ),
                              Text("Total Trips",
                                  style: AppTextStyles.blackSize12),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 1.0,
                              color: AppColors.lightGray,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("942", style: AppTextStyles.blackSize16),
                              const SizedBox(
                                height: 4.0,
                              ),
                              Text("Total Expenses",
                                  style: AppTextStyles.blackSize12),
                            ],
                          ),
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
  }
}
