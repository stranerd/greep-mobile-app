import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:greep/application/transactions/user_transactions_cubit.dart';
import 'package:greep/application/user/utils/get_current_user.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' as g;
import 'package:get_it/get_it.dart';
import 'package:greep/application/transactions/response/transaction_summary.dart';
import 'package:greep/application/transactions/transaction_summary_cubit.dart';
import 'package:greep/application/driver/drivers_cubit.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/money.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/transaction/transaction.dart';
import 'package:greep/presentation/driver_section/records/view_records.dart';
import 'package:greep/presentation/driver_section/statistics/all_transactions_statistics_card.dart';
import 'package:greep/presentation/driver_section/statistics/daily_transactions_statistics_card.dart';
import 'package:greep/presentation/driver_section/statistics/monthly_transactions_statistics_card.dart';
import 'package:greep/presentation/driver_section/statistics/top_customers.dart';
import 'package:greep/presentation/driver_section/statistics/weekly_transactions_statistics_card.dart';
import 'package:greep/presentation/driver_section/widgets/empty_result_widget.dart';
import 'package:greep/presentation/driver_section/widgets/transaction_history.dart';
import 'package:greep/presentation/driver_section/widgets/transaction_list_card.dart';
import 'package:greep/presentation/widgets/driver_selector_widget.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/presentation/widgets/turkish_symbol.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_styles.dart';
import '../widgets/transactions_card.dart';
import 'view_range_transactions.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  Map<DateTime, TransactionSummary> transactions = {};

  DateTime? from;
  DateTime? to;
  bool showAppBar = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    var route = ModalRoute.of(context);
    try {
      if (route != null) {
        dynamic args = route.settings.arguments;
        setState(() {
          transactions =
              GetIt.I<TransactionSummaryCubit>().getMonthlyTransactions();
          showAppBar = (args["showAppBar"] == true);
        });
      }
    } catch (_) {}

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuild transaction screen ui");
    return BlocConsumer<TransactionSummaryCubit, TransactionSummaryState>(
        listener: (context, state) {
      if (state is TransactionSummaryStateDone) {
        setState(() {
          transactions =
              GetIt.I<TransactionSummaryCubit>().getMonthlyTransactions();
        });
      }
    }, builder: (context, state) {
      return DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: showAppBar
              ? AppBar(
                  toolbarHeight: 30,
                  automaticallyImplyLeading: true,
                )
              : null,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultSpacing * 0.5,
                  vertical: kDefaultSpacing * 0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: DriverSelectorRow()),
                  kVerticalSpaceSmall,
                  BlocBuilder<DriversCubit, DriversState>(
                    builder: (context, driverState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          driverState is! DriversStateManager
                              ? Align(
                                  alignment: Alignment.center,
                                  child: TextWidget(
                                    'Transactions',
                                    style: AppTextStyles.blackSizeBold16,
                                  ),
                                )
                              : TextWidget(
                                  driverState.selectedUser == currentUser()
                                      ? 'Your transactions'
                                      : "${driverState.selectedUser.firstName} transactions",
                                  style: AppTextStyles.blackSizeBold16,
                                ),
                        ],
                      );
                    },
                  ),
                  kVerticalSpaceSmall,
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kDefaultSpacing),
                      color: const Color(0xffE8EFFD),
                    ),
                    child: TabBar(
                      onTap: (int e) {
                        print(e);
                      },
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(kDefaultSpacing),
                        color: Colors.black,
                      ),
                      labelColor: Colors.white,
                      labelStyle: AppTextStyles.whiteSize12
                          .copyWith(fontWeight: FontWeight.bold),
                      unselectedLabelColor: Colors.black,
                      unselectedLabelStyle: AppTextStyles.blackSize12
                          .copyWith(fontWeight: FontWeight.bold),
                      tabs: const [
                        Tab(
                          height: 35,
                          text: 'Daily',
                        ),
                        Tab(
                          height: 35,
                          text: 'Weekly',
                        ),
                        Tab(
                          height: 35,
                          text: 'Monthly',
                        ),
                        Tab(
                          height: 35,
                          text: 'All',
                        ),
                      ],
                    ),
                  ),
                  kVerticalSpaceRegular,
                  Expanded(
                    child: Container(
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Builder(builder: (context) {
                                  Map<DateTime,TransactionSummary> summary = GetIt.I<
                                      TransactionSummaryCubit>()
                                      .getDailyTransactions();
                                  return DailyTransactionsStatisticsCard(
                                      summary: summary);
                                }),

                              ],
                            ),
                          ),

                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Builder(builder: (context) {
                                  Map<DateTime,TransactionSummary> summary = GetIt.I<
                                      TransactionSummaryCubit>()
                                      .getWeeklyTransactions();
                                  return WeeklyTransactionsStatisticsCard(
                                      summary: summary);
                                }),
                              ],
                            ),
                          ),

                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Builder(builder: (context) {
                                  Map<DateTime,TransactionSummary> summary = GetIt.I<
                                          TransactionSummaryCubit>()
                                      .getMonthlyTransactions();
                                  return MonthlyTransactionsStatisticsCard(
                                      summary: summary);
                                }),

                              ],
                            ),
                          ),
                          Builder(builder: (context) {
                            TransactionSummary summary =
                                GetIt.I<TransactionSummaryCubit>()
                                    .getManagerDriverTotalTransactionSummary();
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  AllTransactionsStatisticsCard(
                                    transactionSummary: summary,
                                  ),
                                  kVerticalSpaceRegular,
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: TransactionHistorySection(),
                                  )
                                ],
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
