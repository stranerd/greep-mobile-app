import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:greep/application/customers/user_customers_cubit.dart';
import 'package:greep/application/driver/drivers_cubit.dart';
import 'package:greep/application/transactions/customer_statistics_cubit.dart';
import 'package:greep/application/transactions/user_transactions_cubit.dart';
import 'package:greep/application/user/utils/get_current_user.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/transaction/transaction.dart';
import 'package:greep/presentation/driver_section/widgets/empty_result_widget.dart';
import 'package:greep/presentation/widgets/driver_selector_widget.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_styles.dart';
import '../widgets/customer_card_view.dart';

class CustomerScreen extends StatefulWidget {
  final bool withBackButton;

  const CustomerScreen({Key? key, this.withBackButton = false})
      : super(key: key);

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  late RefreshController refreshController;

  List<Transaction> transactions = [];

  List<String> debtTypes = [
    "none",
    "collect",
    "not balanced",
    "pay",
    "balance"
  ];
  var selectedDebtType = "none";

  String search = "";

  List<Transaction> filteredTransactions = [];

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
                filteredTransactions = [...transactions];
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
            appBar: widget.withBackButton
                ? AppBar(
                    automaticallyImplyLeading: true,
                  )
                : null,
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark,

              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: (kDefaultSpacing * 0.5).r,horizontal: (kDefaultSpacing * 0.5).w),
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
                                TextWidget("To pay",
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
                                "filter",
                                fontSize: 15,
                                style: kDefaultTextStyle,
                              ),
                              kHorizontalSpaceTiny,
                              Icon(
                                Icons.sort,
                                size: 20.r,
                              ),
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
                                                      ? "Balanced"
                                                      : e == "not balanced"
                                                          ? "Not Balanced"
                                                          : "None",
                                          style: kDefaultTextStyle.copyWith(
                                              fontSize: 14.sp),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (String? value) {
                                selectedDebtType = value ?? selectedDebtType;
                                transactions = GetIt.I<CustomerStatisticsCubit>()
                                    .getCustomerTransactions(
                                        type: selectedDebtType);
                                filteredTransactions = [...transactions];
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        kVerticalSpaceRegular,
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: kDefaultSpacing),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade200),
                              borderRadius:
                                  BorderRadius.circular(kDefaultSpacing * 0.5)),
                          height: 60.h,
                          child: Row(
                            children: [
                              Icon(
                                Icons.search_outlined,
                                size: 20.r,
                                color: Colors.grey.shade600,
                              ),
                              kHorizontalSpaceSmall,
                              Expanded(
                                child: TextField(
                                  onChanged: (s) {
                                    if (s.isNotEmpty) {
                                      filteredTransactions =
                                          transactions.where((element) {
                                        var customerName = element.data.customerName
                                            ?.trim()
                                            .toLowerCase();
                                        return customerName
                                                ?.contains(s.trim().toLowerCase()) ??
                                            false;
                                      }).toList();
                                    } else {
                                      filteredTransactions = [...transactions];
                                    }
                                    setState(() {});
                                  },
                                  style: kDefaultTextStyle.copyWith(fontSize: 15.sp),
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                        left: kDefaultSpacing * 0.5,
                                        top: kDefaultSpacing * 0.5,
                                        bottom: kDefaultSpacing * 0.5,
                                      ),

                                      hintText: "Search customer",
                                      border: InputBorder.none),
                                ),
                              ),
                            ],
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
                                      itemCount: filteredTransactions.length,
                                      itemBuilder: (c, i) {
                                        return CustomerCardView(
                                          transaction: filteredTransactions[i],
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
            ),
          );
        },
      ),
    );
  }
}
