import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_styles.dart';
import '../../../utils/constants/text_field.dart';

class RecordTrip extends StatefulWidget {
  const RecordTrip({Key? key}) : super(key: key);

  @override
  State<RecordTrip> createState() => _RecordTripState();
}

class _RecordTripState extends State<RecordTrip> {
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
          'Record a trip',
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
                "Customer Name",
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
                "Destination Count",
                style: AppTextStyles.blackSize14,
              ),
              const SizedBox(
                height: 4.0,
              ),
              const TextInputField(),
              SizedBox(
                height: 16.h,
              ),
              Row(
                children: [
                  Text("Price", style: AppTextStyles.blackSize14),
                  SizedBox(width: 130.w),
                  Text("Paid", style: AppTextStyles.blackSize14),
                ],
              ),
              SizedBox(height: 4.h),
              Row(
                children: const [
                  Flexible(child: TextInputField()),
                  SizedBox(
                    width: 16.0,
                  ),
                  Flexible(child: TextInputField()),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                children: [
                  Text("Discount", style: AppTextStyles.blackSize14),
                  SizedBox(width: 130.w),
                  Text("Payment Type", style: AppTextStyles.blackSize14),
                ],
              ),
              SizedBox(height: 4.h),
              Row(
                children: const [
                  Flexible(child: TextInputField()),
                  SizedBox(
                    width: 16.0,
                  ),
                  Flexible(child: TextInputField()),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              Text(
                "Trip Description",
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
