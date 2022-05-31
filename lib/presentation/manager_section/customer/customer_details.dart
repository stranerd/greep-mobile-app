import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_styles.dart';
import '../widgets/record_card.dart';
import '../widgets/transaction_list_card.dart';

class CustomerDetails extends StatefulWidget {
  const CustomerDetails({Key? key}) : super(key: key);

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
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
          'Customer Details',
          style: AppTextStyles.blackSizeBold16,
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
                  "Kemi Olunloye",
                  style: AppTextStyles.blackSizeBold16,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Text(
                  "Account",
                  style: AppTextStyles.blackSizeBold12,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RecordCard(
                        title: "\$164",
                        subtitle: "Total paid",
                        titleStyle: AppTextStyles.greenSize16,
                        subtitleStyle: AppTextStyles.blackSize12),
                    RecordCard(
                        title: "\$8",
                        subtitle: "To collect",
                        titleStyle: AppTextStyles.blueSize16,
                        subtitleStyle: AppTextStyles.blackSize12),
                    RecordCard(
                        title: "\$0",
                        subtitle: "To pay",
                        titleStyle: AppTextStyles.redSize16,
                        subtitleStyle: AppTextStyles.blackSize12),
                  ],
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Text(
                  "Settle debt",
                  style: AppTextStyles.blackSizeBold12,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 180.w,
                      padding: const EdgeInsets.fromLTRB(16, 16, 64, 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: const Color.fromRGBO(243, 246, 248, 1),
                      ),
                      child: Text("\$8", style: AppTextStyles.blueSize14),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: AppColors.black,
                      ),
                      child: Text("Balance", style: AppTextStyles.whiteSize14),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32.0,
                ),
                Text("Transaction history",
                    style: AppTextStyles.blackSizeBold12),
                const SizedBox(
                  height: 8.0,
                ),
                Column(
                  children: [
                    TransactionListCard(
                      title: "Trip",
                      subtitle: "Mar 19 . 10:54 AM",
                      trailing: "+20\$",
                      titleStyle: AppTextStyles.blackSize14,
                      subtitleStyle: AppTextStyles.blackSize12,
                      trailingStyle: AppTextStyles.greenSize14,
                    ),
                    const SizedBox(height: 16.0),
                    TransactionListCard(
                      title: "To collect",
                      subtitle: "Mar 19 . 10:54 AM",
                      trailing: "8\$",
                      titleStyle: AppTextStyles.blackSize14,
                      subtitleStyle: AppTextStyles.blackSize12,
                      trailingStyle: AppTextStyles.blueSize14,
                    ),
                    const SizedBox(height: 16.0),
                    TransactionListCard(
                      title: "Balance paid",
                      subtitle: "Mar 19 . 10:54 AM",
                      trailing: "6\$",
                      titleStyle: AppTextStyles.blackSize14,
                      subtitleStyle: AppTextStyles.blackSize12,
                      trailingStyle: AppTextStyles.blackSize14,
                    ),
                    const SizedBox(height: 16.0),
                    TransactionListCard(
                      title: "To pay",
                      subtitle: "Mar 19 . 10:54 AM",
                      trailing: "6\$",
                      titleStyle: AppTextStyles.blackSize14,
                      subtitleStyle: AppTextStyles.blackSize12,
                      trailingStyle: AppTextStyles.redSize14,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
