import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as g;
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:greep/application/transactions/response/transaction_summary.dart';
import 'package:greep/application/transactions/transaction_summary_cubit.dart';
import 'package:greep/commons/Utils/utils.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/money.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/ioc.dart';
import 'package:greep/presentation/driver_section/records/views/date_range_view.dart';
import 'package:greep/presentation/driver_section/widgets/empty_result_widget.dart';
import 'package:greep/presentation/driver_section/widgets/transaction_list_card.dart';
import 'package:greep/presentation/driver_section/widgets/transactions_card.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/button_filter_widget.dart';
import 'package:greep/presentation/widgets/driver_selector_widget.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/presentation/widgets/turkish_symbol.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_styles.dart';

class ViewAllRecords extends StatefulWidget {
  const ViewAllRecords({Key? key}) : super(key: key);

  @override
  State<ViewAllRecords> createState() => _ViewAllRecordsState();
}

class _ViewAllRecordsState extends State<ViewAllRecords> {
  Map<DateTime, TransactionSummary> transactions = {};

  List<String> timeIntervals = ["Daily", "Monthly"];
  var selectedInterval = "Monthly";
  DateTime? from;
  DateTime? to;

  String selectedFilterType = "all";

  TransactionSummary totalIncome = TransactionSummary.Zero();

  late TransactionSummaryCubit transactionSummaryCubit;

  @override
  void initState() {
    transactionSummaryCubit = getIt();
    transactions = transactionSummaryCubit.getMonthlyTransactions();

    totalIncome = transactionSummaryCubit.totalSummary();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionSummaryCubit, TransactionSummaryState>(
      listener: (context, state) {
        transactions = transactionSummaryCubit.getMonthlyTransactions(
            filter: selectedFilterType, from: from, to: to,);

        totalIncome = transactionSummaryCubit.totalSummary();
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.0,
            title: TextWidget(
              "Transaction history",
              weight: FontWeight.bold,
              fontSize: 18.sp,
            ),
            backgroundColor: Colors.white,
            leading: const BackIcon(
              isArrow: true,
            ),
          ),
          body: Container(
            padding: EdgeInsets.all(kDefaultSpacing.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DriverSelectorRow(),
                SizedBox(
                  height: 16.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: kDefaultSpacing.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      12.r,
                    ),
                    border:
                        Border.all(color: const Color(0xFFE0E2E4), width: 2),
                  ),
                  height: 50.h,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/search.svg",
                        width: 24.r,
                        height: 24.r,
                      ),
                      Expanded(
                        child: TextField(
                          onChanged: (s) {},
                          style: kDefaultTextStyle.copyWith(
                            fontSize: 15.sp,
                          ),
                          decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.only(
                                  left: 12.w,
                                  top: 8.h,
                                  bottom: 8.h,
                                  right: 12.w),
                              hintText: "Search",
                              border: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                      VerticalDivider(
                        width: 2.w,
                        color: AppColors.veryLightGray,
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return DateRangeView(
                                    onSelectedDate: (from, to) {
                                  Get.back();
                                  this.to = to;
                                  this.from = from;

                                  transactions = transactionSummaryCubit
                                      .getMonthlyTransactions(
                                    filter: selectedFilterType,
                                    from: from,
                                    to: to,
                                  );
                                  setState(() {});
                                });
                              });
                        },
                        child: Row(
                          children: [
                            TextWidget(
                              "Range",
                              color: AppColors.veryLightGray,
                              fontSize: 14.sp,
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            SvgPicture.asset(
                              "assets/icons/range.svg",
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
                SizedBox(
                  height: 35.h,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      ButtonFilterWidget(
                          onTap: () {
                            selectedFilterType = "all";

                            transactions = transactionSummaryCubit
                                .getMonthlyTransactions(filter: "",from: from, to: to,);
                            setState(() {});
                          },
                          isActive: selectedFilterType == "all",
                          text: "All"),
                      SizedBox(
                        width: 12.w,
                      ),
                      if (from != null && to != null)
                        Row(
                          children: [
                            ButtonFilterWidget(
                                onTap: () {},
                                onCancel: () {
                                  from = null;
                                  to = null;
                                  transactions = transactionSummaryCubit
                                      .getMonthlyTransactions(
                                          filter: selectedFilterType,from: from, to: to,);
                                  setState(() {});
                                },
                                withCancel: true,
                                isActive: true,
                                text:
                                    "${DateFormat("${DateFormat.DAY} ${DateFormat.ABBR_MONTH}").format(from!)} - ${DateFormat("${DateFormat.DAY} ${DateFormat.ABBR_MONTH}").format(to!)}"),
                            SizedBox(
                              width: 12.w,
                            ),
                          ],
                        ),
                      ButtonFilterWidget(
                          onTap: () {
                            selectedFilterType = "trips";

                            transactions =
                                transactionSummaryCubit.getMonthlyTransactions(
                                    filter: selectedFilterType,from: from, to: to,);
                            setState(() {});
                          },
                          isActive: selectedFilterType == "trips",
                          text: "Trips"),
                      SizedBox(
                        width: 12.w,
                      ),
                      ButtonFilterWidget(
                          onTap: () {
                            selectedFilterType = "expenses";

                            transactions =
                                transactionSummaryCubit.getMonthlyTransactions(
                                    filter: selectedFilterType,from: from, to: to,);
                            setState(() {});
                          },
                          isActive: selectedFilterType == "expenses",
                          text: "Expenses"),
                      SizedBox(
                        width: 12.w,
                      ),
                      ButtonFilterWidget(
                          onTap: () {
                            selectedFilterType = "withdrawals";
                            transactions =
                                transactionSummaryCubit.getMonthlyTransactions(
                                    filter: selectedFilterType,from: from, to: to,);
                            setState(() {});
                          },
                          isActive: selectedFilterType == "withdrawals",
                          text: "Withdrawals"),
                      SizedBox(
                        width: 12.w,
                      ),
                      ButtonFilterWidget(
                          onTap: () {
                            selectedFilterType = "cash";

                            transactions =
                                transactionSummaryCubit.getMonthlyTransactions(
                                    filter: selectedFilterType,from: from, to: to,);
                            setState(() {});
                          },
                          isActive: selectedFilterType == "cash",
                          text: "Cash"),
                      SizedBox(
                        width: 12.w,
                      ),
                      ButtonFilterWidget(
                          onTap: () {
                            selectedFilterType = "wallet";
                            transactions =
                                transactionSummaryCubit.getMonthlyTransactions(
                                    filter: selectedFilterType,from: from, to: to,);
                            setState(() {});
                          },
                          isActive: selectedFilterType == "wallet",
                          text: "Wallet"),
                      SizedBox(
                        width: 12.w,
                      ),
                      ButtonFilterWidget(
                          onTap: () {
                            selectedFilterType = "manual";

                            transactions =
                                transactionSummaryCubit.getMonthlyTransactions(
                                    filter: selectedFilterType,from: from, to: to,);
                            setState(() {});
                          },
                          isActive: selectedFilterType == "manual",
                          text: "Manual"),
                      SizedBox(
                        width: 12.w,
                      ),
                      ButtonFilterWidget(
                          onTap: () {
                            selectedFilterType = "automatic";

                            transactions =
                                transactionSummaryCubit.getMonthlyTransactions(
                                    filter: selectedFilterType,from: from, to: to,);
                            setState(() {});
                          },
                          isActive: selectedFilterType == "automatic",
                          text: "Automatic"),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
                Expanded(
                  child: Builder(
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
                            Expanded(
                              child: ListView.separated(
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
                                        Container(
                                          decoration: BoxDecoration(
                                              // color: AppColors.red
                                              ),
                                          height: 22.h,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextWidget(
                                                day,
                                                fontSize: 14.sp,
                                                weight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  // scrollDirection: Axis.horizontal,
                                                  //
                                                  // physics: const ScrollPhysics(),
                                                  // shrinkWrap: true,
                                                  children: [
                                                    SizedBox(
                                                      width: 16.w,
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        TextWidget(
                                                          "Inc: ",
                                                          fontSize: 12.sp,
                                                          color: AppColors
                                                              .veryLightGray,
                                                        ),
                                                        const TurkishSymbol(
                                                          width: 8,
                                                          height: 8,
                                                          color:
                                                              AppColors.green,
                                                        ),
                                                        TextWidget(
                                                          transactions[date]!
                                                              .income
                                                              .toMoney,
                                                          fontSize: 12.sp,
                                                          color:
                                                              AppColors.green,
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 8.w,
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        TextWidget(
                                                          "Trips: ${transactions[date]!.tripAmount == 0 ? "" : "+"}",
                                                          fontSize: 12.sp,
                                                        ),
                                                        const TurkishSymbol(
                                                          width: 8,
                                                          height: 8,
                                                        ),
                                                        TextWidget(
                                                          transactions[date]!
                                                              .tripAmount
                                                              .toMoney,
                                                          fontSize: 12.sp,
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 8.w,
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        TextWidget(
                                                          "Exp: ${transactions[date]!.expenseAmount == 0 ? "" : "-"}",
                                                          color: AppColors.red,
                                                          fontSize: 12.sp,
                                                        ),
                                                        const TurkishSymbol(
                                                          width: 8,
                                                          height: 8,
                                                          color: AppColors.red,
                                                        ),
                                                        TextWidget(
                                                          transactions[date]!
                                                              .expenseAmount
                                                              .toMoney,
                                                          fontSize: 12.sp,
                                                          color: AppColors.red,
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        kVerticalSpaceSmall,
                                        ListView.separated(
                                          separatorBuilder: (_, __) => SizedBox(
                                            height: 12.h,
                                          ),
                                          shrinkWrap: true,
                                          itemBuilder: (c, i) =>
                                              TransactionListCard(
                                            transaction: transactions[date]!
                                                .transactions[i],
                                            withLeading: true,
                                          ),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: transactions[date]!
                                              .transactions
                                              .length,
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
