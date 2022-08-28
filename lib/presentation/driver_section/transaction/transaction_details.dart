import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as g;
import 'package:get_it/get_it.dart';
import 'package:grip/application/driver/drivers_cubit.dart';
import 'package:grip/application/transactions/user_transactions_cubit.dart';
import 'package:grip/application/user/utils/get_current_user.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/money.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/domain/transaction/TransactionData.dart';
import 'package:grip/domain/transaction/transaction.dart';
import 'package:grip/presentation/driver_section/widgets/transaction_list_card.dart';
import 'package:grip/presentation/widgets/transaction_balance_widget.dart';
import 'package:grip/presentation/widgets/turkish_symbol.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_styles.dart';

class TransactionDetails extends StatefulWidget {
  final Transaction transaction;

  const TransactionDetails({Key? key, required this.transaction})
      : super(key: key);

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  late Transaction transaction;
  Transaction? parentTransaction;

  @override
  void initState() {
    transaction = widget.transaction;
    var transactions =
        GetIt.I<UserTransactionsCubit>().getCurrentUserTransactions();
    if (transactions
        .any((element) => element.id == transaction.data.parentId)) {
      parentTransaction = transactions
          .firstWhere((element) => element.id == transaction.data.parentId);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return BlocListener<UserTransactionsCubit, UserTransactionsState>(
            listener: (context, state) {
              if (state is UserTransactionsStateFetched) {
                if (state.userId == currentUser().id &&
                    state.transactions
                        .any((element) => element == transaction)) {
                  setState(() {
                    transaction = state.transactions
                        .firstWhere((element) => element == transaction);
                  });
                }
              }
            },
            child: Scaffold(
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
                elevation: 1.0,
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    if (transaction.data.transactionType ==
                        TransactionType.balance)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultSpacing * 0.5),
                        decoration: BoxDecoration(),
                        child: Column(
                          children: [
                            kVerticalSpaceRegular,
                            if (parentTransaction != null)
                              Stack(
                                children: [
                                  TransactionListCard(
                                    padding: kDefaultSpacing * 0.5,
                                    transaction: parentTransaction!,
                                    withColor: true,
                                    withBorder: true,
                                  ),
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => TransactionDetails(transaction: parentTransaction!)),
                                      );
                                    },
                                    child: Container(
                                      height: 80,
                                      width: g.Get.width,
                                      decoration: const BoxDecoration(
                                        color: Colors.transparent
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            kVerticalSpaceRegular
                          ],
                        ),
                      ),
                    Container(
                      width: g.Get.width,
                      margin: const EdgeInsets.all(kDefaultSpacing * 0.5),
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.darkGray,
                          ),
                          borderRadius: BorderRadius.circular(kDefaultSpacing)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          kVerticalSpaceRegular,
                          if (parentTransaction != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Balance status",
                                  style: AppTextStyles.blackSize12,
                                ),
                                const SizedBox(
                                  height: 4.0,
                                ),
                                Builder(
                                    builder: (context) {
                                      if (parentTransaction!.data.debt == 0){
                                        return Text("Balanced",
                                          style: AppTextStyles.blackSize16,
                                        );
                                      }
                                      else {
                                        return Row(

                                            children: [
                                              Text("Not Balanced (${parentTransaction!.debt.abs() > 0 ? "to pay ": "to collect "}",style: AppTextStyles.blackSize16,),
                                              TurkishSymbol(width: 13, height: 13, color: AppTextStyles.blackSize16.color),
                                              Text("${parentTransaction!.debt.abs().toMoney})", style: AppTextStyles.blackSize16),]
                                        );


                                      } }
                                ),
                                const SizedBox(
                                  height: 16.0,
                                ),
                              ],
                            ),
                          if (transaction.data.transactionType ==
                              TransactionType.trip)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                kVerticalSpaceRegular,
                                Text("Customer",
                                    style: AppTextStyles.blackSize12),
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
                          if (transaction.data.transactionType ==
                              TransactionType.expense)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Expense",
                                    style: AppTextStyles.blackSize12),
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
                          Row(
                            children: [
                              TurkishSymbol(width: 14,height: 14,color: AppTextStyles.blackSize16.color,),
                              Text(
                                transaction.amount.abs().toMoney,
                                style: AppTextStyles.blackSize16,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          if (transaction.data.transactionType ==
                              TransactionType.trip)
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
                                Row(
                                  children: [
                                    TurkishSymbol(width: 14,height: 14,color: AppTextStyles.blackSize16.color,),
                                    Text(
                                      transaction.data.paidAmount!.toMoney,
                                      style: AppTextStyles.blackSize16,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 16.0,
                                ),
                                Text(
                                  "Balance status",
                                  style: AppTextStyles.blackSize12,
                                ),
                                const SizedBox(
                                  height: 4.0,
                                ),
                                Builder(
                                    builder: (context) {
                                      if (transaction.data.debt == 0){
                                        return Text("Balanced",
                                          style: AppTextStyles.blackSize16,
                                        );
                                      }
                                      else {
                                        return Row(

                                            children: [
                                              Text("Not Balanced (${transaction.debt.abs() > 0 ? "to pay ": "to collect "}",style: AppTextStyles.blackSize16,),
                                              TurkishSymbol(width: 13, height: 13, color: AppTextStyles.blackSize16.color),
                                              Text("${transaction.debt.abs().toMoney})", style: AppTextStyles.blackSize16),]
                                        );


                                      } }
                                ),
                                const SizedBox(
                                  height: 16.0,
                                ),
                              ],
                            ),
                          if (transaction.data.transactionType ==
                              TransactionType.trip)
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
                                  transaction
                                      .data.paymentType!.name.capitalize!,
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
                          kVerticalSpaceRegular,
                          if (GetIt.I<DriversCubit>().selectedUser ==
                                  currentUser() &&
                              transaction.data.transactionType ==
                                  TransactionType.trip &&
                              transaction.debt != 0)
                            TransactionBalanceWidget(
                              transaction: transaction,
                            ),
                          if (GetIt.I<DriversCubit>().selectedUser ==
                              currentUser() &&
                              parentTransaction!=null &&
                              parentTransaction!.debt != 0)
                            TransactionBalanceWidget(
                              transaction: parentTransaction!,
                            ),
                          kVerticalSpaceMedium
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
