import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greep/presentation/driver_section/records/record_expense.dart';
import 'package:greep/presentation/driver_section/records/record_trip.dart';
import 'package:greep/presentation/widgets/app_dialog.dart';
import 'package:greep/utils/constants/app_colors.dart';
import 'package:greep/utils/constants/app_styles.dart';

class AddRecordDialog extends StatefulWidget {
  const AddRecordDialog({Key? key}) : super(key: key);

  @override
  _AddRecordDialogState createState() => _AddRecordDialogState();
}

class _AddRecordDialogState extends State<AddRecordDialog> {
  @override
  Widget build(BuildContext context) {
    return AppDialog(
        title: "Add a record",
        height: 0.75.sh,
        child: DefaultTabController(
          length: 2,
          child: Container(

            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(width: 1, color: AppColors.black)),
                  child: TabBar(
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: Colors.black,
                    ),
                    labelColor: Colors.white,
                    labelStyle: AppTextStyles.whiteSize12,
                    unselectedLabelColor: Colors.black,
                    unselectedLabelStyle: AppTextStyles.blackSize12,
                    tabs: [
                      Tab(
                        height: 35.h,
                        text: 'Trip',
                      ),
                      Tab(
                        height: 35.h,
                        text: 'Expense',
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  child: TabBarView(
                    children: [
                      RecordTrip(),
                      RecordExpense(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
