import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as g;
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:greep/application/user/utils/get_current_user.dart';

import 'package:greep/application/transactions/response/transaction_summary.dart';
import 'package:greep/application/transactions/transaction_summary_cubit.dart';
import 'package:greep/application/transactions/user_transactions_cubit.dart';
import 'package:greep/application/driver/drivers_cubit.dart';
import 'package:greep/application/user/user_cubit.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/auth/AuthenticationClient.dart';
import 'package:greep/domain/transaction/transaction.dart';
import 'package:greep/presentation/driver_section/nav_pages/settings/account/view_profile.dart';
import 'package:greep/presentation/driver_section/transaction/view_transactions.dart';
import 'package:greep/presentation/driver_section/widgets/empty_result_widget.dart';
import 'package:greep/presentation/driver_section/widgets/transaction_interval_summary.dart';
import 'package:greep/presentation/widgets/code_verification_bottom_sheet.dart';
import 'package:greep/presentation/widgets/custom_appbar.dart';
import 'package:greep/presentation/widgets/customer_transaction_list.dart';
import 'package:greep/presentation/widgets/dot_circle.dart';
import 'package:greep/presentation/widgets/driver_selector_widget.dart';
import 'package:greep/presentation/widgets/email_verification_bottom_sheet.dart';
import 'package:greep/presentation/widgets/money_widget.dart';
import 'package:greep/presentation/widgets/progress_indicator_container.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/presentation/widgets/turkish_symbol.dart';
import 'package:greep/utils/constants/app_colors.dart';
import 'package:greep/utils/constants/app_styles.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'customer/customer_page.dart';
import 'records/record_expense.dart';
import 'records/record_trip.dart';
import 'records/view_records.dart';
import 'widgets/add_record_card.dart';
import 'widgets/transaction_list_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late RefreshController _refreshController;
  late UserTransactionsCubit _userTransactionsCubit;

  @override
  void initState() {
    _refreshController = RefreshController();
    _userTransactionsCubit = GetIt.I<UserTransactionsCubit>();
    //
    // GetIt.I<AuthenticationClient>().refreshToken().then((value) {
    //   debugPrint(value.toString());
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        var userId = currentUser().id;
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: const CustomAppbar(
            title: '',
          ),
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: SafeArea(
              child: BlocConsumer<UserTransactionsCubit, UserTransactionsState>(
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
                        return SmartRefresher(
                          controller: _refreshController,
                          onRefresh: _onRefresh,
                          child: ListView(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(kDefaultSpacing),
                            physics: const BouncingScrollPhysics(),
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextWidget(
                                        "Overview",
                                        weight: FontWeight.w600,
                                        fontSize: 16.sp,
                                      ),
                                      Row(
                                        children: [
                                          const TextWidget(
                                            "This Week",
                                          ),
                                          kHorizontalSpaceTiny,
                                          SvgPicture.asset(
                                            "assets/icons/filter.svg",
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  kVerticalSpaceRegular,
                                  ProgressIndicatorContainer(
                                    progress: 0.75,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const TextWidget(
                                          "Weekly target",
                                        ),
                                        Row(
                                          children: [
                                            const MoneyWidget(
                                              amount: 7500,
                                              weight: FontWeight.bold,
                                            ),
                                            kHorizontalSpaceTiny,
                                            const TextWidget(
                                              "/",
                                              weight: FontWeight.bold,
                                            ),
                                            kHorizontalSpaceTiny,
                                            const MoneyWidget(
                                              amount: 10000,
                                              weight: FontWeight.bold,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  kVerticalSpaceMedium,
                                  LayoutBuilder(builder: (context, cs) {
                                    return Row(
                                      children: [
                                        Container(
                                          width: cs.maxWidth * 0.5,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  DotCircle(color: AppColors.green),
                                                  kHorizontalSpaceSmall,
                                                  TextWidget("Target reached"),

                                                ],
                                              ),
                                              kVerticalSpaceRegular,
                                              Row(
                                                children: [
                                                  DotCircle(color: AppColors.coinGold),
                                                  kHorizontalSpaceSmall,
                                                  TextWidget("Above average"),

                                                ],
                                              ),
                                              kVerticalSpaceRegular,
                                              Row(
                                                children: [
                                                  DotCircle(color: AppColors.red),
                                                  kHorizontalSpaceSmall,
                                                  TextWidget("Poor performance"),

                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: cs.maxWidth * 0.5,
                                          alignment: Alignment.centerRight,
                                          child: Builder(builder: (context) {
                                            List<PieChartSectionData> sectionData = [
                                              PieChartSectionData(
                                                titleStyle: kWhiteTextStyle.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                value: 0.7,
                                                title: "income",
                                                showTitle: false,
                                                color: kGreenColor,

                                                radius:  50.r,
                                              ),
                                              PieChartSectionData(
                                                titleStyle: kWhiteTextStyle.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                value: 0.3,
                                                title: "expense",
                                                showTitle: false,
                                                color: AppColors.red,
                                                radius: 50.r,
                                              ),
                                            ];
                                            return SizedBox(
                                              width: 108.r,
                                              height: 108.r,
                                              child: PieChart(
                                                PieChartData(
                                                  pieTouchData: PieTouchData(touchCallback:
                                                      (FlTouchEvent event, pieTouchResponse) {
                                                  }),
                                                  startDegreeOffset: 90,
                                                  borderData: FlBorderData(
                                                      show: true,
                                                      border: const Border(
                                                        bottom: BorderSide(
                                                            color: kGreenColor, width: 5),
                                                      )),
                                                  sectionsSpace: 0,

                                                  centerSpaceRadius: double.infinity,
                                                  sections: sectionData,),
                                              ),
                                            );
                                          }),
                                        )
                                      ],
                                    );
                                  })
                                ],
                              ),
                              kVerticalSpaceMedium,
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: TextWidget("Today",
                                    style: kDefaultTextStyle.copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                trailing: SplashTap(
                                  onTap: () {
                                    g.Get.to(() => const ViewAllRecords(),
                                        transition: g.Transition.fadeIn);
                                  },
                                  child: TextWidget("view all",
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
                                title: TextWidget("Yesterday",
                                    style: kDefaultTextStyle.copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                trailing: SplashTap(
                                  onTap: () {
                                    g.Get.to(() => const ViewAllRecords(),
                                        transition: g.Transition.fadeIn);
                                  },
                                  child: TextWidget("view all",
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
                                title: TextWidget("Customers",
                                    style: kDefaultTextStyle.copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                trailing: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CustomerScreen(
                                                    withBackButton: true)),
                                      );
                                    },
                                    child: TextWidget("view all",
                                        style: AppTextStyles.blackSize12)),
                              ),
                              const CustomerTransactionListWidget(),
                              kVerticalSpaceRegular,
                              ListTile(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                title: TextWidget("Transaction history",
                                    style: kDefaultTextStyle.copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                trailing: SplashTap(
                                  onTap: () {
                                    g.Get.to(() => const TransactionsScreen(),
                                        arguments: {"showAppBar": true},
                                        transition: g.Transition.fadeIn);
                                  },
                                  child: TextWidget("view all",
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
                                        width: 70.w,
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: Get.width * 0.7,
                                          height: 4.h,
                                          decoration: const BoxDecoration(
                                              color: AppColors.lightGray),
                                        ),
                                      ),
                                    ],
                                  ),
                                  itemCount: transactions.length,
                                  physics: const NeverScrollableScrollPhysics(),
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
                              kVerticalSpaceLarge,
                              kVerticalSpaceSmall,
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ),
        );
      },
    );
  }

  void _onRefresh() {
    _userTransactionsCubit.fetchUserTransactions(fullRefresh: true);
  }
}
