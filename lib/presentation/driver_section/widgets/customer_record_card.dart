import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:greep/application/customers/user_customers_cubit.dart';
import 'package:greep/application/transactions/customer_statistics_cubit.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/money.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/customer/customer.dart';
import 'package:greep/domain/transaction/TransactionData.dart';
import 'package:greep/domain/transaction/transaction.dart';
import 'package:greep/presentation/driver_section/customer/customer_details.dart';
import 'package:greep/presentation/driver_section/transaction/transaction_details.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/presentation/widgets/turkish_symbol.dart';

class CustomerRecordCard extends StatelessWidget {
  const CustomerRecordCard(
      {Key? key,
      required this.titleStyle,
      required this.subtitleStyle,
      this.width,
      required this.transaction,
      required this.subtextTitleStyle})
      : super(key: key);

  final Transaction transaction;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final TextStyle subtextTitleStyle;
  final double? width;

  @override
  Widget build(BuildContext context) {
    String text = "";
    String subText = "";
    bool isNegative = false;
    TextStyle textStyle = titleStyle;
    String subText2 = "";

    TransactionType type = transaction.data.transactionType;
    TransactionData data = transaction.data;
    isNegative = transaction.amount < 0;
    text = transaction.amount.abs().toMoney;

    Customer? customer = GetIt.I<UserCustomersCubit>()
        .getCustomerByName(transaction.data.customerName!);

    if (customer == null) {
      var paymentType = type == TransactionType.trip && transaction.debt < 0
          ? "to pay"
          : transaction.debt > 0
              ? "to collect"
              : type == TransactionType.balance
                  ? "balanced"
                  : "balanced";
      if (paymentType.contains("collect")) {
        text = transaction.debt.abs().toString();
      }
      if (paymentType.contains("pay")) {
        text = transaction.debt.abs().toString();
      }
      subText = paymentType;

      textStyle = type == TransactionType.trip && transaction.debt < 0
          ? kDefaultTextStyle.copyWith(color: kErrorColor, fontSize: 12)
          : transaction.debt > 0
              ? kDefaultTextStyle.copyWith(color: kBlueColor, fontSize: 12)
              : type == TransactionType.balance
                  ? kDefaultTextStyle.copyWith(fontSize: 12)
                  : kDefaultTextStyle.copyWith(fontSize: 12);
    } else {
      textStyle = customer.debt < 0
          ? kDefaultTextStyle.copyWith(color: kErrorColor, fontSize: 12)
          : customer.debt > 0
              ? kDefaultTextStyle.copyWith(color: kBlueColor, fontSize: 12)
              : kDefaultTextStyle.copyWith(fontSize: 12);
      var paymentType = customer.debt < 0
          ? "to pay"
          : customer.debt > 0
              ? "to collect"
              : "balanced";
      text = customer.debt.abs().toString();
      subText = paymentType;
    }
    if (type == TransactionType.balance) {
      if (data.parentId == null || data.parentId!.isEmpty) {
        subText2 = "Customer";
      }
      var transaction =
          GetIt.I<CustomerStatisticsCubit>().getByParentBalance(data.parentId!);
      if (transaction == null || transaction.data.customerName == null) {
        subText2 = "Customer";
      } else {
        subText2 = transaction.data.customerName!;
      }
    } else {
      subText2 = data.customerName!;
    }

    return SplashTap(
      onTap: () {
        Get.to(() {
          return CustomerDetailsScreen(name: transaction.data.customerName!);
        }, transition: Transition.fadeIn);
      },
      child: Container(
        width: width ?? Get.width * 0.31,
        height: 115.h,
        padding: EdgeInsets.all((kDefaultSpacing * 0.95).r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0.r),
          border: Border.all(
            color: const Color.fromRGBO(221, 226, 224, 1),
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (isNegative)TextWidget(
                  "-",
                  style: textStyle,
                ),
                TurkishSymbol(
                  width: (11.w),
                  height: (11.h),
                  color: textStyle.color,
                ),
                TextWidget(
                  text,
                  style: textStyle,
                ),
              ],
            ),
            SizedBox(height: 8.0.h),
            TextWidget(
              subText,
              fontSize: 13,
              style: kSubtitleTextStyle,
            ),
            SizedBox(height: 8.0.h),
            TextWidget(
              subText2,
              fontSize: 13,
              overflow: TextOverflow.ellipsis,
              style: kDefaultTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
