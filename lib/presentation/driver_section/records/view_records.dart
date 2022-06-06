import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/transactions/response/transaction_summary.dart';
import 'package:grip/application/transactions/transaction_summary_cubit.dart';
import 'package:grip/application/user/user_cubit.dart';

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
        .getRecentTransactions(GetIt.I<UserCubit>().userId!);
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
        body: SingleChildScrollView(
          child: Column(
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
              Container(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 20),
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top,
                child: TabBarView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Today", style: AppTextStyles.blackSizeBold12),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RecordCard(
                              title: "\$164",
                              subtitle: "Income",
                              subtitleStyle: AppTextStyles.blackSize12,
                              titleStyle: AppTextStyles.greenSize16,
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            RecordCard(
                              title: "07",
                              subtitle: "Trips",
                              subtitleStyle: AppTextStyles.blackSize12,
                              titleStyle: AppTextStyles.blackSize16,
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            RecordCard(
                              title: "01",
                              subtitle: "Expenses",
                              subtitleStyle: AppTextStyles.blackSize12,
                              titleStyle: AppTextStyles.blackSize16,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text("Yesterday", style: AppTextStyles.blackSizeBold12),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RecordCard(
                              title: "\$164",
                              subtitle: "Income",
                              subtitleStyle: AppTextStyles.blackSize12,
                              titleStyle: AppTextStyles.greenSize16,
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            RecordCard(
                              title: "07",
                              subtitle: "Trips",
                              subtitleStyle: AppTextStyles.blackSize12,
                              titleStyle: AppTextStyles.blackSize16,
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            RecordCard(
                              title: "01",
                              subtitle: "Expenses",
                              subtitleStyle: AppTextStyles.blackSize12,
                              titleStyle: AppTextStyles.blackSize16,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text("Sat, 2 Apr 2022",
                            style: AppTextStyles.blackSizeBold12),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RecordCard(
                              title: "\$164",
                              subtitle: "Income",
                              subtitleStyle: AppTextStyles.blackSize12,
                              titleStyle: AppTextStyles.greenSize16,
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            RecordCard(
                              title: "07",
                              subtitle: "Trips",
                              subtitleStyle: AppTextStyles.blackSize12,
                              titleStyle: AppTextStyles.blackSize16,
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            RecordCard(
                              title: "01",
                              subtitle: "Expenses",
                              subtitleStyle: AppTextStyles.blackSize12,
                              titleStyle: AppTextStyles.blackSize16,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text("Fri, 1 Apr 2022",
                            style: AppTextStyles.blackSizeBold12),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RecordCard(
                              title: "\$164",
                              subtitle: "Income",
                              subtitleStyle: AppTextStyles.blackSize12,
                              titleStyle: AppTextStyles.greenSize16,
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            RecordCard(
                              title: "07",
                              subtitle: "Trips",
                              subtitleStyle: AppTextStyles.blackSize12,
                              titleStyle: AppTextStyles.blackSize16,
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            RecordCard(
                              title: "01",
                              subtitle: "Expenses",
                              subtitleStyle: AppTextStyles.blackSize12,
                              titleStyle: AppTextStyles.blackSize16,
                            ),
                          ],
                        ),
                      ],
                    ),
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
            ],
          ),
        ),
      ),
    );
  }
}
