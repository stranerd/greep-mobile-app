import 'package:flutter/material.dart';

import '../../../utils/constants/app_styles.dart';
import '../widgets/transactions_card.dart';
import 'balance.dart';
import 'to_collect_screen.dart';
import 'to_pay_screen.dart';
import 'trip.dart';
import 'view_expense.dart';

class TransactionView extends StatelessWidget {
  const TransactionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Image.asset("assets/images/profile_pix.png"),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        "Wizzy",
                        style: AppTextStyles.blackSizeBold12,
                      ),
                    ],
                  ),
                  const SizedBox(width: 8.0),
                  Image.asset("assets/images/profile_pix.png"),
                  const SizedBox(width: 8.0),
                  Image.asset("assets/images/profile_pix.png"),
                  const SizedBox(width: 8.0),
                  Image.asset("assets/images/profile_pix.png"),
                  const SizedBox(width: 8.0),
                  Image.asset("assets/images/profile_pix.png"),
                  const SizedBox(width: 8.0),
                  Image.asset("assets/images/profile_pix.png"),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(
                "Wizzy’s transactions",
                style: AppTextStyles.blackSizeBold16,
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Apr 2022",
                    style: AppTextStyles.blackSizeBold12,
                  ),
                  Text(
                    "Income: ",
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
                        color: const Color.fromRGBO(221, 226, 224, 1)),
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
                        color: const Color.fromRGBO(221, 226, 224, 1)),
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
                    "Income: ",
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
                      width: 1, color: const Color.fromRGBO(221, 226, 224, 1)),
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
                        color: const Color.fromRGBO(221, 226, 224, 1)),
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
                        color: const Color.fromRGBO(221, 226, 224, 1)),
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
                        color: const Color.fromRGBO(221, 226, 224, 1)),
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
        ),
      ),
    );
  }
}
