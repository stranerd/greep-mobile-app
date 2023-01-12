import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' as g;
import 'package:get_it/get_it.dart';
import 'package:greep/application/transactions/response/transaction_summary.dart';
import 'package:greep/application/transactions/transaction_summary_cubit.dart';
import 'package:greep/application/user/user_cubit.dart';
import 'package:greep/application/user/utils/get_current_user.dart';
import 'package:greep/commons/Utils/utils.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/money.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/driver_section/transaction/view_range_transactions.dart';
import 'package:greep/presentation/driver_section/widgets/empty_result_widget.dart';
import 'package:greep/presentation/driver_section/widgets/transactions_card.dart';
import 'package:greep/presentation/widgets/driver_selector_widget.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/presentation/widgets/transaction_summary_builder.dart';
import 'package:greep/presentation/widgets/turkish_symbol.dart';
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

  DateTime? from;
  DateTime? to;

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
                    g.Get.back();
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
                          text: 'Range',
                        ),
                      ],
                    ),
                  ),
                ),
                kVerticalSpaceSmall,

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
                              return Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: kDefaultSpacing * 0.5),
                                    alignment: Alignment.centerRight,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Filter",
                                          style: kDefaultTextStyle,
                                        ),
                                        kHorizontalSpaceTiny,
                                        const Icon(Icons.sort),
                                      ],
                                    ),
                                  ),
                                  kVerticalSpaceSmall,
                                  Container(
                                    margin:
                                    const EdgeInsets.symmetric(horizontal: kDefaultSpacing),
                                    width: g.Get.width,
                                    padding: const EdgeInsets.all(kDefaultSpacing * 0.75),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: kLightGrayColor,
                                      ),
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
                                          if (selectedInterval.toLowerCase() == "daily") {
                                            transactions = GetIt.I<TransactionSummaryCubit>()
                                                .getDailyTransactions();
                                          } else if (selectedInterval.toLowerCase() ==
                                              "monthly") {
                                            transactions = GetIt.I<TransactionSummaryCubit>()
                                                .getMonthlyTransactions();
                                          }

                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                  kVerticalSpaceRegular,
                                  Expanded(
                                    child: ListView.separated(
                                        shrinkWrap: false,
                                        physics: const ScrollPhysics(),
                                        itemBuilder: (c, i) {
                                          DateTime date =
                                              transactions.keys.toList()[i];
                                          String day = "";
                                          if (selectedInterval.toLowerCase() ==
                                              "daily") {
                                            if (areDatesEqual(DateTime.now(), date)) {
                                              day = "Today";
                                            } else if (areDatesEqual(
                                                DateTime.now().subtract(
                                                    const Duration(days: 1)),
                                                date)) {
                                              day = "Yesterday";
                                            } else {
                                              day = DateFormat(
                                                      "${DateFormat.ABBR_WEEKDAY}, ${DateFormat.DAY} ${DateFormat.MONTH} ${DateFormat.YEAR}")
                                                  .format(date);
                                            }
                                          } else if (selectedInterval.toLowerCase() ==
                                              "monthly") {
                                            day = DateFormat(
                                                    "${DateFormat.ABBR_MONTH} ${DateFormat.YEAR}")
                                                .format(date);
                                          }
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 30,
                                                child: ListView(
                                                  scrollDirection: Axis.horizontal,
                                                  physics: const ScrollPhysics(),
                                                  shrinkWrap: true,
                                                  children: [
                                                    Text(
                                                      day,
                                                      style: kBoldTextStyle2.copyWith(
                                                          fontSize: 13),
                                                    ),
                                                    kHorizontalSpaceRegular,
                                                    Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          "Income: ",
                                                          style: AppTextStyles
                                                              .blackSize10,
                                                        ),
                                                        TurkishSymbol(
                                                          width: 8,
                                                          height: 8,
                                                          color: AppTextStyles
                                                              .blackSize10.color,
                                                        ),
                                                        Text(
                                                          transactions[date]!
                                                              .income
                                                              .toMoney,
                                                          style: AppTextStyles
                                                              .blackSize10,
                                                        )
                                                      ],
                                                    ),
                                                    kHorizontalSpaceRegular,
                                                    Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          "Trips: ${transactions[date]!.tripAmount == 0 ? "" : "+"}",
                                                          style: AppTextStyles
                                                              .greenSize10,
                                                        ),
                                                        TurkishSymbol(
                                                          width: 8,
                                                          height: 8,
                                                          color: AppTextStyles
                                                              .greenSize10.color,
                                                        ),
                                                        Text(
                                                          transactions[date]!
                                                              .tripAmount
                                                              .toMoney,
                                                          style: AppTextStyles
                                                              .greenSize10,
                                                        )
                                                      ],
                                                    ),
                                                    kHorizontalSpaceRegular,
                                                    Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          "Expenses: ${transactions[date]!.expenseAmount == 0 ? "" : "-"}",
                                                          style:
                                                              AppTextStyles.redSize10,
                                                        ),
                                                        TurkishSymbol(
                                                          width: 8,
                                                          height: 8,
                                                          color: AppTextStyles
                                                              .redSize10.color,
                                                        ),
                                                        Text(
                                                          transactions[date]!
                                                              .expenseAmount
                                                              .toMoney,
                                                          style:
                                                              AppTextStyles.redSize10,
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              kVerticalSpaceSmall,
                                              ListView(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                children: transactions[date]!
                                                    .transactions
                                                    .map((e) {
                                                  return TransactionCard(
                                                    transaction: e,
                                                    withBigAmount: false,
                                                    subTrailingStyle:
                                                        AppTextStyles.blackSize12,
                                                    titleStyle:
                                                        AppTextStyles.blackSize14,
                                                    subtitleStyle:
                                                        AppTextStyles.blackSize12,
                                                    trailingStyle:
                                                        AppTextStyles.greenSize14,
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          );
                                        },
                                        separatorBuilder: (_, __) =>
                                            kVerticalSpaceRegular,
                                        itemCount: transactions.length),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        "From",
                                        style: AppTextStyles.blackSize14,
                                      ),
                                      kVerticalSpaceSmall,
                                      GestureDetector(
                                        onTap: () => _pickDate(true),
                                        child: Container(
                                          width: 150.w,
                                          padding: const EdgeInsets.fromLTRB(
                                              16, 16, 16, 16),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: AppColors.lightGray,
                                          ),
                                          child: TextWidget(
                                            from == null
                                                ? "Select Date..."
                                                : DateFormat(
                                                        "${DateFormat.DAY}/${DateFormat.MONTH}/${DateFormat.YEAR} ")
                                                    .format(from!),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTextStyles.blackSize14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 16.0,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        "To",
                                        style: AppTextStyles.blackSize14,
                                      ),
                                      kVerticalSpaceSmall,
                                      SplashTap(
                                        onTap: () => _pickDate(false),
                                        child: Container(
                                          width: 150.w,
                                          padding: const EdgeInsets.fromLTRB(
                                              16, 16, 16, 16),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: AppColors.lightGray,
                                          ),
                                          child: TextWidget(
                                            to == null
                                                ? "Select Date..."
                                                : DateFormat(
                                                        "${DateFormat.DAY}/${DateFormat.MONTH}/${DateFormat.YEAR} ")
                                                    .format(to!),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,

                                            style: AppTextStyles.blackSize14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            SubmitButton(
                                text: "Show Transactions",
                                backgroundColor: kGreenColor,
                                enabled: from != null && to != null,
                                onSubmit: () {
                                  g.Get.to(
                                      () => RangeTransactionsScreen(
                                            userId: currentUser().id,
                                            from: from!,
                                            to: to!,
                                          ),
                                      transition: g.Transition.fadeIn);
                                }),
                          ],
                        ),
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: [
                        //     RecordCard(
                        //       initial: totalIncome.income < 0 ? "-":"",
                        //       withSymbol: true,
                        //       centerAlign: true,
                        //       title: totalIncome.income.abs().toMoney,
                        //       subtitle: "Total Income",
                        //       width: Get.width * 0.9,
                        //       titleStyle: AppTextStyles.blackSize16,
                        //       subtitleStyle: const TextStyle(),
                        //       transactions: totalIncome.transactions,
                        //     ),
                        //     kVerticalSpaceSmall,
                        //     RecordCard(
                        //       initial:totalIncome.tripAmount == 0?"": "+",
                        //       centerAlign: true,
                        //       withSymbol: true,
                        //
                        //       title: totalIncome.tripAmount.toMoney,
                        //       subtitle: "Total Trips",
                        //       width: Get.width * 0.9,
                        //       titleStyle: AppTextStyles.greenSize16,
                        //       subtitleStyle: const TextStyle(),
                        //       transactions: totalIncome.transactions,
                        //     ),
                        //     kVerticalSpaceSmall,
                        //     RecordCard(
                        //       initial: totalIncome.expenseAmount == 0?"": "-",
                        //       centerAlign: true,
                        //       withSymbol: true,
                        //
                        //       title: totalIncome.expenseAmount.toMoney,
                        //       subtitle: "Total Expenses",
                        //       width: Get.width * 0.9,
                        //       titleStyle: AppTextStyles.redSize16,
                        //       subtitleStyle: const TextStyle(),
                        //       transactions: totalIncome.transactions,
                        //     ),
                        //   ],
                        // ),
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

  void _pickDate(bool isFrom) {
    DatePicker.showDatePicker(context, theme: const DatePickerTheme())
        .then((value) {
      if (value != null) {
        if (isFrom) {
          from = value;
        } else {
          to = value;
        }
        setState(() {});
      }
    });
    // showDatePicker(
    //         context: context,
    //         initialDate: DateTime.now(),
    //         firstDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
    //         lastDate: DateTime.now().add(const Duration(days: 365 * 2)))
    //     .then((value) {
    //   if (value != null) {
    //     if (isFrom) {
    //       from = value;
    //     } else {
    //       to = value;
    //     }
    //     setState(() {});
    //   }
    // });
  }
}
