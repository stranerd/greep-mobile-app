import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/application/transactions/response/transaction_summary.dart';
import 'package:greep/commons/money.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/transaction/transaction.dart';
import 'package:greep/presentation/driver_section/statistics/top_customers.dart';
import 'package:greep/presentation/driver_section/statistics/widgets/transaction_statistics_summary_card.dart';
import 'package:greep/presentation/driver_section/widgets/chart_transaction_indicator.dart';
import 'package:greep/presentation/driver_section/widgets/transaction_history.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';
import 'package:intl/intl.dart';

class MonthlyTransactionsStatisticsCard extends StatefulWidget {
  final Map<DateTime, TransactionSummary> summary;

  const MonthlyTransactionsStatisticsCard({Key? key, required this.summary})
      : super(key: key);

  @override
  State<MonthlyTransactionsStatisticsCard> createState() =>
      _MonthlyTransactionsStatisticsCardState();
}

class _MonthlyTransactionsStatisticsCardState
    extends State<MonthlyTransactionsStatisticsCard> {
  late PageController _controller;
  bool isTouched = false;
  int touchedIndex = -1;
  String selectedMonth = "";
  int selectedYear = DateTime.now().year;

  String touchedType = "";

  List<int> years = [];

  List<String> months = [];

  List<DateTime> availableMonths = [];

  Map<DateTime, TransactionSummary> monthlySummaries = {};

  TransactionSummary? selectedSummary;

  int pageIndex = 0;

  num highestAmount = 0;

  @override
  void initState() {
    _controller = PageController(initialPage: pageIndex)
      ..addListener(() {
        setState(() {
          pageIndex = _controller.page?.toInt() ?? pageIndex;
        });
      });

    super.initState();
  }

  @override
  void didUpdateWidget(MonthlyTransactionsStatisticsCard oldWidget) {
    // print("did update widget");
    years = widget.summary.keys.map((e) => e.year).toSet().toList();
    selectedYear = years.first;
    generateAvailableMonths();
    selectedMonth =
        DateFormat(DateFormat.MONTH).format(DateTime.now());
    touchedIndex = availableMonths.indexWhere((element) => DateTime.now().year == element.year && DateTime.now().month == element.month);
    if (touchedIndex > 6) {
      pageIndex = 1;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // print("Did change dependencies");
    years = widget.summary.keys.map((e) => e.year).toSet().toList();
    selectedYear = years.first;
    generateAvailableMonths();
    selectedMonth =
        DateFormat(DateFormat.MONTH).format(DateTime.now());
    touchedIndex = availableMonths.indexWhere((element) => DateTime.now().year == element.year && DateTime.now().month == element.month);

    if (touchedIndex > 6) {
      pageIndex = 1;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(color: kWhiteColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                selectedMonth,
                weight: FontWeight.bold,
                fontSize: 14.sp,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      selectedYear = selectedYear - 1;

                      generateAvailableMonths();
                      setState(() {});
                    },
                    child: SvgPicture.asset(
                      "assets/icons/arrowleft.svg",
                      width: 24.w,
                    ),
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  Builder(builder: (context) {
                    return TextWidget(selectedYear.toString());
                  }),
                  SizedBox(
                    width: 3.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      selectedYear = selectedYear + 1;

                      generateAvailableMonths();
                      setState(() {});
                    },
                    child: SvgPicture.asset(
                      "assets/icons/arrowright.svg",
                      width: 24.w,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        kVerticalSpaceRegular,
        LayoutBuilder(builder: (context, constraints) {
          List<BarChartGroupData> barGroups = [];

          for (int i = 0; i < monthlySummaries.length; i++) {
            TransactionSummary summary =
                monthlySummaries[monthlySummaries.keys.toList()[i]]!;
            num sum = summary.tripAmount.abs() + summary.expenseAmount.abs();
            double total =
                ((highestAmount == 0 ? 0 : (sum) / highestAmount) * 100);
            // double trip = ((sum == 0 ? 0: (summary.tripAmount.abs() - (summary.income <=0 ? 0 : summary.income))/sum) * 100 *(total/100));
            double trip = ((summary.tripAmount == 0
                    ? 0
                    : summary.tripAmount <= 0
                        ? 0
                        : summary.tripAmount.abs() / (sum)) *
                100 *
                (total / 100));
            double expense =
                ((sum == 0 ? 0 : summary.expenseAmount.abs() / sum) *
                    100 *
                    (total / 100));
            double income = ((sum == 0
                    ? 0
                    : summary.income <= 0
                        ? 0
                        : summary.income.abs() / (sum)) *
                100 *
                (total / 100));

            // print("Date: "
            //     "summary: $summary\n"
            //     "highest: $highestAmount,\n"
            //     "summaryAmount: ${summary.tripAmount.abs()}\n"
            //     "total: $total,\n"
            //     "expense: $expense,\n"
            //     "income: $income,\n"
            //     "trip: $trip,\n"
            //     "tochedIndex: $touchedIndex $i \n");
            barGroups.add(
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: 0 + 1,
                    color: touchedIndex == i
                        ? AppColors.coinGold
                        : const Color(0xffDDDFE2),
                    width: Get.width * 0.10 * 0.2,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  BarChartRodData(
                    toY: income + 1,
                    color: touchedIndex == i
                        ? AppColors.green
                        : const Color(0xffDDDFE2),
                    width: Get.width * 0.1 * 0.2,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  BarChartRodData(
                    toY: trip + 1,
                    color: touchedIndex == i
                        ? AppColors.blue
                        : const Color(0xffDDDFE2),
                    width: Get.width * 0.1 * 0.2,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  BarChartRodData(
                    toY: expense + 1,
                    color: touchedIndex == i
                        ? AppColors.red
                        : const Color(0xffDDDFE2),
                    width: Get.width * 0.1 * 0.2,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  BarChartRodData(
                    toY: 0 + 1,
                    color: touchedIndex == i
                        ? AppColors.blueGreen
                        : const Color(0xffDDDFE2),
                    width: Get.width * 0.1 * 0.2,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ],
                showingTooltipIndicators: [],
              ),
            );
          }

          var selectedBarGroups = pageIndex == 0
              ? barGroups.take(6).toList()
              : barGroups.sublist(6, barGroups.length);
          // print("Selected Bar Groups ${selectedBarGroups}");
          BarChartData sectionData = BarChartData(
            barGroups: selectedBarGroups,
            alignment: BarChartAlignment.spaceBetween,
            barTouchData: BarTouchData(
              enabled: true,
              allowTouchBarBackDraw: false,
              touchCallback: (FlTouchEvent event, barTouchResponse) {
                if (!event.isInterestedForInteractions ||
                    barTouchResponse == null ||
                    barTouchResponse.spot == null) {
                  // touchedIndex = -1;
                  return;
                } else {
                  setState(() {
                    touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex +
                        (pageIndex == 0 ? 0 : 6);

                    selectedMonth = DateFormat(DateFormat.MONTH)
                        .format(availableMonths[touchedIndex]);
                  });
                }
              },
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.transparent,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    ' ',
                    TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                      reservedSize: 32.h,
                      showTitles: true,
                      getTitlesWidget: (n, medata) {
                        String month = "";
                        switch (n.toInt()) {
                          case 0:
                            month = "Jan";
                            break;
                          case 1:
                            month = "Feb";
                            break;
                          case 2:
                            month = "Mar";
                            break;
                          case 3:
                            month = "Apr";
                            break;
                          case 4:
                            month = "May";
                            break;
                          case 5:
                            month = "June";
                            break;
                          case 6:
                            month = "Jul";
                            break;
                          case 7:
                            month = "Aug";
                            break;
                          case 8:
                            month = "Sep";
                            break;
                          case 9:
                            month = "Oct";
                            break;
                          case 10:
                            month = "Nov";
                            break;
                          case 11:
                            month = "Dec";
                            break;
                          default:
                            month = "Jan";
                        }

                        return Column(
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            TextWidget(
                              month,
                              fontSize: 12.sp,
                              weight:
                                  touchedIndex == n ? FontWeight.bold : null,
                            ),
                          ],
                        );
                      })),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
            ),
            gridData: FlGridData(
              show: false,
            ),
            borderData: FlBorderData(
              show: false,
            ),
          );
          return Container(
            alignment: Alignment.center,
            height: 112.h,
            width: 1.sw,
            child: PageView(
              controller: _controller,
              children: [
                Stack(
                  children: [
                    Positioned.fill(
                      child: BarChart(sectionData),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    Positioned.fill(
                      child: BarChart(sectionData),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
        kVerticalSpaceRegular,
        Builder(builder: (context) {
          List<Transaction> transactions2 = touchedIndex == -1
              ? []
              : monthlySummaries[monthlySummaries.keys.toList()[touchedIndex]]
                      ?.transactions ??
                  [];
          num expenses = touchedIndex == -1
              ? 0
              : monthlySummaries[monthlySummaries.keys.toList()[touchedIndex]]
                      ?.expenseAmount ??
                  0;

          num trips = touchedIndex == -1
              ? 0
              : monthlySummaries[monthlySummaries.keys.toList()[touchedIndex]]
                      ?.tripAmount ??
                  0;

          var income =
              monthlySummaries[monthlySummaries.keys.toList()[touchedIndex]]
                      ?.income ??
                  0;

          return Column(
            children: [
              TransactionStatisticsSummaryCard(
                target: 0,
                income: income,
                trips: trips,
                expenses: expenses,
                withdrawals: 0,
              ),
              SizedBox(
                height: 16.h,
              ),
              TopCustomersView(
                transactions: transactions2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TransactionHistorySection(
                  transactions: transactions2,
                  withTransaction: true,
                ),
              )
            ],
          );
        })
      ],
    );
  }

  void generateAvailableMonths() {
    availableMonths = List.generate(12, (index) {
      return DateTime(selectedYear, index + 1);
    });
    calculateSummaries();
  }

  void calculateSummaries() {
    monthlySummaries.clear();
    availableMonths.forEach((element) {
      if (widget.summary.keys
          .any((e) => element.month == e.month && element.year == e.year)) {
        monthlySummaries.putIfAbsent(element, () {
          var transactionSummary = widget.summary[widget.summary.keys
              .firstWhere(
                  (e) => element.month == e.month && element.year == e.year)]!;
          highestAmount = (transactionSummary.tripAmount +
                      transactionSummary.expenseAmount) >
                  highestAmount
              ? transactionSummary.tripAmount + transactionSummary.expenseAmount
              : highestAmount;
          return transactionSummary;
        });
      } else {
        monthlySummaries.putIfAbsent(element, () => TransactionSummary.Zero());
      }
    });

    // print("monthly Summaries ${monthlySummaries}");
  }
}
