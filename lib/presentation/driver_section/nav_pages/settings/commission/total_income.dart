import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:greep/application/driver/drivers_cubit.dart';
import 'package:greep/application/driver/manager_drivers_cubit.dart';
import 'package:greep/application/transactions/response/commission_summary.dart';
import 'package:greep/application/transactions/response/customer_summary.dart';
import 'package:greep/application/transactions/transaction_summary_cubit.dart';
import 'package:greep/application/user/user_cubit.dart';
import 'package:greep/application/user/user_util.dart';
import 'package:greep/commons/Utils/utils.dart';
import 'package:greep/commons/money.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/user/model/driver_commission.dart';
import 'package:greep/presentation/driver_section/widgets/commission_summary_item.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/driver_selector_widget.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/presentation/widgets/turkish_symbol.dart';
import 'package:intl/intl.dart';

import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_styles.dart';
import 'package:greep/application/user/utils/get_current_user.dart';

class TotalIncome extends StatefulWidget {
  const TotalIncome({Key? key}) : super(key: key);

  @override
  State<TotalIncome> createState() => _TotalIncomeState();
}

class _TotalIncomeState extends State<TotalIncome> {

  String userId = currentUser().id;
  num commission = 100;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
  listeners: [
    BlocListener<DriversCubit, DriversState>(
      listener: (context, state) {
        if (state is DriversStateFetched) {
          
          setState(() {
            userId = state.selectedUser.id;
          });
        }
      },
),
    BlocListener<ManagerDriversCubit, ManagerDriversState>(
      listener: (context, state) {
        if (state is ManagerDriversStateFetched){
        setState(() {

          commission = state.drivers.isEmpty ? 100 : state.drivers.firstWhere((element) => element.driverId == userId, orElse: () =>DriverCommission(driverId: currentUser().id, commission: 1)).commission * 100;

        });
        }
      },
    ),
  ],
  child: DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: kDefaultSpacing * 0.5, vertical: kDefaultSpacing),
            child: Text(
              "Total income = Your income + Your drivers income",
              style: kDefaultTextStyle.copyWith(fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: BackIcon(isArrow: true,),
            title: Text(
              "Total Income",
              style: AppTextStyles.blackSizeBold14,
            ),
            centerTitle: false,
            elevation: 0.5,
          ),
          body: Column(
            children: [
              kVerticalSpaceRegular,
              const Align(
                alignment: Alignment.centerLeft,
                child: DriverSelectorRow(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kDefaultSpacing),
                    color: const Color(0xffE8EFFD),
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(kDefaultSpacing),
                      color: Colors.black,
                    ),
                    labelColor: Colors.white,
                    labelStyle: AppTextStyles.whiteSize12,
                    unselectedLabelColor: Colors.black,
                    unselectedLabelStyle: AppTextStyles.blackSize12,
                    tabs: const [
                      Tab(
                        height: 35,
                        text: 'Daily',
                      ),
                      Tab(
                        height: 35,
                        text: 'Weekly',
                      ),
                      Tab(
                        height: 35,
                        text: 'Monthly',
                      ),
                      Tab(
                        height: 35,
                        text: 'All',
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<UserCubit, UserState>(
                  builder: (context, state) {
                    return Container(
                      padding: const EdgeInsets.fromLTRB(16, 32, 16, 20),
                      height: MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom -
                          AppBar().preferredSize.height -
                          MediaQuery.of(context).padding.top,
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget("Commission (%)", style: AppTextStyles.blackSizeBold16),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color(0xffF3F6F8),
                                  border: Border.all(
                                    color: const Color.fromRGBO(221, 226, 224, 1),
                                    width: 1.0,
                                  ),
                                ),
                                child: TextWidget("${commission}%",
                                    style: AppTextStyles.blackSizeBold16),
                              ),
                            ],
                          ),
                          kVerticalSpaceRegular,
                          Expanded(
                            child: TabBarView(
                              children: [
                                Builder(builder: (context) {
                                  Map<DateTime, CommissionSummary> commissions =
                                      GetIt.I<TransactionSummaryCubit>()
                                          .getManagerTotalDailyCommissions();
                                  return ListView.separated(
                                      separatorBuilder: (_, __) =>
                                          kVerticalSpaceRegular,
                                      itemCount: commissions.length,
                                      physics: const ScrollPhysics(),
                                      itemBuilder: (c, i) {
                                        CommissionSummary summary = commissions[
                                            commissions.keys.toList()[i]]!;
                                        return CommissionSummaryItem(
                                            alignment: Alignment.center,
                                            backgroundColor: const Color(0xffF3F6F8),
                                            commissionSummary: summary);
                                      });
                                }),
                                Builder(builder: (context) {
                                  Map<DateTime, CommissionSummary> commissions =
                                      GetIt.I<TransactionSummaryCubit>()
                                          .getManagerTotalWeeklyCommissions();
                                  return ListView.separated(
                                      separatorBuilder: (_, __) =>
                                          kVerticalSpaceRegular,
                                      itemCount: commissions.length,
                                      physics: const ScrollPhysics(),
                                      itemBuilder: (c, i) {
                                        CommissionSummary summary = commissions[
                                            commissions.keys.toList()[i]]!;
                                        return CommissionSummaryItem(
                                          alignment: Alignment.center,
                                          isWeekly: true,
                                          backgroundColor: const Color(0xffF3F6F8),
                                          commissionSummary: summary,
                                        );
                                      });
                                }),
                                Builder(builder: (context) {
                                  Map<DateTime, CommissionSummary> commissions =
                                      GetIt.I<TransactionSummaryCubit>()
                                          .getManagerTotalMonthlyCommissions();
                                  return ListView.separated(
                                      separatorBuilder: (_, __) =>
                                          kVerticalSpaceRegular,
                                      itemCount: commissions.length,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (c, i) {
                                        CommissionSummary summary = commissions[
                                            commissions.keys.toList()[i]]!;
                                        return CommissionSummaryItem(
                                            commissionSummary: summary,
                                            alignment: Alignment.center,
                                            backgroundColor: const Color(0xffF3F6F8),
                                            isMonthly: true);
                                      });
                                }),
                                Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      const Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextWidget(
                                          "All-Time Income",
                                          weight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      kVerticalSpaceLarge,
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 300.w,
                                          height: 300.w,
                                          decoration: BoxDecoration(
                                              color: const Color(0xffDBE5EE),
                                              border: Border.all(
                                                  width: 5,
                                                  color: const Color(0xff04D28C)),
                                              shape: BoxShape.circle),
                                          child: Builder(builder: (context) {
                                            var totalIncome =
                                                GetIt.I<TransactionSummaryCubit>()
                                                    .getManagerDriverTotalIncome();

                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TurkishSymbol(
                                                  width: 45.sp,
                                                  height: 45.sp,
                                                  color: const Color(0xff04D28C),
                                                ),
                                                TextWidget(
                                                  totalIncome.commission.toMoney,
                                                  fontSize: 50.sp,
                                                  color: const Color(0xff04D28C),
                                                  weight: FontWeight.bold,
                                                ),
                                              ],
                                            );
                                          }),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
);
  }
}
