import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' as g;
import 'package:get_it/get_it.dart';
import 'package:greep/application/transactions/customer_statistics_cubit.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/money.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/transaction/TransactionData.dart';
import 'package:greep/domain/transaction/transaction.dart';
import 'package:greep/presentation/driver_section/customer/customer_details.dart';
import 'package:greep/presentation/widgets/money_widget.dart';
import 'package:greep/presentation/widgets/profile_photo_widget.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/presentation/widgets/turkish_symbol.dart';
import 'package:greep/utils/constants/app_colors.dart';

class CustomerCardView extends StatelessWidget {
  const CustomerCardView({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    String text = "";
    String subText = "";
    String initial = "";
    TextStyle subTextStyle = TextStyle();
    TransactionType type = transaction.data.transactionType;
    TransactionData data = transaction.data;
      subText =
      transaction.debt < 0 ? transaction.debt.abs().toMoney : transaction.debt.abs()
          .toMoney;
     subTextStyle =
      type == TransactionType.trip && transaction.debt > 0
          ? kDefaultTextStyle.copyWith(color: AppColors.blue, fontSize: 12.sp)
          : transaction.debt < 0
          ? kDefaultTextStyle.copyWith(color: AppColors.red, fontSize: 12.sp)
          : type == TransactionType.balance
          ? kDefaultTextStyle.copyWith(fontSize: 12.sp)
          : kDefaultTextStyle.copyWith(fontSize: 12.sp);

    if (type == TransactionType.balance) {
      if (data.parentId == null || data.parentId!.isEmpty) {
        text = "Customer";
      }
      var transaction = GetIt.I<CustomerStatisticsCubit>()
          .getByParentBalance(data.parentId!);
      if (transaction == null || transaction.data.customerName == null) {
        text = "Customer";
      } else {
        text = transaction.data.customerName!;
      }
    } else {
      text = data.customerName!;
    }

    return SplashTap(
        onTap: () {
          g.Get.to(
              () => CustomerDetailsScreen(
                    name: transaction.data.customerName!,
                  ),
              transition: g.Transition.fadeIn);
        },
        child: Container(
          width: double.infinity,
          height: 50.0.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r,),
            border:
            Border.all(color: AppColors.lightGray, width: 2),

          ),
          child: Padding(
            padding:  EdgeInsets.fromLTRB(16.0.r, 0, 16.0.r, 0),
            child: Row(
              children: [
                Row(
                  children: [
                    ProfilePhotoWidget(url: "",initials: transaction.data.customerName ?? "",),
                    kHorizontalSpaceSmall,
                    TextWidget(
                      text,
                      weight: FontWeight.w600,
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MoneyWidget(amount: num.tryParse(subText) ?? 0),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
