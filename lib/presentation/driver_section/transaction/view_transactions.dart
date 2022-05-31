import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_styles.dart';
import '../widgets/transactions_card.dart';
import 'balance.dart';
import 'to_collect_screen.dart';
import 'to_pay_screen.dart';
import 'trip.dart';
import 'view_expense.dart';
import 'view_range_transactions.dart';

class TransactionView extends StatelessWidget {
  const TransactionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Transactions',
            style: AppTextStyles.blackSizeBold14,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
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
                        text: 'Recent',
                      ),
                      Tab(
                        text: 'Range',
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 20),
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top,
                child: TabBarView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Apr 2022",
                              style: AppTextStyles.blackSizeBold12,
                            ),
                            Text(
                              "Income: \$164",
                              style: AppTextStyles.blackSize10,
                            ),
                            Text(
                              "Trips: 64",
                              style: AppTextStyles.blackSize10,
                            ),
                            Text(
                              "Expenses: 43",
                              style: AppTextStyles.blackSize10,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TripScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              border: Border.all(
                                  width: 1,
                                  color:
                                      const Color.fromRGBO(221, 226, 224, 1)),
                            ),
                            child: TransactionCard(
                              title: "Kemi",
                              subtitle: "Mar 19 . 10:54 AM",
                              trailing: "+20\$",
                              subTrailing: "Trip",
                              subTrailingStyle: AppTextStyles.blackSize12,
                              titleStyle: AppTextStyles.blackSize14,
                              subtitleStyle: AppTextStyles.blackSize12,
                              trailingStyle: AppTextStyles.greenSize14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ViewExpense(),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              border: Border.all(
                                  width: 1,
                                  color:
                                      const Color.fromRGBO(221, 226, 224, 1)),
                            ),
                            child: TransactionCard(
                              title: "Fuel",
                              subtitle: "Mar 19 . 10:54 AM",
                              trailing: "-17\$",
                              subTrailing: "Expense",
                              subTrailingStyle: AppTextStyles.blackSize12,
                              titleStyle: AppTextStyles.blackSize14,
                              subtitleStyle: AppTextStyles.blackSize12,
                              trailingStyle: AppTextStyles.redSize14,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 32.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Mar 2022",
                              style: AppTextStyles.blackSizeBold12,
                            ),
                            Text(
                              "Income: \$164",
                              style: AppTextStyles.blackSize10,
                            ),
                            Text(
                              "Trips: 64",
                              style: AppTextStyles.blackSize10,
                            ),
                            Text(
                              "Expenses: 43",
                              style: AppTextStyles.blackSize10,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            border: Border.all(
                                width: 1,
                                color: const Color.fromRGBO(221, 226, 224, 1)),
                          ),
                          child: TransactionCard(
                            title: "Bola",
                            subtitle: "Mar 19 . 10:54 AM",
                            trailing: "+20\$",
                            subTrailing: "Trip",
                            subTrailingStyle: AppTextStyles.blackSize12,
                            titleStyle: AppTextStyles.blackSize14,
                            subtitleStyle: AppTextStyles.blackSize12,
                            trailingStyle: AppTextStyles.greenSize14,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BalanceScreen(),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              border: Border.all(
                                  width: 1,
                                  color:
                                      const Color.fromRGBO(221, 226, 224, 1)),
                            ),
                            child: TransactionCard(
                              title: "KIlntin",
                              subtitle: "Mar 19 . 10:54 AM",
                              trailing: "8\$",
                              subTrailing: "Balance",
                              subTrailingStyle: AppTextStyles.blackSize12,
                              titleStyle: AppTextStyles.blackSize14,
                              subtitleStyle: AppTextStyles.blackSize12,
                              trailingStyle: AppTextStyles.blackSize14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ToPayScreen(),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              border: Border.all(
                                  width: 1,
                                  color:
                                      const Color.fromRGBO(221, 226, 224, 1)),
                            ),
                            child: TransactionCard(
                              title: "Dammy",
                              subtitle: "Mar 19 . 10:54 AM",
                              trailing: "7\$",
                              subTrailing: "To pay",
                              subTrailingStyle: AppTextStyles.blackSize12,
                              titleStyle: AppTextStyles.blackSize14,
                              subtitleStyle: AppTextStyles.blackSize12,
                              trailingStyle: AppTextStyles.redSize14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ToCollectScreen(),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              border: Border.all(
                                  width: 1,
                                  color:
                                      const Color.fromRGBO(221, 226, 224, 1)),
                            ),
                            child: TransactionCard(
                              title: "Felicia",
                              subtitle: "Mar 19 . 10:54 AM",
                              trailing: "8\$",
                              subTrailing: "To collect",
                              subTrailingStyle: AppTextStyles.blackSize12,
                              titleStyle: AppTextStyles.blackSize14,
                              subtitleStyle: AppTextStyles.blackSize12,
                              trailingStyle: AppTextStyles.blueSize14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "From",
                              style: AppTextStyles.blackSize14,
                            ),
                            SizedBox(
                              width: 130.w,
                            ),
                            Text(
                              "To",
                              style: AppTextStyles.blackSize14,
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Flexible(
                              child: Container(
                                width: 150.w,
                                padding:
                                    const EdgeInsets.fromLTRB(16, 16, 16, 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.lightGray,
                                ),
                                child: Text(
                                  "Select Date",
                                  style: AppTextStyles.blackSize14,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16.0,
                            ),
                            Flexible(
                              child: Container(
                                width: 150.w,
                                padding:
                                    const EdgeInsets.fromLTRB(16, 16, 16, 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.lightGray,
                                ),
                                child: Text(
                                  "Select Date",
                                  style: AppTextStyles.blackSize14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Range(),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: AppColors.black,
                            ),
                            child: Text(
                              "Show Transactions",
                              style: AppTextStyles.whiteSize14,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
