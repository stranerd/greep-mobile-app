import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/transactions/response/transaction_summary.dart';
import 'package:grip/application/transactions/transaction_summary_cubit.dart';
import 'package:grip/application/driver/drivers_cubit.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/commons/money.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/presentation/widgets/driver_selector_widget.dart';
import 'package:grip/presentation/widgets/splash_tap.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_styles.dart';
import '../widgets/transactions_card.dart';
import 'balance.dart';
import 'to_collect_screen.dart';
import 'to_pay_screen.dart';
import 'transaction_details.dart';
import 'view_expense.dart';
import 'view_range_transactions.dart';

class TransactionView extends StatefulWidget {
  const TransactionView({Key? key}) : super(key: key);

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  Map<DateTime, TransactionSummary> transactions = {};

  DateTime? from;
  DateTime? to;
  bool showAppBar = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    var route =  ModalRoute.of(context);
    try {if (route !=null){
      dynamic args =route.settings.arguments;
      setState(() {
        transactions =
            GetIt.I<TransactionSummaryCubit>().getMonthlyTransactions();
        showAppBar =  (args["showAppBar"] == true);
      });
    }}
    catch (_){

    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionSummaryCubit, TransactionSummaryState>(
        listener: (context, state) {
      if (state is TransactionSummaryStateDone) {
        setState(() {
          transactions =
              GetIt.I<TransactionSummaryCubit>().getMonthlyTransactions();
        });
      }
    }, builder: (context, state) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: showAppBar ?  AppBar(
            toolbarHeight: 30,
            automaticallyImplyLeading: true,
          ): null,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultSpacing * 0.5,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Greep",
                        style: AppTextStyles.blackSizeBold16,
                      ),
                    ),
                  ),
                  kVerticalSpaceSmall,
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: DriverSelectorRow()),
                  kVerticalSpaceSmall,
                  BlocBuilder<DriversCubit, DriversState>(
                    builder: (context, driverState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          driverState is! DriversStateManager ? Align(
                            alignment:Alignment.center,
                            child: Text(
                              'Transactions',
                              style: AppTextStyles.blackSizeBold16,
                            ),
                          ): Text(
                            driverState.selectedUser == GetIt.I<UserCubit>().user ?'Your transactions': "${driverState.selectedUser.firstName} transactions",
                            style: AppTextStyles.blackSizeBold16,
                          ),

                        ],
                      );
                    },
                  ),
                  kVerticalSpaceSmall,
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 1, color: AppColors.black)),
                    child: TabBar(
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black,
                      ),
                      labelColor: Colors.white,
                      labelStyle: AppTextStyles.whiteSize12,
                      unselectedLabelColor: Colors.black,
                      unselectedLabelStyle: AppTextStyles.blackSize12,
                      tabs: const [
                        Tab(
                          text: 'Recent',
                        ),
                        Tab(
                          text: 'Range',
                        ),
                      ],
                    ),
                  ),
                  kVerticalSpaceRegular,
                  Expanded(
                    child: Container(
                      child: TabBarView(
                        children: [
                          ListView(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            children: transactions.values.map((e) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat(
                                                "${DateFormat.ABBR_MONTH} ${DateFormat.YEAR}")
                                            .format(e.transactions.isEmpty
                                                ? DateTime.now()
                                                : e.transactions.first.timeAdded),
                                        style: AppTextStyles.blackSizeBold12,
                                      ),
                                      Text(
                                        "Income: N${e.amount.toMoney}",
                                        style: AppTextStyles.blackSize10,
                                      ),
                                      Text(
                                        "Trips: ${e.trips}",
                                        style: AppTextStyles.blackSize10,
                                      ),
                                      Text(
                                        "Expenses: ${e.expenses}",
                                        style: AppTextStyles.blackSize10,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                  ListView(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    children: e.transactions.map((e) {
                                      return TransactionCard(
                                        transaction: e,
                                        title: "Kemi",
                                        subtitle: "Mar 19 . 10:54 AM",
                                        trailing: "+20\$",
                                        subTrailing: "Trip",
                                        subTrailingStyle: AppTextStyles.blackSize12,
                                        titleStyle: AppTextStyles.blackSize14,
                                        subtitleStyle: AppTextStyles.blackSize12,
                                        trailingStyle: AppTextStyles.greenSize14,
                                      );
                                    }).toList(),
                                  ),
                                  kVerticalSpaceRegular
                                ],
                              );
                            }).toList(),
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "From",
                                          style: AppTextStyles.blackSize14,
                                        ),
                                        kVerticalSpaceSmall,
                                        GestureDetector(
                                          onTap: () => _pickDate(true),
                                          child: Container(
                                            width: 150.w,
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 16, 16, 16),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: AppColors.lightGray,
                                            ),
                                            child: Text(
                                              from == null
                                                  ? "Select Date..."
                                                  : DateFormat(
                                                          "${DateFormat.DAY}/${DateFormat.MONTH}/${DateFormat.YEAR} ")
                                                      .format(from!),
                                              style: AppTextStyles.blackSize14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "To",
                                          style: AppTextStyles.blackSize14,
                                        ),
                                        kVerticalSpaceSmall,
                                        SplashTap(
                                          onTap: () => _pickDate(false),
                                          child: Container(
                                            width: 150.w,
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 16, 16, 16),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: AppColors.lightGray,
                                            ),
                                            child: Text(
                                              to == null
                                                  ? "Select Date..."
                                                  : DateFormat(
                                                          "${DateFormat.DAY}/${DateFormat.MONTH}/${DateFormat.YEAR} ")
                                                      .format(to!),
                                              style: AppTextStyles.blackSize14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              SplashTap(
                                onTap: () {
                                  if (from != null && to != null) {
                                    Get.to(() => Range(
                                          userId: GetIt.I<UserCubit>().userId!,
                                          from: from!,
                                          to: to!,
                                        ));
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 16, 20, 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: AppColors.black,
                                  ),
                                  child: Text(
                                    "Show Transactions",
                                    style: AppTextStyles.whiteSize14,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void _pickDate(bool isFrom) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
            lastDate: DateTime.now().add(const Duration(days: 365 * 2)))
        .then((value) {
      if (value != null) {
        if (isFrom) {
          from = value;
        } else {
          to = value;
        }
        setState(() {});
      }
    });
  }
}
