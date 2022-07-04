import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/transactions/customer_statistics_cubit.dart';
import 'package:grip/application/transactions/user_transactions_cubit.dart';
import 'package:grip/application/driver/drivers_cubit.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/application/user/utils/get_current_user.dart';

import 'package:grip/domain/transaction/transaction.dart';
import 'package:grip/presentation/driver_section/widgets/empty_result_widget.dart';
import 'package:grip/presentation/widgets/driver_selector_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_styles.dart';
import '../widgets/customer_card_view.dart';
import 'customer_details.dart';

class CustomerView extends StatefulWidget {
  const CustomerView({Key? key}) : super(key: key);

  @override
  State<CustomerView> createState() => _CustomerViewState();
}

class _CustomerViewState extends State<CustomerView> {
  late RefreshController refreshController;


  List<Transaction> transactions = [];

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
              print("Setting summary state");
              setState(() {
                transactions =
                    GetIt.I<CustomerStatisticsCubit>()
                        .getCustomerTransactions();
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
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   toolbarHeight: 30,
        //   backgroundColor: Colors.white,
        //   title: Text(
        //     'Greep',
        //     style: AppTextStyles.blackSizeBold16,
        //   ),
        //   centerTitle: true,
        //   elevation: 0.0,
        // ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(kDefaultSpacing * 0.5),
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
                          driverState is! DriversStateManager ? Align(
                            alignment:Alignment.center,
                            child: Text(
                              'Customers',
                              style: AppTextStyles.blackSizeBold16,
                            ),
                          ): Text(
                      driverState.selectedUser == currentUser() ?'Your customers': "${driverState.selectedUser.firstName} customers",
                      style: AppTextStyles.blackSizeBold16,
                      ),

                        ],
                      );
                    },
                  ),
                  kVerticalSpaceRegular,
                  Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 16.0,
                            height: 16.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.blue,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text("To collect", style: AppTextStyles.blackSize12),
                        ],
                      ),
                      const SizedBox(width: 48.0),
                      Row(
                        children: [
                          Container(
                            width: 16.0,
                            height: 16.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.red,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text("To pay", style: AppTextStyles.blackSize12),
                        ],
                      ),
                      const SizedBox(width: 48.0),
                      Row(
                        children: [
                          Container(
                            width: 16.0,
                            height: 16.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text("Balanced", style: AppTextStyles.blackSize12),
                        ],
                      ),
                    ],
                  ),
                  kVerticalSpaceMedium,
                  Expanded(
                    child: SmartRefresher(
                      controller: refreshController,
                      onRefresh: () {
                        GetIt.I<UserTransactionsCubit>().fetchUserTransactions();
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
                                separatorBuilder: (c, i) => kVerticalSpaceSmall,
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
      ),
    );
  }
}
