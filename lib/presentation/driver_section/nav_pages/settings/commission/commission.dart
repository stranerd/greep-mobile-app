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

class CommissionHome extends StatelessWidget {
  const CommissionHome({Key? key}) : super(key: key);

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
            "Commission",
            style: AppTextStyles.blackSizeBold14,
          ),
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
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
              BlocBuilder<UserCubit, UserState>(
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Commission percentage",
                                style: AppTextStyles.blackSizeBold12),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color.fromRGBO(221, 226, 224, 1),
                                  width: 1.0,
                                ),
                              ),
                              child: Text(
                                  "${(currentUser().commission! * 100).toInt()}%",
                                  style: AppTextStyles.blackSize16),
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            Builder(builder: (context) {
                              Map<DateTime, CommissionSummary> commissions =
                                  GetIt.I<TransactionSummaryCubit>()
                                      .getManagedDailyCommissions();
                              return ListView.separated(
                                separatorBuilder: (_,__) => kVerticalSpaceSmall,
                                  itemCount: commissions.length,
                                  shrinkWrap: true,
                                  itemBuilder: (c, i) {
                                    CommissionSummary summary = commissions[commissions.keys.toList()[i]]!;
                                    return CommissionSummaryItem(commissionSummary: summary);
                                  });
                            }),
                          ],
                        ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Builder(builder: (context) {
                          Map<DateTime, CommissionSummary> commissions =
                          GetIt.I<TransactionSummaryCubit>()
                              .getManagedMonthlyCommissions();
                          return ListView.separated(
                              separatorBuilder: (_,__) => kVerticalSpaceSmall,
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
            ],
          ),
        ),
      ),
    );
  }
}
