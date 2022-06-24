import 'package:flutter/material.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_styles.dart';

class ViewExpense extends StatelessWidget {
  const ViewExpense({Key? key}) : super(key: key);

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
          'Transaction details',
          style: AppTextStyles.blackSizeBold14,
        ),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Expense", style: AppTextStyles.blackSize12),
              const SizedBox(
                height: 4.0,
              ),
              Text("Fuel", style: AppTextStyles.blackSize16),
              const SizedBox(
                height: 16.0,
              ),
              Text(
                "Date/Time",
                style: AppTextStyles.blackSize12,
              ),
              const SizedBox(
                height: 4.0,
              ),
              Text(
                "Mar 19 . 10:54 AM",
                style: AppTextStyles.blackSize16,
              ),
              const SizedBox(
                height: 16.0,
              ),
              Text(
                "Expense Cost",
                style: AppTextStyles.blackSize12,
              ),
              const SizedBox(
                height: 4.0,
              ),
              Text(
                "\$20",
                style: AppTextStyles.blackSize16,
              ),
              const SizedBox(
                height: 16.0,
              ),
              Text(
                "Expense Description",
                style: AppTextStyles.blackSize12,
              ),
              const SizedBox(
                height: 4.0,
              ),
              Text(
                "I bought fuel after 6 long trips.",
                style: AppTextStyles.blackSize16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
