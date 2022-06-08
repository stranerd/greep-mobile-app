import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/transactions/customer_statistics_cubit.dart';
import 'package:grip/application/transactions/user_transactions_cubit.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/commons/money.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/domain/transaction/TransactionData.dart';
import 'package:grip/domain/transaction/transaction.dart';
import 'package:grip/presentation/driver_section/widgets/transactions_card.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_styles.dart';

class TransactionDetails extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetails({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      Transaction? parentBalance;
      if (transaction.data.transactionType == TransactionType.balance) {
        parentBalance = GetIt.I<CustomerStatisticsCubit>().getByParentBalance(
            GetIt.I<UserCubit>().userId!, transaction.data.parentId!);
      }
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
                if (transaction.data.transactionType ==
                        TransactionType.balance &&
                    parentBalance != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        margin: const EdgeInsets.only(
                            bottom: kDefaultSpacing * 0.5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(
                              width: 1,
                              color: const Color.fromRGBO(221, 226, 224, 1)),
                        ),
                        child: TransactionCard(
                            title: "",
                            transaction: parentBalance,
                            subtitle: "",
                            trailing: "",
                            titleStyle: TextStyle(),
                            subtitleStyle: const TextStyle(),
                            trailingStyle: const TextStyle(),
                            subTrailing: "",
                            subTrailingStyle: const TextStyle()),
                      ),
                      kVerticalSpaceRegular,
                    ],
                  ),
                if (transaction.data.transactionType == TransactionType.balance)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("From the trip above",
                          style: AppTextStyles.blackSize12),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Text("Price > Paid", style: AppTextStyles.blackSize16),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Text("Therefore you have to collect",
                          style: AppTextStyles.blackSize12),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Text(
                          "N${parentBalance!.amount.toMoney} - N${parentBalance.data.paidAmount!.toMoney} = N${(parentBalance.amount - parentBalance.data.paidAmount!).toMoney}",
                          style: AppTextStyles.blackSize16),
                      const SizedBox(
                        height: 16.0,
                      ),
                    ],
                  ),
                if (transaction.data.transactionType == TransactionType.trip)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Customer", style: AppTextStyles.blackSize12),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Text(transaction.data.customerName ?? "",
                          style: AppTextStyles.blackSize16),
                      const SizedBox(
                        height: 16.0,
                      ),
                    ],
                  ),
                if (transaction.data.transactionType == TransactionType.expense)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Expense", style: AppTextStyles.blackSize12),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Text(transaction.data.name ?? "",
                          style: AppTextStyles.blackSize16),
                      const SizedBox(
                        height: 16.0,
                      ),
                    ],
                  ),
                Text(
                  "Date/Time",
                  style: AppTextStyles.blackSize12,
                ),
                const SizedBox(
                  height: 4.0,
                ),
                Text(
                  DateFormat(
                          "${DateFormat.ABBR_MONTH} ${DateFormat.DAY} . hh:mm a")
                      .format(transaction.timeAdded),
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
                  "N${transaction.amount.toMoney}",
                  style: AppTextStyles.blackSize16,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                if (transaction.data.transactionType == TransactionType.trip)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Paid",
                        style: AppTextStyles.blackSize12,
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        "N${transaction.data.paidAmount!.toMoney}",
                        style: AppTextStyles.blackSize16,
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                    ],
                  ),
                if (transaction.data.transactionType == TransactionType.trip)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Payment Type",
                        style: AppTextStyles.blackSize12,
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        transaction.data.paymentType!.name.capitalize!,
                        style: AppTextStyles.blackSize16,
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                    ],
                  ),
                Text(
                  "Description",
                  style: AppTextStyles.blackSize12,
                ),
                const SizedBox(
                  height: 4.0,
                ),
                Text(
                  transaction.description,
                  style: AppTextStyles.blackSize16,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
