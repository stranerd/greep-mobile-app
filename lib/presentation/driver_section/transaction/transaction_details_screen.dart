import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:greep/application/driver/drivers_cubit.dart';
import 'package:greep/application/transactions/user_transactions_cubit.dart';
import 'package:greep/application/user/utils/get_current_user.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/transaction/TransactionData.dart';
import 'package:greep/domain/transaction/transaction.dart';
import 'package:greep/presentation/driver_section/widgets/transaction_list_card.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/box_shadow_container.dart';
import 'package:greep/presentation/widgets/confirmation_dialog.dart';
import 'package:greep/presentation/widgets/money_widget.dart';
import 'package:greep/presentation/widgets/profile_photo_widget.dart';
import 'package:greep/presentation/widgets/sub_header_text.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/presentation/widgets/time_dot_widget.dart';
import 'package:greep/presentation/widgets/transaction_balance_widget.dart';
import 'package:greep/presentation/widgets/turkish_symbol.dart';
import 'package:greep/utils/constants/app_colors.dart';

class TransactionDetailsScreen extends StatefulWidget {
  final Transaction transaction;

  const TransactionDetailsScreen({Key? key, required this.transaction})
      : super(key: key);

  @override
  _TransactionDetailsScreenState createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
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
    bool isExpense =
        widget.transaction.data.transactionType == TransactionType.expense;
    return BlocListener<UserTransactionsCubit, UserTransactionsState>(
      listener: (context, state) {
        if (state is UserTransactionsStateFetched) {
          if (state.userId == currentUser().id &&
              state.transactions.any((element) => element == transaction)) {
            setState(
              () {
                transaction = state.transactions
                    .firstWhere((element) => element == transaction);
              },
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: const BackIcon(
            isArrow: true,
          ),
          title: TextWidget(
            "Details",
            weight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        body: SafeArea(
          child: Container(
            height: 1.sh,
            width: 1.sw,
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(
                    kDefaultSpacing.r,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BoxShadowContainer(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              isExpense
                                  ? MoneyWidget(
                                      amount: widget.transaction.amount,
                                      isNegative: true,
                                      size: 16,
                                      weight: FontWeight.bold,
                                    )
                                  : Row(
                                      children: [
                                        TextWidget(
                                          "+${widget.transaction.amount}",
                                          fontSize: 18.sp,
                                          weight: FontWeight.bold,
                                        ),
                                        TurkishSymbol(
                                          width: 16.r,
                                          height: 16.r,
                                        ),
                                      ],
                                    ),
                              SizedBox(
                                height: 2.h,
                              ),
                              TextWidget(
                                isExpense
                                    ? "Expense"
                                    : transaction.data.transactionType ==
                                            TransactionType.balance
                                        ? "Balance"
                                        : "Trip with ${widget.transaction.data.customerName}",
                                color: AppColors.veryLightGray,
                                fontSize: 12.sp,
                              )
                            ],
                          ),
                          ProfilePhotoWidget(
                            url: "",
                            initials:
                                widget.transaction.data.customerName ?? "",
                            radius: 22,
                          ),
                        ],
                      )),
                      if (transaction.data.transactionType ==
                          TransactionType.balance)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            kVerticalSpaceMedium,
                            TextWidget(
                              "Original transaction",
                              weight: FontWeight.bold,
                              fontSize: 13.sp,
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            if (parentTransaction != null)
                              Stack(
                                children: [
                                  TransactionListCard(
                                    transaction: parentTransaction!,
                                    withColor: true,
                                    withBorder: true,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TransactionDetailsScreen(
                                                    transaction:
                                                        parentTransaction!)),
                                      );
                                    },
                                    child: Container(
                                      height: 80.h,
                                      width: 1.sw,
                                      decoration: const BoxDecoration(
                                          color: Colors.transparent),
                                    ),
                                  )
                                ],
                              ),
                          ],
                        ),
                      kVerticalSpaceMedium,
                      BoxShadowContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buidItem("Price", "N/A",
                                widgetValue: MoneyWidget(
                                  amount: widget.transaction.amount,
                                  flipped: true,
                                  size: 14,
                                )),
                            if (!isExpense)
                              Column(
                                children: [
                                  kVerticalSpaceRegular,
                                  _buidItem(
                                    "Extra Charges",
                                    "N/A",
                                    widgetValue: const MoneyWidget(
                                      amount: 0,
                                      flipped: true,
                                      size: 14,
                                    ),
                                  ),
                                ],
                              ),
                            if (!isExpense)
                              Column(
                                children: [
                                  kVerticalSpaceRegular,
                                  _buidItem(
                                    "Discount",
                                    "N/A",
                                    widgetValue: const MoneyWidget(
                                      amount: 0,
                                      flipped: true,
                                      size: 14,
                                    ),
                                  ),
                                ],
                              ),
                            if (!isExpense)
                              Column(
                                children: [
                                  kVerticalSpaceRegular,
                                  _buidItem("Payment Amount", "",
                                      widgetValue: MoneyWidget(
                                        amount: widget
                                                .transaction.data.paidAmount ??
                                            0,
                                        flipped: true,
                                        size: 14,
                                      )),
                                ],
                              ),
                            kVerticalSpaceRegular,
                            _buidItem(
                                "Payment Type",
                                widget.transaction.data.paymentType?.name ??
                                    "wallet"),
                          ],
                        ),
                      ),
                      kVerticalSpaceRegular,
                      BoxShadowContainer(
                          child: Column(
                        children: [
                          _buidItem(
                            "Description",
                            widget.transaction.description,
                          ),
                          kVerticalSpaceRegular,
                          _buidItem("TransactionID", widget.transaction.id),
                          kVerticalSpaceRegular,
                          _buidItem(
                            "Time",
                            "",
                            widgetValue: TimeDotWidget(
                              date: widget.transaction.timeAdded,
                              color: AppColors.black,
                              showYear: true,
                            ),
                          ),
                          kVerticalSpaceRegular,
                        ],
                      )),
                      kVerticalSpaceRegular,
                      if (!isExpense && transaction.debt.isGreaterThan(0))
                        BoxShadowContainer(
                            child: Column(
                          children: [
                            _buidItem(
                              "Balance",
                              "",
                              widgetValue: MoneyWidget(
                                amount: transaction.debt.abs(),
                                flipped: true,
                              ),
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
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
                                parentTransaction != null &&
                                parentTransaction!.debt != 0)
                              TransactionBalanceWidget(
                                transaction: parentTransaction!,
                              ),
                          ],
                        )),
                      kVerticalSpaceLarge,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buidItem(String title, String value, {Widget? widgetValue}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
          title,
          color: AppColors.veryLightGray,
          fontSize: 14.sp,
        ),
        (widgetValue != null)
            ? widgetValue
            : TextWidget(
                value,
                fontSize: 14.sp,
              )
      ],
    );
  }
}
