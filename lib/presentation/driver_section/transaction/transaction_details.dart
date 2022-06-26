import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/driver/drivers_cubit.dart';
import 'package:grip/application/transactions/customer_statistics_cubit.dart';
import 'package:grip/application/transactions/user_transactions_cubit.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/application/user/utils/get_current_user.dart';
import 'package:grip/commons/money.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/domain/transaction/TransactionData.dart';
import 'package:grip/domain/transaction/transaction.dart';
import 'package:grip/presentation/driver_section/widgets/transactions_card.dart';
import 'package:grip/presentation/widgets/transaction_balance_widget.dart';
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
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (transaction.data.transactionType == TransactionType.balance)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      kVerticalSpaceRegular,
                    ],
                  ),
                if (transaction.data.transactionType == TransactionType.trip)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if ((transaction.debt > 0 || transaction.credit > 0) && GetIt.I<DriversCubit>().selectedUser == currentUser())
                        Builder(builder: (c) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Settle pending balance",
                                style: AppTextStyles.blackSizeBold12,
                              ),
                              kVerticalSpaceSmall,
                              TransactionBalanceWidget(
                                withDetails: false,
                                transaction: transaction,
                                customerName: transaction.data.customerName!,
                              )
                            ],
                          );
                        }),
                      kVerticalSpaceRegular,
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
