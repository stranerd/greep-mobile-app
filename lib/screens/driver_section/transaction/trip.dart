import 'package:flutter/material.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_styles.dart';

class TripScreen extends StatelessWidget {
  const TripScreen({Key? key}) : super(key: key);

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
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Customer", style: AppTextStyles.blackSize12),
              const SizedBox(
                height: 4.0,
              ),
              Text("Kemi Olunloyo", style: AppTextStyles.blackSize16),
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
                "Destination Count",
                style: AppTextStyles.blackSize12,
              ),
              const SizedBox(
                height: 4.0,
              ),
              Text(
                "02",
                style: AppTextStyles.blackSize16,
              ),
              const SizedBox(
                height: 16.0,
              ),
              Text(
                "Price",
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
                "Paid",
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
                "Discount",
                style: AppTextStyles.blackSize12,
              ),
              const SizedBox(
                height: 4.0,
              ),
              Text(
                "0%",
                style: AppTextStyles.blackSize16,
              ),
              const SizedBox(
                height: 16.0,
              ),
              Text(
                "Payment Type",
                style: AppTextStyles.blackSize12,
              ),
              const SizedBox(
                height: 4.0,
              ),
              Text(
                "Cash",
                style: AppTextStyles.blackSize16,
              ),
              const SizedBox(
                height: 16.0,
              ),
              Text(
                "Trip Description",
                style: AppTextStyles.blackSize12,
              ),
              const SizedBox(
                height: 4.0,
              ),
              Text(
                "From NEU to Kathodon and back to NEU",
                style: AppTextStyles.blackSize16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
