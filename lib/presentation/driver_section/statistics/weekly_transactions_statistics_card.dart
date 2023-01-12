import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:greep/Commons/colors.dart';
import 'package:greep/application/transactions/response/transaction_summary.dart';
import 'package:greep/application/transactions/transaction_summary_cubit.dart';
import 'package:greep/commons/money.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/transaction/transaction.dart';
import 'package:greep/presentation/driver_section/statistics/top_customers.dart';
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
                fontSize: 18,
                letterSpacing: 1.3,
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultSpacing * 0.6,
                      vertical: kDefaultSpacing * 0.3,
                    ),
                    decoration: BoxDecoration(
                        color: AppColors.lightGray,
                        borderRadius: BorderRadius.circular(
                          kDefaultSpacing,
                        )),
                    child: DropdownButton<String>(
                        isDense: true,
                        value: months[selectedMonth-1],
                        underline: const SizedBox(),
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 16,
                        ),
                        items: months
                            .map(
                              (e) => DropdownMenuItem<String>(
                            value: e,
                            child: TextWidget(
                              e.substring(0,3).toString(),
                              fontSize: 16,
                              weight: FontWeight.bold,
                            ),
                          ),
                        )
                            .toList(),
                        onChanged: (value) {
                          selectedMonth = value == null ? selectedMonth : months.indexOf(value) + 1;
                          selectedWeek =
                          months[selectedMonth -1];
                          _controller.animateToPage((
                              selectedMonth -1).floor(),
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                          generateAvailableWeeks();
                          setState(() {});
                        }),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultSpacing * 0.6,
                        vertical: kDefaultSpacing * 0.3),
                    decoration: BoxDecoration(
                        color: AppColors.lightGray,
                        borderRadius: BorderRadius.circular(kDefaultSpacing)),
                    child: DropdownButton<int>(
                        isDense: true,
                        value: selectedYear,
                        underline: const SizedBox(),
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 16,
                        ),
                        items: years
                            .map(
                              (e) => DropdownMenuItem<int>(
                                value: e,
                                child: TextWidget(
                                  e.toString(),
                                  fontSize: 16,
                                  weight: FontWeight.bold,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          selectedYear = value ?? DateTime.now().year;
                          generateAvailableWeeks();
                          setState(() {});
                        }),
                  ),
                ],
              )
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
                        : summary.income.abs() / (total)) *
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
                    toY: total,
                    color: const Color(0xffDDDFE2),
                    width: Get.width * (monthlySummaries.length == 4 ? 0.16 : 0.15),
                    rodStackItems: barIndex == i
                        ? [
                            BarChartRodStackItem(income, total, AppColors.blue),
                            BarChartRodStackItem(
                                expense, income, AppColors.green),
                            BarChartRodStackItem(0, expense, AppColors.red)
                          ]
                        : [],
                    borderRadius: BorderRadius.circular(kDefaultSpacing * 0.2),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: total,
                      color: const Color(0xffDDDFE2),
                    ),
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
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
                      getTitlesWidget: (n, medata) {
                        String day = "${months[selectedMonth-1].substring(0,3)}-w${n.toInt() + 1}";

                        return TextWidget(
                          day.toUpperCase(),
                          fontSize: 13,
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
            height: 0.25.sh,
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
        LayoutBuilder(builder: (context, constr) {
          var income2 =
              weeklySummaries[weeklySummaries.keys.toList()[touchedIndex]]?.income ??
                  0;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: constr.maxWidth * 0.33,
                child: ChartTransactionIndicator(
                  icon: "assets/icons/income_green.svg",
                  color: kGreenColor,
                  backgroundColor: const Color.fromRGBO(4, 210, 140, 0.1),
                  text: "Weekly Income",
                  isNegative: income2 < 0,
                  isSelected: touchedType == "income",
                  amount: touchedIndex == -1 ? "0" : income2.abs().toMoney,
                ),
              ),
              SizedBox(
                width: constr.maxWidth * 0.33,
                child: ChartTransactionIndicator(
                  color: AppColors.blue,
                  text: "Weekly Trip",
                  icon: "assets/icons/trip_amount_blue.svg",
                  amount: touchedIndex == -1
                      ? "0"
                      : "${weeklySummaries[weeklySummaries.keys.toList()[touchedIndex]]?.tripAmount.toMoney ?? 0}",
                  backgroundColor: const Color.fromRGBO(2, 80, 198, 0.1),
                  isSelected: touchedType == "trip",
                ),
              ),
              SizedBox(
                width: constr.maxWidth * 0.33,
                child: ChartTransactionIndicator(
                  color: AppColors.red,
                  backgroundColor: const Color(0xffECC2C2),
                  icon: "assets/icons/expense_red.svg",
                  amount: touchedIndex == -1
                      ? "0"
                      : "${weeklySummaries[weeklySummaries.keys.toList()[touchedIndex]]?.expenseAmount.toMoney ?? 0}",
                  text: "Weekly Expenses",
                  isExpense: true,
                  isSelected: touchedType == "expense",
                ),
              ),
            ],
          );
        }),
        kVerticalSpaceRegular,
        Builder(builder: (context) {
          List<Transaction> transactions2 = touchedIndex == -1
              ? []
              : weeklySummaries[weeklySummaries.keys.toList()[touchedIndex]]
                      ?.transactions ??
                  [];
          return Column(
            children: [
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
