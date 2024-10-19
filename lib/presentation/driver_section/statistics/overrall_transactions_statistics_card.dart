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

class OverallTransactionsStatisticsCard extends StatefulWidget {
  final TransactionSummary summary;

  const OverallTransactionsStatisticsCard({Key? key, required this.summary})
      : super(key: key);

  @override
  State<OverallTransactionsStatisticsCard> createState() =>
      _OverallTransactionsStatisticsCardState();
}

class _OverallTransactionsStatisticsCardState
    extends State<OverallTransactionsStatisticsCard> {
  int touchedIndex =  0;
  int selectedYear = DateTime.now().year;

  List<int> years = [];


  List<DateTime> availableYears = [];


  @override
  void initState() {
    generateAvailableYears();

    super.initState();
  }

  @override
  void didUpdateWidget(OverallTransactionsStatisticsCard oldWidget) {
    // print("did update widget");
    years = widget.summary.transactions.map((e) => e.timeAdded.year).toSet().toList();
    selectedYear = DateTime.now().year;
    generateAvailableYears();

    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    years = widget.summary.transactions.map((e) => e.timeAdded.year).toSet().toList();
    selectedYear = DateTime.now().year;
    generateAvailableYears();

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
                "Overall",
                weight: FontWeight.bold,
                fontSize: 14.sp,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/arrowleft.svg",
                    width: 24.w,
                    color: AppColors.veryLightGray,
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  Builder(builder: (context) {
                    if (availableYears.length == 1) {
                      return TextWidget("${availableYears.first.year}");
                    } else if (availableYears.length > 1) {
                      return TextWidget(
                          "${availableYears.last.year} - ${availableYears.first.year}");
                    } else {
                      return TextWidget("No Data");
                    }
                  }),
                  SizedBox(
                    width: 3.w,
                  ),
                  SvgPicture.asset(
                    "assets/icons/arrowright.svg",
                    width: 24.w,
                    color: AppColors.veryLightGray,
                  ),
                ],
              ),
            ],
          ),
        ),
        kVerticalSpaceRegular,
        LayoutBuilder(builder: (context, constraints) {
          List<BarChartGroupData> barGroups = [];

            barGroups.add(
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(
                    toY: 1,
                    color:  AppColors.coinGold,
                    width: Get.width * 0.18,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  BarChartRodData(
                    toY: widget.summary.income.toDouble(),
                    color:  AppColors.green,
                    width: Get.width * 0.18,

                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  BarChartRodData(
                    toY: widget.summary.tripAmount.toDouble() + 1,
                    color:AppColors.blue,
                    width: Get.width * 0.18,

                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  BarChartRodData(
                    toY: widget.summary.expenseAmount.toDouble() + 1,

                    color: AppColors.red,
                    width: Get.width * 0.18,

                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  BarChartRodData(
                    toY: 1,
                    color: AppColors.blueGreen,
                    width: Get.width * 0.18,

                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ],
                showingTooltipIndicators: [],
              ),
            );


          BarChartData sectionData = BarChartData(
            barGroups: barGroups,
            alignment: BarChartAlignment.spaceBetween,
            barTouchData: BarTouchData(
              enabled: true,
              // allowTouchBarBackDraw: true,
              touchExtraThreshold: EdgeInsets.symmetric(vertical: 20.h),
              touchCallback: (FlTouchEvent event, barTouchResponse) {
                if (!event.isInterestedForInteractions ||
                    barTouchResponse == null ||
                    barTouchResponse.spot == null) {
                  // touchedIndex = -1;
                  return;
                } else {
                  touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                  print("touched ${touchedIndex}");

                  setState(() {});
                }
              },
              touchTooltipData: BarTouchTooltipData(
                // tooltipBgColor: Colors.transparent,
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
              show: false,
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: false,

                  ),
              ),
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
            child: BarChart(sectionData),
          );
        }),
        kVerticalSpaceRegular,
        Builder(builder: (context) {
          List<Transaction> transactions2 = touchedIndex == -1
              ? []
              : widget.summary.transactions;
          num expenses = touchedIndex == -1
              ? 0
              : widget.summary.expenseAmount;

          num trips = touchedIndex == -1
              ? 0
              : widget.summary.tripAmount;

          var income =
              widget.summary.income;

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

  void generateAvailableYears() {
    availableYears = List.generate(years.length, (index) {
      var year = years[index];
      return DateTime(
        year,
      );
    });
  }

}
