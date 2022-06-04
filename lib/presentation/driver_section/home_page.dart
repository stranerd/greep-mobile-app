import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/transactions/transaction_summary.dart';
import 'package:grip/application/transactions/transaction_summary_cubit.dart';
import 'package:grip/application/transactions/user_transactions_cubit.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/application/user/user_state.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:intl/intl.dart';

import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_styles.dart';
import 'customer/customer_page.dart';
import 'records/record_expense.dart';
import 'records/record_trip.dart';
import 'records/view_records.dart';
import 'widgets/add_record_card.dart';
import 'widgets/customer_record_card.dart';
import 'widgets/record_card.dart';
import 'widgets/transaction_list_card.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({Key? key}) : super(key: key);

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                'Greep',
                style: AppTextStyles.blackSizeBold16,
              ),
              centerTitle: true,
              elevation: 0.0,
            ),
            body: BlocBuilder<TransactionSummaryCubit, TransactionSummaryState>(
              builder: (context, summaryState) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(kDefaultSpacing * 0.5, 0.0, kDefaultSpacing * 0.5, 0.0),
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            title: Text(
                              DateFormat(
                                      "${DateFormat.ABBR_WEEKDAY}, ${DateFormat.ABBR_MONTH} ${DateFormat.DAY}")
                                  .format(DateTime.now()),
                              style: AppTextStyles.blackSize12,
                            ),
                            subtitle: Text(
                                "Hi ${userState is UserStateFetched ? userState.user.firstName : "!"}",
                                style: AppTextStyles.blackSizeBold16),
                            trailing: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                  userState is UserStateFetched
                                      ? userState.user.photoUrl
                                      : ""),
                              child: Text(""),
                            ),
                          ),
                          const SizedBox(height: 17.0),
                          Text("Add a record",
                              style: AppTextStyles.blackSizeBold12),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.to(() => const RecordTrip());
                                },
                                child: AddRecord(
                                  color: AppColors.black,
                                  icon: "assets/icons/local_taxi.svg",
                                  title: "Trip",
                                  textStyle: AppTextStyles.blackSize14,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() => const RecordExpense());
                                },
                                child: AddRecord(
                                  color: AppColors.red,
                                  icon: "assets/icons/handyman.svg",
                                  title: "Expenses",
                                  textStyle: AppTextStyles.redSize14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),

                          ListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            title: Text("Today",
                                style: AppTextStyles.blackSizeBold12),
                            trailing: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ViewAllRecords()),
                                );
                              },
                              child: Text("view all",
                                  style: AppTextStyles.blackSize12),
                            ),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Builder(
                            builder: (context) {
                              TransactionSummary transactionSummary = GetIt.I<TransactionSummaryCubit>().todaySummary(GetIt.I<UserCubit>().userId!);
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  RecordCard(
                                    title: "N${transactionSummary.amount}",
                                    subtitle: "Income",
                                    subtitleStyle: AppTextStyles.blackSize12,
                                    titleStyle: AppTextStyles.greenSize16,
                                  ),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  RecordCard(
                                    title: "${transactionSummary.trips}",
                                    subtitle: "Trips",
                                    subtitleStyle: AppTextStyles.blackSize12,
                                    titleStyle: AppTextStyles.blackSize16,
                                  ),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  RecordCard(
                                    title: "${transactionSummary.expenses}",
                                    subtitle: "Expenses",
                                    subtitleStyle: AppTextStyles.blackSize12,
                                    titleStyle: AppTextStyles.blackSize16,
                                  ),
                                ],
                              );
                            }
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          ListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            title: Text("Yesterday",
                                style: AppTextStyles.blackSizeBold12),
                            trailing: Text("view all",
                                style: AppTextStyles.blackSize12),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Builder(
                            builder: (context) {
                              TransactionSummary transactionSummary = GetIt.I<TransactionSummaryCubit>().yesterdaySummary(GetIt.I<UserCubit>().userId!);

                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  RecordCard(
                                    title: "N${transactionSummary.amount}",
                                    subtitle: "Income",
                                    subtitleStyle: AppTextStyles.blackSize12,
                                    titleStyle: AppTextStyles.greenSize16,
                                  ),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  RecordCard(
                                    title: "${transactionSummary.trips}",
                                    subtitle: "Trips",
                                    subtitleStyle: AppTextStyles.blackSize12,
                                    titleStyle: AppTextStyles.blackSize16,
                                  ),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  RecordCard(
                                    title: "${transactionSummary.expenses}",
                                    subtitle: "Expenses",
                                    subtitleStyle: AppTextStyles.blackSize12,
                                    titleStyle: AppTextStyles.blackSize16,
                                  ),
                                ],
                              );
                            }
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          ListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            title: Text("Customers",
                                style: AppTextStyles.blackSizeBold12),
                            trailing: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CustomerView()),
                                  );
                                },
                                child: Text("view all",
                                    style: AppTextStyles.blackSize12)),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomerRecordCard(
                                title: "\$8",
                                subtitle: "To pay",
                                subtextTitle: "Kemi",
                                subtextTitleStyle: AppTextStyles.blackSize12,
                                subtitleStyle: AppTextStyles.blackSize12,
                                titleStyle: AppTextStyles.greenSize16,
                              ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              CustomerRecordCard(
                                title: "\$0",
                                subtitle: "Balanced",
                                subtextTitle: "Dammy",
                                subtextTitleStyle: AppTextStyles.blackSize12,
                                subtitleStyle: AppTextStyles.blackSize12,
                                titleStyle: AppTextStyles.blackSize16,
                              ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              CustomerRecordCard(
                                title: "\$6",
                                subtitle: "To collect",
                                subtextTitle: "Klintin",
                                subtextTitleStyle: AppTextStyles.blackSize12,
                                subtitleStyle: AppTextStyles.blackSize12,
                                titleStyle: AppTextStyles.blueSize16,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          ListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            title: Text("Transaction history",
                                style: AppTextStyles.blackSizeBold12),
                            trailing: Text("view all",
                                style: AppTextStyles.blackSize12),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Column(
                            children: [
                              TransactionListCard(
                                title: "Kemi",
                                subtitle: "Mar 19 . 10:54 AM",
                                trailing: "+20\$",
                                titleStyle: AppTextStyles.blackSize14,
                                subtitleStyle: AppTextStyles.blackSize12,
                                trailingStyle: AppTextStyles.greenSize14,
                              ),
                              const SizedBox(height: 16.0),
                              TransactionListCard(
                                title: "Fuel",
                                subtitle: "Mar 18 . 6:24 PM",
                                trailing: "-17\$",
                                titleStyle: AppTextStyles.blackSize14,
                                subtitleStyle: AppTextStyles.blackSize12,
                                trailingStyle: AppTextStyles.redSize14,
                              ),
                              const SizedBox(height: 16.0),
                              TransactionListCard(
                                title: "Kemi",
                                subtitle: "Mar 19 . 10:54 AM",
                                trailing: "+20\$",
                                titleStyle: AppTextStyles.blackSize14,
                                subtitleStyle: AppTextStyles.blackSize12,
                                trailingStyle: AppTextStyles.greenSize14,
                              ),
                              const SizedBox(height: 16.0),
                              TransactionListCard(
                                title: "Fuel",
                                subtitle: "Mar 18 . 6:24 PM",
                                trailing: "-17\$",
                                titleStyle: AppTextStyles.blackSize14,
                                subtitleStyle: AppTextStyles.blackSize12,
                                trailingStyle: AppTextStyles.redSize14,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ));
      },
    );
  }
}
