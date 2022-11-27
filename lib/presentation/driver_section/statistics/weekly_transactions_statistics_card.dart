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

  List<int> years = [];

  List<Map<String, DateTime>> availableWeeks = [];

  Map<Map<String, DateTime>, TransactionSummary> weeklySummaries = {};

  int pageIndex = 0;

  num highestAmount = 0;

  @override
  void initState() {


    years = widget.summary.keys.map((e) => e.year).toSet().toList();
    selectedYear = years.first;
    generateAvailableWeeks();
    selectedWeek =
        "${DateFormat(DateFormat.ABBR_MONTH).format(widget.summary.keys.first)} - Week ${_weekNumber(widget.summary.keys.first)}";
    touchedIndex = ((widget.summary.keys.first.difference(DateTime(selectedYear)).inDays/7).floor());
    if (touchedIndex > 6) {
      pageIndex = (touchedIndex / 7).floor();
    }

    _controller = PageController(initialPage: pageIndex)
      ..addListener(() {
        setState(() {
          pageIndex = _controller.page?.toInt() ?? pageIndex;
          selectedWeek =
          "${DateFormat(DateFormat.ABBR_MONTH).format(availableWeeks[pageIndex * 7]["from"]!)} - Week ${_weekNumber(availableWeeks[pageIndex * 7]["to"]!)}";
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: kWhiteColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  selectedWeek,
                  weight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 2,
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
                      underline: SizedBox(),
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
                )
              ],
            ),
          ),
          kVerticalSpaceRegular,
          LayoutBuilder(builder: (context, constraints) {
            List<BarChartGroupData> barGroups = [];

            for (int i = 0; i < weeklySummaries.length; i++) {
              TransactionSummary summary =
                  weeklySummaries[weeklySummaries.keys.toList()[i]]!;
              num sum = summary.tripAmount.abs() + summary.expenseAmount.abs();
              double total =
                  ((highestAmount == 0 ? 0 : (sum) / highestAmount) * 100);
              double expense =
                  ((sum == 0 ? 0 : summary.expenseAmount.abs() / sum) *
                      100 *
                      (total / 100));
              double income = ((sum == 0 ? 0 : summary.income.abs() / (total)) *
                  100 *
                  (total / 100));

              // print(""
              //     "summary: $summary \n"
              //     "highest: $highestAmount, \n"
              //     "summaryAmount: ${summary.tripAmount.abs()}  \n"
              //     "total: $total,  \n"
              //     "expense: $expense,  \n"
              //     "income: $income"
              //     "tochedIndex: $touchedIndex $i \n");
              barGroups.add(
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: total,
                      color: const Color(0xffDDDFE2),
                      width: Get.width * 0.11,
                      rodStackItems: touchedIndex == i
                          ? [
                              BarChartRodStackItem(
                                  expense, income, AppColors.green),
                              BarChartRodStackItem(0, expense, AppColors.red)
                            ]
                          : [],
                      borderRadius:
                          BorderRadius.circular(kDefaultSpacing * 0.2),
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

            print("BArGroups ${barGroups.length}");

            var selectedBarGroups = pageIndex == 0
                ? barGroups.take(7).toList()
                : barGroups.sublist(
                    pageIndex * 7,
                    ((pageIndex * 7) + 7) < barGroups.length
                        ? ((pageIndex * 7) + 7)
                        : barGroups.length);
            print(
                "Selected Bar Groups pageIndex ${pageIndex * 7} ${pageIndex * 7 + 7} ${selectedBarGroups.length}");

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
                      touchedIndex =
                          barTouchResponse.spot!.touchedBarGroupIndex +
                              (pageIndex * 7);
                      print("touched index ${pageIndex} ${touchedIndex}");
                      DateTime from = weeklySummaries[
                                  weeklySummaries.keys.toList()[touchedIndex]]
                              ?.dateRange
                              .first ??
                          DateTime.now();
                      DateTime to = weeklySummaries[
                                  weeklySummaries.keys.toList()[touchedIndex]]
                              ?.dateRange
                              .last ??
                          DateTime.now();
                      String week =
                          " ${DateFormat("${DateFormat.ABBR_WEEKDAY}, ${DateFormat.ABBR_MONTH} ").format(from)} ${from.day} - ${DateFormat("${DateFormat.ABBR_WEEKDAY}, ${DateFormat.DAY} ${DateFormat.ABBR_MONTH}").format(to)}";
                      selectedWeek = week;
                    });
                  }
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (n, medata) {
                          String day = "W${n.toInt() + 1}";
                          // var availableWeek = availableWeeks[n.toInt()];
                          // DateTime from = availableWeek["from"]!;
                          // for (int i = 0; i< 7; i++){
                          //   day = DateFormat(DateFormat.ABBR_WEEKDAY).format(from.add(Duration(days: i)));
                          // }

                          return TextWidget(
                            day,
                            fontSize: 16,
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
              height: 250.h,
              width: 1.sw,
              child: PageView(
                controller: _controller,
                children: List.generate(
                  (barGroups.length / 7).ceil(),
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
          kVerticalSpaceLarge,
          LayoutBuilder(builder: (context, constr) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: constr.maxWidth * 0.33,
                  child: ChartTransactionIndicator(
                    icon: "assets/icons/income_green.svg",
                    color: kGreenColor,
                    backgroundColor: const Color.fromRGBO(4, 210, 140, 0.1),
                    text: "Total Income",
                    isSelected: touchedType == "income",
                    amount: touchedIndex == -1
                        ? "0"
                        : "${weeklySummaries[weeklySummaries.keys.toList()[touchedIndex]]?.income ?? 0}",
                  ),
                ),
                SizedBox(
                  width: constr.maxWidth * 0.33,
                  child: ChartTransactionIndicator(
                    color: AppColors.blue,
                    text: "Total Trip",
                    icon: "assets/icons/trip_amount_blue.svg",
                    amount: touchedIndex == -1
                        ? "0"
                        : "${weeklySummaries[weeklySummaries.keys.toList()[touchedIndex]]?.tripAmount ?? 0}",
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
                        : "${weeklySummaries[weeklySummaries.keys.toList()[touchedIndex]]?.expenseAmount ?? 0}",
                    text: "Total Expenses",
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
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TransactionHistorySection(
                    transactions: transactions2,
                    withTransaction: true,
                  ),
                )
              ],
            );
          }),

        ],
      ),
    );
  }

  void generateAvailableWeeks() {
    availableWeeks.clear();
    List<List<DateTime>> dates = TransactionSummaryCubit.getWeeksForRange(
        DateTime(selectedYear, 1, 1), DateTime(selectedYear, 12, 31));

    dates.forEach((element) {
      availableWeeks.add({
        "from": element.first,
        "to": element.last,
      });
    });

    weeklySummaries.clear();

    dates.forEach((element) {
      if (widget.summary.keys.any((e) => element.hasDate(e))) {
        weeklySummaries.putIfAbsent({
          "from": element.first,
          "to": element.last,
        }, () {
          var transactionSummary = widget.summary[
              widget.summary.keys.firstWhere((e) => element.hasDate(e))]!;
          highestAmount = (transactionSummary.tripAmount +
                      transactionSummary.expenseAmount) >
                  highestAmount
              ? transactionSummary.tripAmount
              : highestAmount;
          return transactionSummary;
        });
      } else {
        weeklySummaries.putIfAbsent({
          "from": element.first,
          "to": element.last,
        }, () => TransactionSummary.Zero());
      }
    });

    // weeklySummaries.forEach((key, value) {
    //   print("Dates $key");
    //
    //   print("Summary $value");
    //
    // });
    //
    // print("Weekly Summaries ${weeklySummaries.length}");

    calculateSummaries();
  }

  void calculateSummaries() {}

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
