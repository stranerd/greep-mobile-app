import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greep/application/transactions/response/transaction_summary.dart';
import 'package:greep/application/transactions/transaction_summary_cubit.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/money.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/transaction/transaction.dart';
import 'package:greep/presentation/driver_section/statistics/top_customers.dart';
import 'package:greep/presentation/driver_section/widgets/chart_transaction_indicator.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class AllTransactionsStatisticsCard extends StatefulWidget {
  const AllTransactionsStatisticsCard(
      {Key? key, required this.transactionSummary})
      : super(key: key);
  final TransactionSummary transactionSummary;

  @override
  State<AllTransactionsStatisticsCard> createState() =>
      _AllTransactionsStatisticsCardState();
}

class _AllTransactionsStatisticsCardState
    extends State<AllTransactionsStatisticsCard> {
  String touchedIndex = "";
  int selectedYear = DateTime.now().year;

  String touchedType = "";

  List<int> years = [];

  late TransactionSummary selectedTransactionSummary;

  @override
  void didChangeDependencies() {
    years = widget.transactionSummary.transactions
        .map((e) => e.timeAdded.year)
        .toSet()
        .toList();
    if (years.isEmpty) {
      years = [DateTime.now().year];
    }
    selectedYear = years.first;

    calculateYears();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant AllTransactionsStatisticsCard oldWidget) {
    years = widget.transactionSummary.transactions
        .map((e) => e.timeAdded.year)
        .toSet()
        .toList();
    if (years.isEmpty) {
      years = [DateTime.now().year];
    }
    selectedYear = years.first;
    calculateYears();
    super.didUpdateWidget(oldWidget);
  }

  void calculateYears() {
    List<Transaction> trans = widget.transactionSummary.transactions
        .where((element) => element.timeAdded.year == selectedYear)
        .toList();
    selectedTransactionSummary = TransactionSummaryCubit.calculateTransaction(
        trans, DateTime(selectedYear), DateTime(selectedYear, 12, 31));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 1.sw,
      decoration: const BoxDecoration(color: kWhiteColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          kVerticalSpaceRegular,
          Container(
            decoration: BoxDecoration(color: kWhiteColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                        calculateYears();
                        setState(() {});
                      }),
                )
              ],
            ),
          ),
          kVerticalSpaceRegular,
          Builder(builder: (context) {
            double expense =
                selectedTransactionSummary.expenseAmount.toDouble();
            double income = selectedTransactionSummary.income.toDouble();

            List<PieChartSectionData> sectionData = [
              PieChartSectionData(
                titleStyle: kWhiteTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                value: income == 0 && expense == 0 ? 0 : income,
                title: "income",
                showTitle: false,
                color: kGreenColor,
                radius: touchedIndex == "income" ? 40 : 38,
              ),
              PieChartSectionData(
                titleStyle: kWhiteTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                value: income == 0 && expense == 0 ? 0 : expense,
                title: "expense",
                showTitle: false,
                color: AppColors.red,
                radius: touchedIndex == "expense" ? 40 : 38,
              ),
            ];

            return LayoutBuilder(
              builder: (c, cs) => GestureDetector(
                onTap: () {
                  print("on tap");
                  touchedIndex = "";
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 250.h,
                  width: 1.sw,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: PieChart(
                          PieChartData(
                              pieTouchData: PieTouchData(touchCallback:
                                  (FlTouchEvent event, pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    return;
                                  }
                                  if (pieTouchResponse.touchedSection == null ||
                                      pieTouchResponse
                                              .touchedSection!.touchedSection ==
                                          null) {
                                    touchedIndex = "";
                                  } else {
                                    touchedIndex = pieTouchResponse
                                        .touchedSection!.touchedSection!.title;
                                  }
                                });
                              }),
                              startDegreeOffset: 90,
                              borderData: FlBorderData(
                                  show: true,
                                  border: Border(
                                    bottom: BorderSide(
                                        color: kGreenColor, width: 5),
                                  )),
                              sectionsSpace: 0,
                              centerSpaceRadius: double.infinity,
                              sections: sectionData),
                        ),
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
                    isSelected: touchedIndex == "income",
                    amount: selectedTransactionSummary.income.toMoney,
                  ),
                ),
                SizedBox(
                  width: constr.maxWidth * 0.33,
                  child: ChartTransactionIndicator(
                    color: AppColors.blue,
                    text: "Total Trip",
                    icon: "assets/icons/trip_amount_blue.svg",
                    amount: selectedTransactionSummary.tripAmount.toMoney,
                    backgroundColor: const Color.fromRGBO(2, 80, 198, 0.1),
                    isSelected: touchedIndex == "trip",
                  ),
                ),
                SizedBox(
                  width: constr.maxWidth * 0.33,
                  child: ChartTransactionIndicator(
                    color: AppColors.red,
                    backgroundColor: const Color(0xffECC2C2),
                    icon: "assets/icons/expense_red.svg",
                    amount: selectedTransactionSummary.expenseAmount.toMoney,
                    text: "Total Expenses",
                    isSelected: touchedIndex == "expense",
                  ),
                ),
              ],
            );
          }),
          kVerticalSpaceRegular,
          TopCustomersView(
              transactions: selectedTransactionSummary.transactions),
        ],
      ),
    );
  }
}
