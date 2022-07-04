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

  List<String> timeIntervals = ["Daily", "Monthly"];
  var selectedInterval = "Daily";

  TransactionSummary totalIncome = TransactionSummary.Zero();

  @override
  void initState() {
    transactions = GetIt.I<TransactionSummaryCubit>().getDailyTransactions();

    totalIncome = GetIt.I<TransactionSummaryCubit>().totalSummary();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionSummaryCubit, TransactionSummaryState>(
      listener: (context, state) {
        transactions =
            GetIt.I<TransactionSummaryCubit>().getDailyTransactions();

        totalIncome = GetIt.I<TransactionSummaryCubit>().totalSummary();
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DriverSelectorRow(),
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
                kVerticalSpaceRegular,
                Container(
                  margin: EdgeInsets.symmetric(horizontal: kDefaultSpacing),
                  width: Get.width,
                  padding: EdgeInsets.all(kDefaultSpacing * 0.5),
                  decoration: BoxDecoration(
                    color: kLightGrayColor,
                    borderRadius: BorderRadius.circular(kDefaultSpacing * 0.5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isDense: true,
                      isExpanded: true,
                      value: selectedInterval,
                      items: timeIntervals
                          .map((e) => DropdownMenuItem(
                                child: Text(
                                  e,
                                  style:
                                      kDefaultTextStyle.copyWith(fontSize: 14),
                                ),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (String? value) {
                        selectedInterval = value ?? selectedInterval;
                        setState(() {});
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(kDefaultSpacing),
                    child: TabBarView(
                      children: [
                        Builder(
                          builder: (context) {
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
                                    DateTime date =
                                        transactions.keys.toList()[i];
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          day,
                                          style: kBoldTextStyle2.copyWith(
                                              fontSize: 13),
                                        ),
                                        kVerticalSpaceSmall,
                                        TransactionSummaryBuilder(
                                            transactionSummary:
                                                transactions[date]!)
                                      ],
                                    );
                                  },
                                  separatorBuilder: (_, __) =>
                                      kVerticalSpaceRegular,
                                  itemCount: transactions.length);
                            }
                          },
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RecordCard(
                              centerAlign: false,
                              title: "N${totalIncome.income.toMoney}",
                              subtitle: "Total Income",
                              width: Get.width * 0.9,
                              titleStyle: AppTextStyles.blackSize16,
                              subtitleStyle: const TextStyle(),
                              transactions: totalIncome.transactions,
                            ),
                            kVerticalSpaceSmall,
                            RecordCard(
                              centerAlign: false,
                              title: "${totalIncome.tripAmount == 0?"": "+"}N${totalIncome.tripAmount.toMoney}",
                              subtitle: "Total Trips",
                              width: Get.width * 0.9,
                              titleStyle: AppTextStyles.greenSize16,
                              subtitleStyle: const TextStyle(),
                              transactions: totalIncome.transactions,
                            ),
                            kVerticalSpaceSmall,
                            RecordCard(
                              centerAlign: false,
                              title: "${totalIncome.expenseAmount == 0?"": "-"}N${totalIncome.expenseAmount.toMoney}",
                              subtitle: "Total Expenses",
                              width: Get.width * 0.9,
                              titleStyle: AppTextStyles.redSize16,
                              subtitleStyle: const TextStyle(),
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
