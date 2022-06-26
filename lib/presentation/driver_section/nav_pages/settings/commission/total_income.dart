import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/transactions/response/commission_summary.dart';
import 'package:grip/application/transactions/response/customer_summary.dart';
import 'package:grip/application/transactions/transaction_summary_cubit.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/commons/Utils/utils.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/presentation/driver_section/widgets/commission_summary_item.dart';
import 'package:intl/intl.dart';

import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/constants/app_styles.dart';
import 'package:grip/application/user/utils/get_current_user.dart';

class TotalIncome extends StatelessWidget {
  const TotalIncome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios, size: 16)),
          title: Text(
            "Total Income",
            style: AppTextStyles.blackSizeBold14,
          ),
          centerTitle: false,
          elevation: 0.0,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Container(
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
                      height: 40,

                      text: 'Daily',
                    ),
                    Tab(
                      height: 40,
                      text: 'Monthly',
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
                    child: TabBarView(
                      children: [
                        ListView(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          children: [
                            Builder(builder: (context) {
                              Map<DateTime, CommissionSummary> commissions =
                                  GetIt.I<TransactionSummaryCubit>()
                                      .getManagerTotalDailyCommissions();
                              return ListView.separated(
                                separatorBuilder: (_,__) => kVerticalSpaceRegular,
                                  itemCount: commissions.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (c, i) {
                                    CommissionSummary summary = commissions[commissions.keys.toList()[i]]!;
                                    return CommissionSummaryItem(commissionSummary: summary);
                                  });
                            }),
                          ],
                        ),
                    ListView(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      children: [
                        Builder(builder: (context) {
                          Map<DateTime, CommissionSummary> commissions =
                          GetIt.I<TransactionSummaryCubit>()
                              .getManagerTotalMonthlyCommissions();
                          return ListView.separated(
                              separatorBuilder: (_,__) => kVerticalSpaceRegular,
                              itemCount: commissions.length,
                              shrinkWrap: true,
                              itemBuilder: (c, i) {
                                CommissionSummary summary = commissions[commissions.keys.toList()[i]]!;
                         return CommissionSummaryItem(commissionSummary: summary,isMonthly:true);
                        });})
                      ],
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
    );
  }
}
