import 'package:flutter/material.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_styles.dart';
import '../../../utils/constants/text_field.dart';

class RecordExpense extends StatefulWidget {
  const RecordExpense({Key? key}) : super(key: key);

  @override
  State<RecordExpense> createState() => _RecordExpenseState();
}

class _RecordExpenseState extends State<RecordExpense> {
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
          'Record an expense',
          style: AppTextStyles.blackSizeBold14,
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Expense Name",
                style: AppTextStyles.blackSize14,
              ),
              const SizedBox(
                height: 4.0,
              ),
              const TextInputField(),
              const SizedBox(
                height: 16.0,
              ),
              Text(
                "Date/Time",
                style: AppTextStyles.blackSize14,
              ),
              const SizedBox(
                height: 4.0,
              ),
              Row(
                children: [
                  const Flexible(child: TextInputField()),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: AppColors.black,
                    ),
                    child: Text(
                      "Now",
                      style: AppTextStyles.whiteSize14,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              Text(
                "Expense Cost",
                style: AppTextStyles.blackSize14,
              ),
              const SizedBox(
                height: 4.0,
              ),
              const TextInputField(),
              const SizedBox(
                height: 16.0,
              ),
              Text(
                "Expense Description",
                style: AppTextStyles.blackSize14,
              ),
              const SizedBox(
                height: 4.0,
              ),
              const TextInputField(),
              const SizedBox(
                height: 16.0,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: AppColors.black,
                ),
                child: Text(
                  "Submit",
                  style: AppTextStyles.whiteSize14,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
