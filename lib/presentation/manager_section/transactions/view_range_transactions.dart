import 'package:flutter/material.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_styles.dart';
import '../../driver_section/transaction/balance.dart';
import '../../driver_section/transaction/to_collect_screen.dart';
import '../../driver_section/transaction/to_pay_screen.dart';
import '../../driver_section/transaction/transaction_details.dart';
import '../../driver_section/transaction/view_expense.dart';
import '../../driver_section/widgets/transactions_card.dart';

class Range extends StatelessWidget {
  const Range({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 16,
            ),
            color: AppColors.black),
        title: Text(
          'Range',
          style: AppTextStyles.blackSizeBold14,
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("14 Mar 2022 - 2 Apr 2022 ",
                  style: AppTextStyles.blackSizeBold12),
              const SizedBox(
                height: 8.0,
              ),
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const TransactionDetails(),
                  //   ),
                  // );
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
              const SizedBox(height: 8.0),
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
              const SizedBox(height: 8.0),
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
