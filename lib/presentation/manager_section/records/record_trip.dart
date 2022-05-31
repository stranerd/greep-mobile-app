import 'package:flutter/material.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_styles.dart';

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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        child: SafeArea(
          child: SingleChildScrollView(
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
                // const TextInputField(),
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
                //  const TextInputField(),
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
                // const TextInputField(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
