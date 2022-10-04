import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:grip/presentation/widgets/text_widget.dart';
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
                  },
                  );
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
                    icon:  Icon(
                      Icons.arrow_back_ios,
                      size: 16.r,
                    ),
                    color: AppColors.black),
                title: TextWidget(
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
                                    padding: (kDefaultSpacing * 0.5).r,
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
                                      height: 80.h,
                                      width: 1.sw,
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
                      margin:  EdgeInsets.all((kDefaultSpacing * 0.5).r),
                      padding:  EdgeInsets.fromLTRB(16.r, 0, 16.r, 0),
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
                                TextWidget(

                                  "Balance status",
                                  style: AppTextStyles.blackSize12,
                                ),
                                 SizedBox(
                                  height: 4.0.h,
                                ),
                                Builder(
                                    builder: (context) {
                                      if (parentTransaction!.data.debt == 0){
                                        return TextWidget(
"Balanced",
                                          style: AppTextStyles.blackSize16,
                                        );
                                      }
                                      else {
                                        return Row(

                                            children: [
                                              TextWidget("Not Balanced (${parentTransaction!.debt < 0 ? "to pay ": "to collect "}",style: AppTextStyles.blackSize16,),
                                              TurkishSymbol(width: 13.w, height: 13.h, color: AppTextStyles.blackSize16.color),
                                              TextWidget("${parentTransaction!.debt.abs().toMoney})", style: AppTextStyles.blackSize16),]
                                        );


                                      } }
                                ),
                                 SizedBox(
                                  height: 16.0.h,
                                ),
                              ],
                            ),
                          if (transaction.data.transactionType ==
                              TransactionType.trip)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                kVerticalSpaceRegular,
                                TextWidget("Customer",
                                    style: AppTextStyles.blackSize12),
                                 SizedBox(
                                  height: 4.0.h,
                                ),
                                TextWidget(transaction.data.customerName ?? "",
                                    style: AppTextStyles.blackSize16),
                                 SizedBox(
                                  height: 16.0.h,
                                ),
                              ],
                            ),
                          if (transaction.data.transactionType ==
                              TransactionType.expense)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget("Expense",
                                    style: AppTextStyles.blackSize12),
                                 SizedBox(
                                  height: 4.0.h,
                                ),
                                TextWidget(
transaction.data.name ?? "",
                                    style: AppTextStyles.blackSize16),
                                 SizedBox(
                                  height: 16.0.h,
                                ),
                              ],
                            ),
                          TextWidget(
                            "Date/Time",
                            style: AppTextStyles.blackSize12,
                          ),
                           SizedBox(
                            height: 4.0.h,
                          ),
                          TextWidget(
                            DateFormat(
                                    "${DateFormat.ABBR_MONTH} ${DateFormat.DAY} . hh:mm a")
                                .format(transaction.timeAdded),
                            style: AppTextStyles.blackSize16,
                          ),
                           SizedBox(
                            height: 16.0.h,
                          ),
                          TextWidget(
                            "Price",
                            style: AppTextStyles.blackSize12,
                          ),
                           SizedBox(
                            height: 4.0.h,
                          ),
                          Row(
                            children: [
                              TurkishSymbol(width: 14.w,height: 14.h,color: AppTextStyles.blackSize16.color,),
                              TextWidget(
                                transaction.amount.abs().toMoney,
                                style: AppTextStyles.blackSize16,
                              ),
                            ],
                          ),
                           SizedBox(
                            height: 16.0.h,
                          ),
                          if (transaction.data.transactionType ==
                              TransactionType.trip)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(

                                  "Paid",
                                  style: AppTextStyles.blackSize12,
                                ),
                                SizedBox(
                                  height: 4.0.h,
                                ),
                                Row(
                                  children: [
                                    TurkishSymbol(width: 14.w,height: 14.h,color: AppTextStyles.blackSize16.color,),
                                    TextWidget(

                                      transaction.data.paidAmount!.toMoney,
                                      style: AppTextStyles.blackSize16,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 16.0.h,
                                ),
                                TextWidget(

                                  "Balance status",
                                  style: AppTextStyles.blackSize12,
                                ),
                                SizedBox(
                                  height: 4.0.h,
                                ),
                                Builder(
                                    builder: (context) {
                                      if (transaction.data.debt == 0){
                                        return TextWidget(
"Balanced",
                                          style: AppTextStyles.blackSize16,
                                        );
                                      }
                                      else {
                                        return Row(

                                            children: [
                                              TextWidget(
"Not Balanced (${transaction.debt < 0 ? "to pay ": "to collect "}",style: AppTextStyles.blackSize16,),
                                              TurkishSymbol(width: 13.w, height: 13.h, color: AppTextStyles.blackSize16.color),
                                              TextWidget(
"${transaction.debt.abs().toMoney})", style: AppTextStyles.blackSize16),]
                                        );


                                      } }
                                ),
                                SizedBox(
                                  height: 16.0.h,
                                ),
                              ],
                            ),
                          if (transaction.data.transactionType ==
                              TransactionType.trip)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(

                                  "Payment Type",
                                  style: AppTextStyles.blackSize12,
                                ),
                                SizedBox(
                                  height: 4.0.h,
                                ),
                                TextWidget(

                                  transaction
                                      .data.paymentType!.name.capitalize!,
                                  style: AppTextStyles.blackSize16,
                                ),
                                SizedBox(
                                  height: 16.0.h,
                                ),
                              ],
                            ),
                          TextWidget(

                            "Description",
                            style: AppTextStyles.blackSize12,
                          ),
                          SizedBox(
                            height: 4.0.h,
                          ),
                          TextWidget(

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
