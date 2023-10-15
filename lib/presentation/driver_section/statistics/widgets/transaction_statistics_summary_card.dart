import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greep/presentation/widgets/money_widget.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/presentation/widgets/turkish_symbol.dart';
import 'package:greep/utils/constants/app_colors.dart';

class TransactionStatisticsSummaryCard extends StatelessWidget {
  final num target;
  final num income;
  final num trips;
  final num expenses;
  final num withdrawals;

  const TransactionStatisticsSummaryCard(
      {Key? key,
      required this.target,
      required this.income,
      required this.trips,
      required this.expenses,
      required this.withdrawals})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: [
            Row(
              children: [
                Container(
                  width: constraints.maxWidth * 0.5,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  decoration: ShapeDecoration(
                    color: AppColors.coinGold,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 2.w,
                        strokeAlign: BorderSide.strokeAlignOutside,
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(
                        6.r,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MoneyWidget(amount: target,color: AppColors.white,),
                      TextWidget(
                        'Target',
                        fontSize: 10.sp,
                        textAlign: TextAlign.center,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: constraints.maxWidth * 0.5,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  decoration: ShapeDecoration(
                    color: AppColors.green,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 2.w,
                        strokeAlign: BorderSide.strokeAlignOutside,
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(
                        6.r,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MoneyWidget(
                        amount: income,
                        weight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                      TextWidget(
                        'Income',
                        fontSize: 10.sp,
                        textAlign: TextAlign.center,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h,),
            Row(
              children: [
                Container(
                  width: constraints.maxWidth * 0.33,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  decoration: ShapeDecoration(
                    color: AppColors.blue,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 2.w,
                        strokeAlign: BorderSide.strokeAlignOutside,
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(
                        6.r,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MoneyWidget(amount: trips,color: AppColors.white,),
                      TextWidget(
                        'Trips',
                        fontSize: 10.sp,
                        textAlign: TextAlign.center,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: constraints.maxWidth * 0.33,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  decoration: ShapeDecoration(
                    color: AppColors.red,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 2.w,
                        strokeAlign: BorderSide.strokeAlignOutside,
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(
                        6.r,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MoneyWidget(amount: expenses,color: AppColors.white,),
                      TextWidget(
                        'Expenses',
                        fontSize: 10.sp,
                        textAlign: TextAlign.center,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ),

                Container(
                  width: constraints.maxWidth * 0.33,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  decoration: ShapeDecoration(
                    color: AppColors.blueGreen,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 2.w,
                        strokeAlign: BorderSide.strokeAlignOutside,
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(
                        6.r,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MoneyWidget(
                        amount: withdrawals,
                        weight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                      TextWidget(
                        'Withdrawals',
                        fontSize: 10.sp,
                        textAlign: TextAlign.center,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),

          ],
        );
      }),
    );
  }
}
