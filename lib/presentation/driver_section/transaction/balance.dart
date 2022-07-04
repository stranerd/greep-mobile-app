import 'package:flutter/material.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_styles.dart';
import '../widgets/transactions_card.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({Key? key}) : super(key: key);

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
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(
                      width: 1, color: const Color.fromRGBO(221, 226, 224, 1)),
                ),
                child: Container()
              ),
              const SizedBox(height: 16.0),
              Text("Debt of the trip above settled ",
                  style: AppTextStyles.blackSize12),
              const SizedBox(
                height: 4.0,
              ),
              Text(
                "\$5 Paid",
                style: AppTextStyles.blackSize16,
              ),
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
                "Mar 19 . 3:54 PM",
                style: AppTextStyles.blackSize16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
