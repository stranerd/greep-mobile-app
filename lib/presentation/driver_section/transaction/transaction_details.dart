import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as g;
import 'package:get_it/get_it.dart';
import 'package:greep/application/driver/drivers_cubit.dart';
import 'package:greep/application/transactions/user_transactions_cubit.dart';
import 'package:greep/application/user/utils/get_current_user.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/money.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/transaction/TransactionData.dart';
import 'package:greep/domain/transaction/transaction.dart';
import 'package:greep/presentation/driver_section/widgets/transaction_list_card.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/presentation/widgets/transaction_balance_widget.dart';
import 'package:greep/presentation/widgets/turkish_symbol.dart';
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

  bool showTrips = true;

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
              backgroundColor: Colors.white,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 220.h,
                        width: 1.sw,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                AssetImage("assets/images/transaction_bg.png"),
                            scale: 2,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: 18.w,
                              bottom: 18.h,
                              child: Image.asset(
                                "assets/images/transaction_car.png",
                                scale: 2,
                              ),
                            ),
                            Positioned(
                              top: 30.h,
                              right: 18.w,
                              child: Container(
                                alignment: AlignmentDirectional.centerEnd,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    TextWidget(
                                      "${DateFormat("${DateFormat.ABBR_WEEKDAY}, ${DateFormat.ABBR_MONTH} ${DateFormat.DAY}, ${DateFormat.YEAR}").format(widget.transaction.timeAdded)}",
                                      fontSize: 12,
                                      weight: FontWeight.bold,
                                      letterSpacing: 1.3,
                                    ),
                                    TextWidget(
                                      "${DateFormat("hh:${DateFormat.MINUTE} a").format(widget.transaction.timeAdded)}",
                                      fontSize: 12,
                                      weight: FontWeight.bold,
                                      letterSpacing: 1.3,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 18.w,
                              top: 60.h,
                              child: Image.asset(
                                "assets/images/transaction_greep.png",
                                scale: 2,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: Container(
                                width: 230.w,
                                height: 40.h,
                                padding: EdgeInsets.only(left: 10.w),
                                // alignment: Alignment.centerLeft,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                        "assets/images/transaction_name_bg.png",
                                      ),
                                      fit: BoxFit.cover,
                                      scale: 2),
                                ),
                                child: FittedBox(
                                  child: TextWidget(
                                    widget.transaction.data.customerName ?? "",
                                    color: kWhiteColor,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      kVerticalSpaceRegular,
                      Column(
                        children: [
                          if (transaction.data.transactionType ==
                              TransactionType.balance)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultSpacing * 0.5),
                              decoration: const BoxDecoration(),
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
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TransactionDetails(
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
                                  kVerticalSpaceRegular
                                ],
                              ),
                            ),
                          Container(
                            width: g.Get.width,
                            margin: EdgeInsets.all((kDefaultSpacing * 0.5).r),
                            padding: EdgeInsets.fromLTRB(16.r, 0, 16.r, 0),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(kDefaultSpacing)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const TextWidget(
                                      "Total",
                                      weight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            TurkishSymbol(
                                              width: 23.w,
                                              height: 23.h,
                                              color: AppTextStyles
                                                  .blackSize16.color,
                                            ),
                                            TextWidget(
                                              transaction.amount.abs().toMoney,
                                              style: AppTextStyles.blackSize16,
                                              fontSize: 25,
                                              weight: FontWeight.bold,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/transaction_status_tick.svg",
                                              color: transaction.data.debt == 0
                                                  ? kBlackColor
                                                  : (transaction.data.debt ??
                                                              0) <
                                                          0
                                                      ? AppColors.red
                                                      : AppColors.blue,
                                            ),
                                            kHorizontalSpaceTiny,
                                            TextWidget(
                                              transaction.data.debt == 0
                                                  ? "Balanced"
                                                  : (transaction.data.debt ??
                                                              0) <
                                                          0
                                                      ? "To Pay"
                                                      : "To Collect",
                                              fontSize: 16,
                                              color: transaction.data.debt == 0
                                                  ? kBlackColor
                                                  : (transaction.data.debt ??
                                                              0) <
                                                          0
                                                      ? AppColors.red
                                                      : AppColors.blue,
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                kVerticalSpaceRegular,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const TextWidget(
                                      "Paid",
                                      weight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                    Row(
                                      children: [
                                        TurkishSymbol(
                                          width: 20.w,
                                          height: 20.h,
                                          color:
                                              AppTextStyles.blackSize16.color,
                                        ),
                                        TextWidget(
                                          transaction.amount.abs().toMoney,
                                          style: AppTextStyles.blackSize16,
                                          fontSize: 22,
                                          weight: FontWeight.bold,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                kVerticalSpaceRegular,
                                const Divider(
                                  color: AppColors.lightBlue,
                                ),
                                kVerticalSpaceRegular,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const TextWidget(
                                      "Trip Information",
                                      weight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            showTrips = !showTrips;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            left: 40.w,
                                          ),
                                          child: Icon(!showTrips
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down),
                                        ))
                                  ],
                                ),
                                kVerticalSpaceMedium,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 25.w,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(
                                            kDefaultSpacing * 0.2,
                                          ),
                                          height: 25.w,
                                          decoration: const BoxDecoration(
                                            color: AppColors.blue,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Image.asset(
                                            "assets/icons/map_navigator.png",
                                            color: kWhiteColor,
                                            scale: 4.5,
                                          ),
                                        ),
                                        kHorizontalSpaceSmall,
                                        const TextWidget("Got a trip")
                                      ],
                                    ),
                                    const TextWidget(
                                      "No Data",
                                    )
                                  ],
                                ),
                                kVerticalSpaceRegular,
                                const Divider(
                                  color: AppColors.lightBlue,
                                ),
                                kVerticalSpaceRegular,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 25.w,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(
                                            kDefaultSpacing * 0.2,
                                          ),
                                          height: 25.w,
                                          decoration: const BoxDecoration(
                                            color: AppColors.green,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Image.asset(
                                            "assets/icons/map_navigator.png",
                                            color: kWhiteColor,
                                            scale: 4.5,
                                          ),
                                        ),
                                        kHorizontalSpaceSmall,
                                        const TextWidget("Start trip")
                                      ],
                                    ),
                                    const TextWidget(
                                      "No Data",
                                    )
                                  ],
                                ),
                                kVerticalSpaceRegular,
                                const Divider(
                                  color: AppColors.lightBlue,
                                ),
                                kVerticalSpaceRegular,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 25.w,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(
                                            kDefaultSpacing * 0.2,
                                          ),
                                          height: 25.w,
                                          decoration: const BoxDecoration(
                                            color: AppColors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Image.asset(
                                            "assets/icons/map_navigator.png",
                                            color: kWhiteColor,
                                            scale: 4.5,
                                          ),
                                        ),
                                        kHorizontalSpaceSmall,
                                        const TextWidget("End trip")
                                      ],
                                    ),
                                    const TextWidget(
                                      "No Data",
                                    )
                                  ],
                                ),
                                kVerticalSpaceRegular,
                                const Divider(
                                  color: AppColors.lightBlue,
                                ),
                                kVerticalSpaceRegular,
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: const [
                                    TextWidget("Distance covered",color: AppColors.lightBlack,),
                                    TextWidget(
                                      "12km",
                                      color: AppColors.veryLightGray,
                                      fontSize: 18,
                                    )
                                  ],
                                ),
                                kVerticalSpaceRegular,
                                const Divider(
                                  color: AppColors.lightBlue,
                                ),
                                kVerticalSpaceRegular,
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: const [
                                    TextWidget("Trip duration",color: AppColors.lightBlack,),
                                    TextWidget(
                                      "15 minutes",
                                      color: AppColors.veryLightGray,
                                      fontSize: 18,
                                    )
                                  ],
                                ),
                                kVerticalSpaceRegular,
                                const Divider(
                                  color: AppColors.lightBlue,
                                ),
                                kVerticalSpaceRegular,
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children:  [
                                    TextWidget("Description",color: AppColors.lightBlack,),
                                    TextWidget(
                                      widget.transaction.description,
                                      color: AppColors.veryLightGray,
                                      fontSize: 18,
                                      style: kDefaultTextStyle.copyWith(
                                        fontStyle: FontStyle.italic
                                      ),
                                    )
                                  ],
                                ),
                                kVerticalSpaceRegular,
                                const Divider(
                                  color: AppColors.lightBlue,
                                ),
                                kVerticalSpaceRegular,
                                if (parentTransaction != null)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        "Balance status",
                                        style: AppTextStyles.blackSize12,
                                      ),
                                      SizedBox(
                                        height: 4.0.h,
                                      ),
                                      Builder(builder: (context) {
                                        if (parentTransaction!.data.debt == 0) {
                                          return TextWidget(
                                            "Balanced",
                                            style: AppTextStyles.blackSize16,
                                          );
                                        } else {
                                          return Row(children: [
                                            TextWidget(
                                              "Not Balanced (${parentTransaction!.debt < 0 ? "to pay " : "to collect "}",
                                              style: AppTextStyles.blackSize16,
                                            ),
                                            TurkishSymbol(
                                                width: 13.w,
                                                height: 13.h,
                                                color: AppTextStyles
                                                    .blackSize16.color),
                                            TextWidget(
                                                "${parentTransaction!.debt.abs().toMoney})",
                                                style:
                                                    AppTextStyles.blackSize16),
                                          ]);
                                        }
                                      }),
                                      SizedBox(
                                        height: 16.0.h,
                                      ),
                                    ],
                                  ),
                                // if (transaction.data.transactionType ==
                                //     TransactionType.trip)
                                // if (transaction.data.transactionType ==
                                //     TransactionType.expense)
                                //   Column(
                                //     crossAxisAlignment:
                                //         CrossAxisAlignment.start,
                                //     children: [
                                //       TextWidget("Expense",
                                //           style: AppTextStyles.blackSize12),
                                //       SizedBox(
                                //         height: 4.0.h,
                                //       ),
                                //       TextWidget(transaction.data.name ?? "",
                                //           style: AppTextStyles.blackSize16),
                                //       SizedBox(
                                //         height: 16.0.h,
                                //       ),
                                //     ],
                                //   ),
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
                                    parentTransaction != null &&
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
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }
}
