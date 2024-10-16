import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/application/transactions/response/transaction_summary.dart';
import 'package:greep/application/transactions/transaction_summary_cubit.dart';
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

class WeeklyTransactionsStatisticsCard extends StatefulWidget {
  final Map<DateTime, TransactionSummary> summary;

  const WeeklyTransactionsStatisticsCard({Key? key, required this.summary})
      : super(key: key);

  @override
  State<WeeklyTransactionsStatisticsCard> createState() =>
      _WeeklyTransactionsStatisticsCardState();
}

class _WeeklyTransactionsStatisticsCardState
    extends State<WeeklyTransactionsStatisticsCard> {
  late PageController _controller;
  bool isTouched = false;
  int touchedIndex = -1;
  String selectedWeek = "";
  int selectedYear = DateTime.now().year;

  String touchedType = "";

  int selectedMonth = DateTime.now().month;

  List<int> selectedMonthsCount = [];

  List<int> years = [];
  List<String> months = [];

  List<Map<String, DateTime>> availableWeeks = [];

  Map<Map<String, DateTime>, TransactionSummary> weeklySummaries = {};

  Map<DateTime, List<Map<Map<String, DateTime>, TransactionSummary>>>
      monthlySummaries = {};

  int pageIndex = 0;

  num highestAmount = 0;

  int barIndex = 0;

  @override
  void initState() {
    months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    years = widget.summary.keys.map((e) => e.year).toSet().toList();
    selectedYear = years.first;
    generateAvailableWeeks();
    selectedMonthsCount = monthlySummaries
        .map((key, value) => MapEntry(key, value.length))
        .values
        .toList();

    selectedWeek =
        months[selectedMonth -1];

    pageIndex = selectedMonth -1;
    touchedIndex = calculateTouchedIndex(0);

    _controller = PageController(initialPage: pageIndex)
      ..addListener(() {
        setState(() {
          pageIndex = _controller.page?.toInt() ?? pageIndex;
          selectedMonth = pageIndex + 1;
          selectedWeek =
          months[selectedMonth -1];
        });
      });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant WeeklyTransactionsStatisticsCard oldWidget) {
    years = widget.summary.keys.map((e) => e.year).toSet().toList();
    selectedYear = years.first;
    generateAvailableWeeks();
    selectedWeek =
    months[selectedMonth -1];
    super.didUpdateWidget(oldWidget);
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
                selectedWeek,
                weight: FontWeight.bold,
                fontSize: 14.sp,
                letterSpacing: 1.3,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _controller.previousPage(duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                    },
                    child: SvgPicture.asset(
                      "assets/icons/arrowleft.svg",
                      width: 24.w,
                    ),
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  Builder(
                      builder: (context) {
                        return TextWidget(
                            "${DateFormat("${DateFormat.MONTH}").format(DateTime(selectedYear,selectedMonth))}");
                      }
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      _controller.nextPage(duration: Duration(milliseconds: 200), curve: Curves.easeIn);

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
          print("selectedMonth ${selectedMonth}");
          var currMonthsCount = selectedMonthsCount[selectedMonth - 1];
          var prevMonthsCount = selectedMonth == 1
              ? 0
              : selectedMonth == 2
                  ? selectedMonthsCount.first
                  : selectedMonthsCount
                      .sublist(0, selectedMonth - 2)
                      .reduce((value, element) => value + element);

          List<BarChartGroupData> barGroups = [];

          var monthlySummarie =
              monthlySummaries[DateTime(selectedYear, selectedMonth)] ?? [];

          for (int i = 0; i < monthlySummarie.length; i++) {
            var monthlySummarie2 = monthlySummarie[i];
            TransactionSummary summary = monthlySummarie2.values.isNotEmpty
                ? monthlySummarie2.values.first
                : TransactionSummary.Zero();
            num sum = summary.tripAmount.abs() + summary.expenseAmount.abs();
            double total =
                (highestAmount == 0 ? 0 : (sum) / highestAmount) * 100;
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
            double trip = ((summary.tripAmount == 0
                ? 0
                : summary.tripAmount <= 0
                ? 0
                : summary.tripAmount.abs() / (sum)) *
                100 *
                (total / 100));
            //
            // print("summary: $summary, \n"
            //     "highest: $highestAmount, \n"
            //     "summaryAmount: ${summary.tripAmount.abs()}, \n"
            //     "total: $total, \n"
            //     "expense: $expense, \n"
            //     "income: $income, \n"
            //     "touchedIndex: $touchedIndex $i, \n");
            barGroups.add(
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: 1,
                    color: barIndex == i
                        ? AppColors.coinGold
                        : const Color(0xffDDDFE2),
                    width: Get.width * (monthlySummaries.length == 4 ? 0.16 : 0.15) * 0.2,

                    borderRadius: BorderRadius.circular(6.r),

                  ),
                  BarChartRodData(
                    toY: income + 1,
                    color: barIndex == i
                        ? AppColors.green
                        : const Color(0xffDDDFE2),
                    width: Get.width * (monthlySummaries.length == 4 ? 0.14 : 0.13) * 0.2,

                    borderRadius: BorderRadius.circular(6.r),

                  ),
                  BarChartRodData(
                    toY: trip + 1,
                    color: barIndex == i
                        ? AppColors.blue
                        : const Color(0xffDDDFE2),
                    width: Get.width * (monthlySummaries.length == 4 ? 0.14 : 0.13) * 0.2,

                    borderRadius: BorderRadius.circular(6.r),

                  ),
                  BarChartRodData(
                    toY: expense + 1,
                    color: barIndex == i
                        ? AppColors.red
                        : const Color(0xffDDDFE2),
                    width: Get.width * (monthlySummaries.length == 4 ? 0.14 : 0.13) * 0.2,

                    borderRadius: BorderRadius.circular(6.r),

                  ),
                  BarChartRodData(
                    toY: 1,
                    color: barIndex == i
                        ? AppColors.blueGreen
                        : const Color(0xffDDDFE2),
                    width: Get.width * (monthlySummaries.length == 4 ? 0.14 : 0.13) * 0.2,

                    borderRadius: BorderRadius.circular(6.r),

                  ),
                ],
                showingTooltipIndicators: [],
              ),
            );
          }


          // print(
          //     "PageIndex: $pageIndex, currMonth $currMonthsCount, prevMonth $prevMonthsCount, ${weeklySummaries.length}");

          // print("Selected Bar Groups ${selectedBarGroups}");
          BarChartData sectionData = BarChartData(
            barGroups: barGroups,
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
                    int currCount = pageIndex == 0 ? 0 : selectedMonthsCount.sublist(0, pageIndex).reduce((value, element) => value + element);

                    barIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                    touchedIndex = barIndex + currCount;

                    DateTime from = availableWeeks[touchedIndex]["from"] ?? DateTime.now();
                    DateTime to = availableWeeks[touchedIndex]["to"] ?? DateTime.now();

                    String week =
                        " ${DateFormat("${DateFormat.ABBR_WEEKDAY}, ${DateFormat.ABBR_MONTH} ").format(from)} ${from.day} - ${DateFormat("${DateFormat.ABBR_WEEKDAY}, ${DateFormat.DAY} ${DateFormat.ABBR_MONTH}").format(to)}";
                    selectedWeek = week;
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
                      showTitles: true,
                      reservedSize: 36.h,
                      getTitlesWidget: (n, medata) {
                        String day = "Week ${n.toInt() + 1}";

                        return Column(
                          children: [
                            SizedBox(height: 12.h,),
                            TextWidget(
                              day,
                              fontSize: 12.sp,
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
              children: List.generate(
                (12),
                (index) => Stack(
                  children: [
                    Positioned.fill(
                      child: BarChart(sectionData),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        kVerticalSpaceRegular,
        Builder(builder: (context) {
          List<Transaction> transactions2 = touchedIndex == -1
              ? []
              : weeklySummaries[weeklySummaries.keys.toList()[touchedIndex]]
                      ?.transactions ??
                  [];
          num expenses = touchedIndex == -1
              ? 0
              : weeklySummaries[weeklySummaries.keys.toList()[touchedIndex]]
              ?.expenseAmount ??
              0;

          num trips = touchedIndex == -1
              ? 0
              : weeklySummaries[weeklySummaries.keys.toList()[touchedIndex]]
              ?.tripAmount ??
              0;

          var income =
              weeklySummaries[weeklySummaries.keys.toList()[touchedIndex]]
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
                padding: EdgeInsets.symmetric(
                  horizontal: 8.0.w,
                ),
                child: TransactionHistorySection(
                  transactions: transactions2,
                  withTransaction: true,
                ),
              )
            ],
          );
        }),
      ],
    );
  }

  void generateAvailableWeeks() {
    monthlySummaries.clear();
    availableWeeks.clear();
    List<List<DateTime>> dates = TransactionSummaryCubit.getWeeksForRange(
      DateTime(
        selectedYear,
        1,
        1,
      ),
      DateTime(
        selectedYear,
        12,
        31,
      ),
    );

    dates.forEach((element) {
      availableWeeks.add({
        "from": element.first,
        "to": element.last,
      });
    });
    for (int i = 1; i <= 12; i++) {
      monthlySummaries.putIfAbsent(
        DateTime(selectedYear, i),
        () => [],
      );
    }

    print("monthlySummaries ${monthlySummaries.length}");

    weeklySummaries.clear();

    dates.forEach((element) {
      if (widget.summary.keys.any((e) => element.hasDate(e))) {
        var transactionSummary = widget.summary[
            widget.summary.keys.firstWhere((e) => element.hasDate(e))]!;
        highestAmount =
            (transactionSummary.tripAmount + transactionSummary.expenseAmount) >
                    highestAmount
                ? transactionSummary.tripAmount
                : highestAmount;
        Map<Map<String, DateTime>, TransactionSummary> mapped = {};
        Map<String, DateTime> map = {
          "from": element.first,
          "to": element.last,
        };

        mapped.putIfAbsent(map, () => transactionSummary);

        weeklySummaries.putIfAbsent({
          "from": element.first,
          "to": element.last,
        }, () {
          return transactionSummary;
        });
        monthlySummaries[DateTime(selectedYear, element.last.month)]
            ?.add(mapped);
      } else {
        var transactionSummary2 = TransactionSummary.Zero();

        Map<Map<String, DateTime>, TransactionSummary> mapped = {};
        Map<String, DateTime> map = {
          "from": element.first,
          "to": element.last,
        };

        mapped.putIfAbsent(map, () => transactionSummary2);
        weeklySummaries.putIfAbsent({
          "from": element.first,
          "to": element.last,
        }, () {
          return transactionSummary2;
        });
        monthlySummaries[DateTime(selectedYear, element.last.month)]
            ?.add(mapped);
      }
    });

    calculateSummaries();
  }

  void calculateSummaries() {
    selectedMonthsCount = monthlySummaries
        .map((key, value) => MapEntry(key, value.length))
        .values
        .toList();

  }

  int calculateTouchedIndex(int initTouchedIndex) {
    print("Calculate");
    print(initTouchedIndex);
    int currCount = pageIndex == 0 ? selectedMonthsCount.first : selectedMonthsCount.sublist(0, pageIndex).reduce((value, element) => value + element);
    return currCount + initTouchedIndex;

  }

  int _weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    int woy = ((dayOfYear - date.weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = _numOfWeeks(date.year - 1);
    } else if (woy > _numOfWeeks(date.year)) {
      woy = 1;
    }
    return woy;
  }

  int _numOfWeeks(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }
}
