import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:greep/application/driver/drivers_cubit.dart';
import 'package:greep/application/transactions/response/transaction_summary.dart';
import 'package:greep/application/transactions/transaction_summary_cubit.dart';
import 'package:greep/application/user/utils/get_current_user.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/driver_section/statistics/all_transactions_statistics_card.dart';
import 'package:greep/presentation/driver_section/statistics/daily_transactions_statistics_card.dart';
import 'package:greep/presentation/driver_section/statistics/monthly_transactions_statistics_card.dart';
import 'package:greep/presentation/driver_section/statistics/weekly_transactions_statistics_card.dart';
import 'package:greep/presentation/driver_section/statistics/yearly_transactions_statistics_card.dart';
import 'package:greep/presentation/driver_section/widgets/transaction_history.dart';
import 'package:greep/presentation/widgets/button_filter_widget.dart';
import 'package:greep/presentation/widgets/custom_appbar.dart';
import 'package:greep/presentation/widgets/driver_selector_widget.dart';
import 'package:greep/presentation/widgets/text_widget.dart';

import '../../../utils/constants/app_styles.dart';

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

  String selectedFilterType = "day";


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
    return BlocConsumer<TransactionSummaryCubit, TransactionSummaryState>(
        listener: (context, state) {
      if (state is TransactionSummaryStateDone) {
        setState(() {
          transactions =
              GetIt.I<TransactionSummaryCubit>().getMonthlyTransactions();
        });
      }
    }, builder: (context, state) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppbar(
          title: 'Transactions',
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: SafeArea(
            child: Padding(
              padding:  EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: kDefaultSpacing * 0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: DriverSelectorRow()),
                  kVerticalSpaceSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Expanded(
                        child: ButtonFilterWidget(
                            onTap: () {
                              setState(() {
                                selectedFilterType = "day";
                              });
                            },
                            isActive:
                                selectedFilterType == "day",
                            text: "Day"),
                      ),
                      SizedBox(width: 12.w,),
                      Expanded(
                        child: ButtonFilterWidget(
                            onTap: () {
                              setState(() {
                                selectedFilterType = "week";
                              });
                            },
                            isActive: selectedFilterType == "week",
                            text: "Week"),
                      ),
                      SizedBox(width: 12.w,),
                      Expanded(
                        child: ButtonFilterWidget(
                            onTap: () {
                              setState(() {
                                selectedFilterType = "month";
                              });
                            },
                            isActive: selectedFilterType == "month",
                            text: "Month"),
                      ),
                      SizedBox(width: 12.w,),
                      Expanded(
                        child: ButtonFilterWidget(
                            onTap: () {
                              setState(() {
                                selectedFilterType = "year";
                              });
                            },
                            isActive: selectedFilterType == "year",
                            text: "Year"),
                      ),
                      SizedBox(width: 12.w,),
                      Expanded(
                        child: ButtonFilterWidget(
                            onTap: () {
                              setState(() {
                                selectedFilterType = "overall";
                              });
                            },
                            isActive: selectedFilterType == "overall",
                            text: "Overall"),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h,),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (selectedFilterType == "day"){
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                Builder(builder: (context) {
                                  Map<DateTime, TransactionSummary> summary =
                                  GetIt.I<TransactionSummaryCubit>()
                                      .getDailyTransactions();
                                  return DailyTransactionsStatisticsCard(
                                      summary: summary);
                                }),
                              ],
                            ),
                          );

                        }
                        else if (selectedFilterType == "week"){
                          return
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  Builder(builder: (context) {
                                    Map<DateTime, TransactionSummary> summary =
                                    GetIt.I<TransactionSummaryCubit>()
                                        .getWeeklyTransactions();
                                    return WeeklyTransactionsStatisticsCard(
                                        summary: summary);
                                  }),
                                ],
                              ),
                            );

                        }
                        else if (selectedFilterType == "month"){
                         return SingleChildScrollView(
                            child: Column(
                              children: [
                                Builder(builder: (context) {
                                  Map<DateTime, TransactionSummary> summary =
                                  GetIt.I<TransactionSummaryCubit>()
                                      .getMonthlyTransactions();
                                  return MonthlyTransactionsStatisticsCard(
                                      summary: summary);
                                }),
                              ],
                            ),
                          );

                        }
                        else if (selectedFilterType == "year"){
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                Builder(builder: (context) {
                                  Map<DateTime, TransactionSummary> summary =
                                  GetIt.I<TransactionSummaryCubit>()
                                      .getYearlyTransactions();
                                  // print("Yearly transatction: ${summary.length}");
                                  return YearlyTransactionsStatisticsCard(
                                      summary: summary);
                                }),
                              ],
                            ),
                          );

                        }
                        else if (selectedFilterType == "overall"){
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
                        }

                        return Container();
                      }
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
