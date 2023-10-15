import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:greep/Commons/colors.dart';
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

class DailyTransactionsStatisticsCard extends StatefulWidget {
  final Map<DateTime, TransactionSummary> summary;

  const DailyTransactionsStatisticsCard({Key? key, required this.summary})
      : super(key: key);

  @override
  State<DailyTransactionsStatisticsCard> createState() =>
      _DailyTransactionsStatisticsCardState();
}

class _DailyTransactionsStatisticsCardState
    extends State<DailyTransactionsStatisticsCard> {
  late PageController _controller;
  int touchedIndex = -1;
  String selectedDay = "";
  int selectedYear = DateTime.now().year;

  List<String> months = [];

  int selectedMonth = 0;

  String touchedType = "";

  List<int> years = [];

  List<DateTime> availableDays = [];

  Map<DateTime, TransactionSummary> dailySummaries = {};

  int pageIndex = 0;

  num highestAmount = 0;

  @override
  void initState() {
    years = widget.summary.keys.map((e) => e.year).toSet().toList();
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

    selectedYear = years.first;
    selectedMonth = widget.summary.keys.first.month - 1;
    generateAvailableDays();
    selectedDay =
        "${DateFormat(DateFormat.ABBR_MONTH).format(DateTime.now())} - Week ${_weekNumber(DateTime.now())}";
    touchedIndex =
        DateTime.now().difference(DateTime(selectedYear)).inDays.abs() +
            (_isLeapYear(DateTime.now().year)
                ? (availableDays.length - 366)
                : (availableDays.length - 365));
    if (touchedIndex > 6) {
      pageIndex = (touchedIndex / 7).floor();
      // _controller.animateToPage(pageIndex, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
    }
    _controller = PageController(initialPage: pageIndex)
      ..addListener(() {
        setState(() {
          pageIndex = _controller.page?.toInt() ?? pageIndex;
          selectedDay =
              "${DateFormat(DateFormat.ABBR_MONTH).format(((pageIndex * 7) + 7) > availableDays.length ? availableDays[pageIndex * 7] : availableDays[(pageIndex * 7) + 7])}"
              " - Week ${_weekNumber(((pageIndex * 7) + 7) > availableDays.length ? availableDays[pageIndex * 7] : availableDays[(pageIndex * 7) + 7])}";
        });
      });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DailyTransactionsStatisticsCard oldWidget) {
    years = widget.summary.keys.map((e) => e.year).toSet().toList();
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

    selectedYear = years.first;
    selectedMonth = DateTime.now().month - 1;
    generateAvailableDays();
    selectedDay =
        "${DateFormat(DateFormat.ABBR_MONTH).format(DateTime.now())} - Week ${_weekNumber(DateTime.now())}";
    touchedIndex =
        DateTime.now().difference(DateTime(selectedYear)).inDays.abs() +
            (_isLeapYear(DateTime.now().year)
                ? (availableDays.length - 366)
                : (availableDays.length - 365));
    if (touchedIndex > 6) {
      pageIndex = (touchedIndex / 7).floor();
      // _controller.animateToPage(pageIndex, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: kWhiteColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                selectedDay,
                weight: FontWeight.bold,
                fontSize: 14.sp,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _controller.previousPage(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn);
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
                    DateTime date = ((pageIndex * 7) + 7) > availableDays.length
                        ? availableDays[pageIndex * 7]
                        : availableDays[(pageIndex * 7) + 7];
                    return TextWidget(
                        "${DateFormat("${DateFormat.ABBR_MONTH} ${DateFormat.DAY}").format(
                      date.subtract(
                        const Duration(
                          days: 7,
                        ),
                      ),
                    )} - ${DateFormat("${DateFormat.ABBR_MONTH} ${DateFormat.DAY}").format(date)}");
                  }),
                  SizedBox(
                    width: 3.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      _controller.nextPage(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn);
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

          for (int i = 0; i < dailySummaries.length; i++) {
            TransactionSummary summary =
                dailySummaries[dailySummaries.keys.toList()[i]]!;
            num sum = summary.tripAmount.abs() + summary.expenseAmount.abs();
            double total =
                ((highestAmount == 0 ? 0 : (sum) / highestAmount) * 100);
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

            if (touchedIndex == i) {
              // print(""
              //     "summary: $summary \n"
              //     "highest: $highestAmount, \n"
              //     "summaryAmount: ${summary.tripAmount.abs()}  \n"
              //     "total: $total,  \n"
              //     "expense: $expense,  \n"
              // "trips: ${trip} \n"
              //     "income: $income \n"
              //     "tochedIndex: $touchedIndex $i \n");
            }
            barGroups.add(
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: 1,
                    color: touchedIndex == i
                        ? AppColors.coinGold
                        : const Color(0xffDDDFE2),
                    width: Get.width * 0.085 * 0.2,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  BarChartRodData(
                    toY: income + 1,
                    color: touchedIndex == i
                        ? AppColors.green
                        : const Color(0xffDDDFE2),
                    width: Get.width * 0.085 * 0.2,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  BarChartRodData(
                    toY: trip + 1,
                    color: touchedIndex == i
                        ? AppColors.blue
                        : const Color(0xffDDDFE2),
                    width: Get.width * 0.085 * 0.2,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  BarChartRodData(
                    toY: expense + 1,
                    color: touchedIndex == i
                        ? AppColors.red
                        : const Color(0xffDDDFE2),
                    width: Get.width * 0.085 * 0.2,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  BarChartRodData(
                    toY: 1,
                    color: touchedIndex == i
                        ? AppColors.blueGreen
                        : const Color(0xffDDDFE2),
                    width: Get.width * 0.085 * 0.2,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ],
                showingTooltipIndicators: [],
              ),
            );
          }

          var selectedBarGroups = pageIndex == 0
              ? barGroups.take(7).toList()
              : barGroups.sublist(
                  pageIndex * 7,
                  ((pageIndex * 7) + 7) < barGroups.length
                      ? ((pageIndex * 7) + 7)
                      : barGroups.length);

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
                        (pageIndex * 7);
                    selectedDay = DateFormat(
                            "${DateFormat.ABBR_WEEKDAY}, ${DateFormat.DAY} ${DateFormat.ABBR_MONTH}")
                        .format(dailySummaries.keys.toList()[touchedIndex]);
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
                      fontSize: 16.sp,
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
                      reservedSize: 48.h,
                      getTitlesWidget: (n, medata) {


                        var nDay = availableDays.first.add(
                          Duration(days: n.toInt()),
                        );
                        String day = DateFormat(DateFormat.ABBR_WEEKDAY).format(
                          nDay,
                        );
                        return Column(
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            TextWidget(
                              day,
                              fontSize: 12.sp,
                              weight: n == touchedIndex ?FontWeight.bold : null,

                            ),
                            TextWidget(
                              nDay.day.toString(),
                              fontSize: 12.sp,
                              weight: n == touchedIndex ?FontWeight.bold : null,
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
        kVerticalSpaceRegular,
        Builder(builder: (context) {
          List<Transaction> transactions2 = touchedIndex == -1
              ? []
              : dailySummaries[dailySummaries.keys.toList()[touchedIndex]]
                      ?.transactions ??
                  [];
          num expenses = touchedIndex == -1
              ? 0
              : dailySummaries[dailySummaries.keys.toList()[touchedIndex]]
                      ?.expenseAmount ??
                  0;

          num trips = touchedIndex == -1
              ? 0
              : dailySummaries[dailySummaries.keys.toList()[touchedIndex]]
                      ?.tripAmount ??
                  0;

          var income =
              dailySummaries[dailySummaries.keys.toList()[touchedIndex]]
                      ?.income ??
                  0;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
        }),
      ],
    );
  }

  void generateAvailableDays() {
    List<List<DateTime>> dates = TransactionSummaryCubit.getWeeksForRange(
        DateTime(selectedYear, 1, 1), DateTime(selectedYear, 12, 31));

    availableDays = List.generate(dates.mapMany((item) => item).toList().length,
        (index) => dates.first.first.add(Duration(days: index)));

    calculateSummaries();
  }

  void calculateSummaries() {
    dailySummaries.clear();

    availableDays.forEach((element) {
      if (widget.summary.keys.any((e) =>
          element.month == e.month &&
          element.year == e.year &&
          element.day == e.day)) {
        dailySummaries.putIfAbsent(element, () {
          var transactionSummary = widget.summary[widget.summary.keys
              .firstWhere((e) =>
                  element.month == e.month &&
                  element.year == e.year &&
                  element.day == e.day)]!;
          highestAmount = (transactionSummary.tripAmount +
                      transactionSummary.expenseAmount) >
                  highestAmount
              ? transactionSummary.tripAmount
              : highestAmount;
          return transactionSummary;
        });
      } else {
        dailySummaries.putIfAbsent(element, () => TransactionSummary.Zero());
      }
    });
  }

  bool _isLeapYear(int year) {
    if (year % 4 == 0) {
      if (year % 100 == 0) {
        return year % 400 == 0;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  String _getDayAbbr(String day) {
    var last = int.parse(day.split("").last);
    if (last == 1) {
      return "st";
    } else if (last == 2) {
      return "nd";
    } else if (last == 3) {
      return "rd";
    }
    return "th";
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
