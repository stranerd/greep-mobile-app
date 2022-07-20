import 'package:flutter/material.dart';
import 'package:get/get.dart' as g;
import 'package:get_it/get_it.dart';
import 'package:grip/application/customers/user_customers_cubit.dart';
import 'package:grip/application/transactions/customer_statistics_cubit.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/money.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/domain/customer/customer.dart';
import 'package:grip/domain/transaction/TransactionData.dart';
import 'package:grip/domain/transaction/transaction.dart';
import 'package:grip/presentation/driver_section/customer/customer_details.dart';
import 'package:grip/presentation/widgets/splash_tap.dart';
import 'package:grip/utils/constants/app_colors.dart';

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
    TextStyle subTextStyle = TextStyle();
    TransactionType type = transaction.data.transactionType;
    TransactionData data = transaction.data;
    Customer? customer = GetIt.I<UserCustomersCubit>().getCustomerByName(transaction.data.customerName!);
    if (customer==null) {
      subText =
      "N${transaction.debt < 0 ? transaction.debt.toMoney : transaction.debt
          .toMoney}";
     subTextStyle =
      type == TransactionType.trip && transaction.debt > 0
          ? kDefaultTextStyle.copyWith(color: AppColors.blue, fontSize: 12)
          : transaction.debt < 0
          ? kDefaultTextStyle.copyWith(color: AppColors.red, fontSize: 12)
          : type == TransactionType.balance
          ? kDefaultTextStyle.copyWith(fontSize: 12)
          : kDefaultTextStyle.copyWith(fontSize: 12);
    }
    else {
      subText = "N${customer.debt.toMoney.toString()}";
      subTextStyle =customer.debt > 0
          ? kDefaultTextStyle.copyWith(color: AppColors.blue, fontSize: 12)
          : customer.debt < 0
          ? kDefaultTextStyle.copyWith(color: AppColors.red, fontSize: 12)
          : kDefaultTextStyle.copyWith(fontSize: 12);
    }

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
              () => CustomerDetails(
                    name: transaction.data.customerName!,
                  ),
              transition: g.Transition.fadeIn);
        },
        child: Container(
          width: double.infinity,
          height: 50.0,
          decoration: BoxDecoration(
            color: kLightGrayColor,
            border: Border.all(
              color: const Color.fromRGBO(221, 226, 224, 1),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
            child: Row(
              children: [
                Text(
                  text,
                  style: kDefaultTextStyle,
                ),
                const Spacer(),
                Text(
                  subText,
                  style: subTextStyle,
                ),
              ],
            ),
          ),
        ));
  }
}
