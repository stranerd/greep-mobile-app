import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/customers/user_customers_cubit.dart';
import 'package:grip/application/driver/drivers_cubit.dart';
import 'package:grip/application/transactions/customer_statistics_cubit.dart';
import 'package:grip/application/transactions/user_transactions_cubit.dart';
import 'package:grip/application/user/utils/get_current_user.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/domain/transaction/transaction.dart';
import 'package:grip/presentation/driver_section/widgets/empty_result_widget.dart';
import 'package:grip/presentation/widgets/driver_selector_widget.dart';
import 'package:grip/presentation/widgets/text_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_styles.dart';
import '../widgets/customer_card_view.dart';

class CustomerView extends StatefulWidget {
  final bool withBackButton;
  const CustomerView({Key? key, this.withBackButton = false}) : super(key: key);

  @override
  State<CustomerView> createState() => _CustomerViewState();
}

class _CustomerViewState extends State<CustomerView> {
  late RefreshController refreshController;

  List<Transaction> transactions = [];

  List<String> debtTypes = ["none", "collect","not balanced","pay", "balance"];
  var selectedDebtType = "none";

  @override
  void initState() {
    refreshController = RefreshController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CustomerStatisticsCubit, CustomerStatisticsState>(
          listener: (context, state) {
            if (state is CustomerStatisticsStateDone) {
              setState(() {
                transactions = GetIt.I<CustomerStatisticsCubit>()
                    .getCustomerTransactions(type: selectedDebtType);
              });
            }
          },
        ),
        BlocListener<UserTransactionsCubit, UserTransactionsState>(
          listener: (context, state) {
            if (state is UserTransactionsStateFetched) {
              refreshController.refreshCompleted();
            }
          },
        ),
      ],
      child: BlocBuilder<UserCustomersCubit, UserCustomersState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: widget.withBackButton ? AppBar(
              automaticallyImplyLeading: true,
            ): null,
            body: SafeArea(
              child: Padding(
                padding:  EdgeInsets.all((kDefaultSpacing * 0.5).r),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const DriverSelectorRow(),
                      kVerticalSpaceSmall,
                      BlocBuilder<DriversCubit, DriversState>(
                        builder: (context, driverState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              driverState is! DriversStateManager
                                  ? Align(
                                      alignment: Alignment.center,
                                      child: TextWidget(
                                        'Customers',
                                        style: AppTextStyles.blackSizeBold16,
                                      ),
                                    )
                                  : TextWidget(
                                      driverState.selectedUser == currentUser()
                                          ? 'Your customers'
                                          : "${driverState.selectedUser.firstName} customers",
                                      style: AppTextStyles.blackSizeBold16,
                                    ),
                            ],
                          );
                        },
                      ),
                      kVerticalSpaceRegular,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 16.0.w,
                                height: 16.0.h,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.blue,
                                ),
                              ),
                               SizedBox(width: 8.0.w),
                              TextWidget("To collect",
                                  style: AppTextStyles.blackSize12),
                            ],
                          ),
                           SizedBox(width: 48.0.w),
                          Row(
                            children: [
                              Container(
                                width: 16.0.w,
                                height: 16.0.h,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.red,
                                ),
                              ),
                               SizedBox(width: 8.0.w),
                              TextWidget("To pay", style: AppTextStyles.blackSize12),
                            ],
                          ),
                           SizedBox(width: 48.0.w),
                          Row(
                            children: [
                              Container(
                                width: 16.0.w,
                                height: 16.0.h,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.black,
                                ),
                              ),
                               SizedBox(width: 8.0.w),
                              TextWidget("Balanced",
                                  style: AppTextStyles.blackSize12),
                            ],
                          ),
                        ],
                      ),
                      kVerticalSpaceSmall,
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultSpacing * 0.5),
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextWidget(
                              "Filter",
                              style: kDefaultTextStyle,
                            ),
                            kHorizontalSpaceTiny,
                             Icon(Icons.sort,size: 20.r,),
                          ],
                        ),
                      ),
                      kVerticalSpaceSmall,
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.all(kDefaultSpacing * 0.75),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: kLightGrayColor,
                          ),
                          borderRadius:
                              BorderRadius.circular(kDefaultSpacing * 0.5),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isDense: true,
                            isExpanded: true,
                            value: selectedDebtType,
                            items: debtTypes
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: TextWidget(
                                        e == "collect"
                                            ? "To Collect"
                                            : e == "pay"
                                                ? "To Pay"
                                                : e == "balance"
                                                    ? "Balanced" : e == "not balanced"? "Not Balanced"
                                                    : "None",
                                        style: kDefaultTextStyle.copyWith(
                                            fontSize: 14),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (String? value) {
                              selectedDebtType = value ?? selectedDebtType;
                                transactions =
                                    GetIt.I<CustomerStatisticsCubit>()
                                        .getCustomerTransactions(
                                            type: selectedDebtType);
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      kVerticalSpaceMedium,
                      Expanded(
                        child: SmartRefresher(
                          controller: refreshController,
                          onRefresh: () {
                            GetIt.I<UserTransactionsCubit>()
                                .fetchUserTransactions();
                          },
                          child: ListView(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            children: [
                              Builder(builder: (c) {
                                if (transactions.isEmpty) {
                                  return SizedBox(
                                    height: Get.height * 0.7,
                                    child: const EmptyResultWidget(
                                        text: "No customer transactions"),
                                  );
                                }

                                return ListView.separated(
                                    separatorBuilder: (c, i) =>
                                        kVerticalSpaceSmall,
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    itemCount: transactions.length,
                                    itemBuilder: (c, i) {
                                      return CustomerCardView(
                                        transaction: transactions[i],
                                      );
                                    });
                              }),
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
        },
      ),
    );
  }
}
