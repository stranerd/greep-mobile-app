import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as g;
import 'package:get_it/get_it.dart';
import 'package:grip/application/user/utils/get_current_user.dart';

import 'package:grip/application/transactions/response/transaction_summary.dart';
import 'package:grip/application/transactions/transaction_summary_cubit.dart';
import 'package:grip/application/transactions/user_transactions_cubit.dart';
import 'package:grip/application/driver/drivers_cubit.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/domain/transaction/transaction.dart';
import 'package:grip/presentation/driver_section/nav_pages/settings/account/view_profile.dart';
import 'package:grip/presentation/driver_section/transaction/view_transactions.dart';
import 'package:grip/presentation/driver_section/widgets/empty_result_widget.dart';
import 'package:grip/presentation/driver_section/widgets/transaction_interval_summary.dart';
import 'package:grip/presentation/widgets/customer_transaction_list.dart';
import 'package:grip/presentation/widgets/driver_selector_widget.dart';
import 'package:grip/presentation/widgets/splash_tap.dart';
import 'package:grip/utils/constants/app_colors.dart';
import 'package:grip/utils/constants/app_styles.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'customer/customer_page.dart';
import 'records/record_expense.dart';
import 'records/record_trip.dart';
import 'records/view_records.dart';
import 'widgets/add_record_card.dart';
import 'widgets/transaction_list_card.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({Key? key}) : super(key: key);

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  late RefreshController _refreshController;
  late UserTransactionsCubit _userTransactionsCubit;

  @override
  void initState() {
    _refreshController = RefreshController();
    _userTransactionsCubit = GetIt.I<UserTransactionsCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        var userId = currentUser().id;

        return Scaffold(
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
            body: BlocConsumer<UserTransactionsCubit, UserTransactionsState>(
              listener: (c, s) {
                if (s is UserTransactionsStateError ||
                    s is UserTransactionsStateFetched) {
                  setState(() {});
                  _refreshController.refreshCompleted();
                }
              },
              builder: (context, transState) {
                return BlocBuilder<TransactionSummaryCubit,
                    TransactionSummaryState>(
                  builder: (context, summaryState) {
                    return SafeArea(
                      child: SmartRefresher(
                        controller: _refreshController,
                        onRefresh: onRefresh,
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Container(
                              clipBehavior: Clip.none,
                              padding: EdgeInsets.all(kDefaultSpacing * 0.5),
                              decoration: BoxDecoration(
                                color: kBlackColor,

                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  kVerticalSpaceSmall,
                                  const DriverSelectorRow(),
                                  BlocBuilder<DriversCubit, DriversState>(
                                    builder: (context, driverState) {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          kVerticalSpaceSmall,
                                          driverState is DriversStateDriver ? ListTile(
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            title: Text(
                                              DateFormat(
                                                      "${DateFormat.ABBR_WEEKDAY}, ${DateFormat.ABBR_MONTH} ${DateFormat.DAY}")
                                                  .format(DateTime.now()),
                                              style: AppTextStyles.whiteSize12,
                                            ),
                                            subtitle: Text(
                                                "Hi ${userState is UserStateFetched ? userState.user.firstName : "!"}",
                                                style: kBoldWhiteTextStyle),
                                            trailing: SplashTap(
                                              onTap: (){
                                                g.Get.to(() => const ProfileView(),transition: g.Transition.fadeIn);},
                                              child: CircleAvatar(
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                        userState is UserStateFetched
                                                            ? userState.user.photoUrl
                                                            : ""),
                                                child: const Text(""),
                                              ),
                                            ),
                                          ): Text(driverState is DriversStateManager ? driverState.selectedUser ==  currentUser() ?"Your activity" : "${driverState.selectedUser.firstName} Activities":"", style: kBoldWhiteTextStyle),

                                          if (driverState is DriversStateFetched && driverState.selectedUser == currentUser())LayoutBuilder(
                                              builder: (context, constraints) {
                                            return Container(
                                              width: g.Get.width,
                                              clipBehavior: Clip.none,
                                              height: 80,
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      kVerticalSpaceRegular,
                                                      Text("Add a record",
                                                          style: kBoldWhiteTextStyle.copyWith(
                                                              fontSize: 14)),
                                                      kVerticalSpaceSmall,
                                                    ],
                                                  ),
                                                  Positioned(
                                                    width: g.Get.width - (kDefaultSpacing),
                                                    bottom: -35,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        SplashTap(
                                                          onTap: () {
                                                            g.Get.to(() => const RecordTrip(),transition: g.Transition.fadeIn);
                                                          },
                                                          child: AddRecord(
                                                            width:
                                                            constraints.maxWidth * 0.47,
                                                            svg: SvgPicture.asset("assets/icons/local_taxi.svg", width: 30, height: 30),
                                                            title: "Trip",

                                                          ),
                                                        ),
                                                        SplashTap(
                                                          onTap: () {
                                                            g.Get.to(
                                                                    () => const RecordExpense(),
                                                                transition: g.Transition.fadeIn);
                                                          },
                                                          child: AddRecord(
                                                            width: constraints.maxWidth * 0.47,
                                                            svg: SvgPicture.asset("assets/icons/expense.svg", width: 25, height: 25),

                                                            title: "Expense",
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            );
                                          }),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            ListView(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultSpacing),
                              physics: const BouncingScrollPhysics(),
                              children: [
                                kVerticalSpaceLarge,
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text("Today",
                                      style: AppTextStyles.blackSizeBold12),
                                  trailing: SplashTap(
                                    onTap: () {
                                      g.Get.to(() => ViewAllRecords(), transition: g.Transition.fadeIn);
                                    },
                                    child: Text("view all",
                                        style: AppTextStyles.blackSize12),
                                  ),
                                ),
                                TransactionIntervalSummaryWidget(
                                    userId: userId,
                                    to: DateTime.now(),
                                    from: DateTime(DateTime.now().year,
                                        DateTime.now().month, DateTime.now().day)),
                                kVerticalSpaceRegular,
                                ListTile(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  title: Text("Yesterday",
                                      style: AppTextStyles.blackSizeBold12),
                                  trailing: SplashTap(
                                    onTap: () {
                                      g.Get.to(() => ViewAllRecords(),transition: g.Transition.fadeIn);
                                    },
                                    child: Text("view all",
                                        style: AppTextStyles.blackSize12),
                                  ),
                                ),
                                TransactionIntervalSummaryWidget(
                                    userId: userId,
                                    to: DateTime(DateTime.now().year,
                                        DateTime.now().month, DateTime.now().day),
                                    from: DateTime(
                                        DateTime.now()
                                            .subtract(const Duration(days: 1))
                                            .year,
                                        DateTime.now()
                                            .subtract(const Duration(days: 1))
                                            .month,
                                        DateTime.now()
                                            .subtract(const Duration(days: 1))
                                            .day)),
                                kVerticalSpaceRegular,
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
                                const CustomerTransactionListWidget(
                                ),
                                kVerticalSpaceRegular,
                                ListTile(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  title: Text("Transaction history",
                                      style: AppTextStyles.blackSizeBold12),
                                  trailing: SplashTap(
                                    onTap: () {
                                      g.Get.to(() => TransactionView(),arguments: {"showAppBar": true},
                                          transition: g.Transition.fadeIn);
                                    },
                                    child: Text("view all",
                                        style: AppTextStyles.blackSize12),
                                  ),
                                ),
                                Builder(builder: (context) {
                                  List<Transaction> transactions =
                                      GetIt.I<UserTransactionsCubit>()
                                          .getLastUserTransactions();
                                  if (transactions.isEmpty) {
                                    return const EmptyResultWidget(
                                        text: "No recent transactions");
                                  }
                                  return ListView.builder(
                                    itemCount: transactions.length,
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (c, i) {
                                      return TransactionListCard(
                                        title: "Kemi",
                                        subtitle: "Mar 19 . 10:54 AM",
                                        trailing: "+20\$",
                                        transaction: transactions[i],
                                        titleStyle: AppTextStyles.blackSize14,
                                        subtitleStyle: AppTextStyles.blackSize12,
                                        trailingStyle: AppTextStyles.greenSize14,
                                      );
                                    },
                                  );
                                }),
                                kVerticalSpaceLarge,
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ));
      },
    );
  }

  void onRefresh() {
    _userTransactionsCubit.fetchUserTransactions(fullRefresh: true);
  }
}
