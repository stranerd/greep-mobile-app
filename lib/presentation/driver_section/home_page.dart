import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as g;
import 'package:get/get.dart';
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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          body: BlocConsumer<UserTransactionsCubit, UserTransactionsState>(
              listener: (c, s) {
            if (s is UserTransactionsStateError ||
                s is UserTransactionsStateFetched) {
              setState(() {});
              _refreshController.refreshCompleted();
            }
          }, builder: (context, transState) {
            return BlocBuilder<TransactionSummaryCubit,
                TransactionSummaryState>(
              builder: (context, summaryState) {
                return BlocBuilder<DriversCubit, DriversState>(
                  builder: (context, driverState) {
                    return SafeArea(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: driverState is DriversStateDriver ? 215 :(driverState is DriversStateFetched &&
                                driverState.selectedUser == currentUser()) ? 270 : 190,
                            width: g.Get.width,
                            height: g.Get.height - (driverState is DriversStateDriver ? 250 :(driverState is DriversStateFetched &&
                                driverState.selectedUser == currentUser()) ? 300: 230),
                            child: SizedBox(
                              height: g.Get.height - (driverState is DriversStateDriver ? 250 :(driverState is DriversStateFetched &&
                                  driverState.selectedUser == currentUser()) ? 300: 230),
                              child: SmartRefresher(
                                controller: _refreshController,
                                onRefresh: _onRefresh,
                                child: ListView(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: kDefaultSpacing),
                                  physics: const BouncingScrollPhysics(),
                                  children: [
                                    kVerticalSpaceMedium,
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text("Today",
                                          style: kDefaultTextStyle.copyWith(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold
                                          )),
                                      trailing: SplashTap(
                                        onTap: () {
                                          g.Get.to(() => ViewAllRecords(),
                                              transition: g.Transition.fadeIn);
                                        },
                                        child: Text("view all",
                                            style: AppTextStyles.blackSize12),
                                      ),
                                    ),
                                    TransactionIntervalSummaryWidget(
                                        userId: userId,
                                        to: DateTime.now(),
                                        from: DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day)),
                                    kVerticalSpaceRegular,
                                    ListTile(
                                      contentPadding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      title: Text("Yesterday",
                                          style: kDefaultTextStyle.copyWith(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold
                                          )),
                                      trailing: SplashTap(
                                        onTap: () {
                                          g.Get.to(() => ViewAllRecords(),
                                              transition: g.Transition.fadeIn);
                                        },
                                        child: Text("view all",
                                            style: AppTextStyles.blackSize12),
                                      ),
                                    ),
                                    TransactionIntervalSummaryWidget(
                                        userId: userId,
                                        to: DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day),
                                        from: DateTime(
                                            DateTime.now()
                                                .subtract(
                                                    const Duration(days: 1))
                                                .year,
                                            DateTime.now()
                                                .subtract(
                                                    const Duration(days: 1))
                                                .month,
                                            DateTime.now()
                                                .subtract(
                                                    const Duration(days: 1))
                                                .day)),
                                    kVerticalSpaceRegular,
                                    ListTile(
                                      contentPadding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      title: Text("Customers",
                                          style: kDefaultTextStyle.copyWith(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold
                                          )),
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
                                              style:
                                                  AppTextStyles.blackSize12)),
                                    ),
                                    const CustomerTransactionListWidget(),
                                    kVerticalSpaceRegular,
                                    ListTile(
                                      contentPadding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      title: Text("Transaction history",
                                          style: kDefaultTextStyle.copyWith(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold
                                          )),
                                      trailing: SplashTap(
                                        onTap: () {
                                          g.Get.to(
                                              () => const TransactionView(),
                                              arguments: {"showAppBar": true},
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
                                      return ListView.separated(
                                        separatorBuilder: (_, __) => Row(
                                          children: [
                                            SizedBox(
                                              width: 70,
                                            ),
                                            Expanded(
                                              child: Container(
                                                width: Get.width * 0.7,
                                                height: 4,
                                                decoration: const BoxDecoration(
                                                    color: AppColors.lightGray),
                                              ),
                                            ),
                                          ],
                                        ),
                                        itemCount: transactions.length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (c, i) {
                                          return TransactionListCard(
                                            transaction: transactions[i],
                                            withLeading: true,
                                          );
                                        },
                                      );
                                    }),
                                    kVerticalSpaceLarge,
                                    kVerticalSpaceLarge,
                                    kVerticalSpaceSmall,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            width: g.Get.width,
                            child: Container(
                              width: g.Get.width,
                              height: driverState is DriversStateDriver ? 215 : ((driverState is DriversStateFetched &&
                                  driverState.selectedUser == currentUser()) ? 270: 180),
                              decoration: const BoxDecoration(
                                color: kWhiteColor,
                              ),
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        color: kBlackColor,
                                        height: driverState is DriversStateDriver ? 190 : ((driverState is DriversStateFetched &&
                                            driverState.selectedUser == currentUser()) ? 245: 180),
                                        width: Get.width,
                                        padding: const EdgeInsets.symmetric(horizontal: kDefaultSpacing,vertical: kDefaultSpacing * 0.5,),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            kVerticalSpaceSmall,
                                            const DriverSelectorRow(
                                              withWhiteText: true,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                kVerticalSpaceRegular,
                                                driverState
                                                        is DriversStateDriver
                                                    ? ListTile(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 0, 0, 0),
                                                        title: Text(
                                                          DateFormat(
                                                                  "${DateFormat.ABBR_WEEKDAY}, ${DateFormat.ABBR_MONTH} ${DateFormat.DAY}")
                                                              .format(DateTime
                                                                  .now()),
                                                          style: AppTextStyles
                                                              .whiteSize12,
                                                        ),
                                                        subtitle: Text(
                                                            "Hi ${userState is UserStateFetched ? userState.user.firstName : "!"}",
                                                            style:
                                                                kBoldWhiteTextStyle),
                                                        trailing: SplashTap(
                                                          onTap: () {
                                                            g.Get.to(
                                                                () =>
                                                                    const ProfileView(),
                                                                transition: g
                                                                    .Transition
                                                                    .fadeIn);
                                                          },
                                                          child: CircleAvatar(
                                                            backgroundImage:
                                                                CachedNetworkImageProvider(userState
                                                                        is UserStateFetched
                                                                    ? userState
                                                                        .user
                                                                        .photoUrl
                                                                    : ""),
                                                            child:
                                                                const Text(""),
                                                          ),
                                                        ),
                                                      )
                                                    : Text(
                                                        driverState
                                                                is DriversStateManager
                                                            ? driverState
                                                                        .selectedUser ==
                                                                    currentUser()
                                                                ? "Your activity"
                                                                : "${driverState.selectedUser.firstName} Activities"
                                                            : "",
                                                        style: kBoldTextStyle2
                                                            .copyWith(
                                                          color: kWhiteColor,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                kVerticalSpaceRegular,
                                                if (driverState
                                                        is DriversStateFetched &&
                                                    driverState.selectedUser ==
                                                        currentUser())
                                                  Text(
                                                        "Add a record",
                                                        style: kBoldWhiteTextStyle.copyWith(
                                                            fontSize:
                                                                13))
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      if ((driverState is DriversStateFetched &&
                                          driverState.selectedUser == currentUser()))Container(
                                        height: 25,
                                        decoration: const BoxDecoration(
                                            color: kWhiteColor),
                                      )
                                    ],
                                  ),
                                  if (driverState is DriversStateFetched &&
                                      driverState.selectedUser == currentUser())
                                    Positioned(
                                      width: g.Get.width,
                                      bottom: 0,
                                      child: Container(
                                        height: 50,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: kDefaultSpacing),
                                        decoration: const BoxDecoration(),
                                        child: LayoutBuilder(
                                            builder: (context, constraints) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SplashTap(
                                                onTap: () {
                                                  g.Get.to(
                                                      () => const RecordTrip(),
                                                      transition:
                                                          g.Transition.fadeIn);
                                                },
                                                child: AddRecord(
                                                  width: constraints.maxWidth *
                                                      0.48,
                                                  svg: SvgPicture.asset(
                                                      "assets/icons/local_taxi.svg",
                                                      width: 25,
                                                      height: 25,

                                                  ),
                                                  title: "Trip",
                                                ),
                                              ),
                                              SplashTap(
                                                onTap: () {
                                                  g.Get.to(
                                                      () =>
                                                          const RecordExpense(),
                                                      transition:
                                                          g.Transition.fadeIn);
                                                },
                                                child: AddRecord(
                                                  width: constraints.maxWidth *
                                                      0.48,
                                                  svg: Image.asset(
                                                      "assets/icons/expense.png",
                                                      width: 22,
                                                      height: 22),
                                                  title: "Expense",
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          }),
        );
      },
    );
  }

  void _onRefresh() {
    _userTransactionsCubit.fetchUserTransactions(fullRefresh: true);
  }
}
