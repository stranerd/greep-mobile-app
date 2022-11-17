import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:greep/application/driver/drivers_cubit.dart';
import 'package:greep/application/driver/new_manager_accepts_cubit.dart';
import 'package:greep/application/driver/new_manager_requests_cubit.dart';
import 'package:greep/application/transactions/customer_statistics_cubit.dart';
import 'package:greep/application/transactions/transaction_summary_cubit.dart';
import 'package:greep/application/driver/manager_requests_cubit.dart';
import 'package:greep/application/user/user_crud_cubit.dart';
import 'package:greep/application/user/user_cubit.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/scaffold_messenger_service.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/firebase/Firebase_service.dart';
import 'package:greep/domain/user/model/manager_request.dart';
import 'package:stacked/stacked.dart';
import 'package:upgrader/upgrader.dart';

import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_styles.dart';
import '../../../../utils/constants/svg_icon.dart';
import '../../customer/customer_page.dart';
import '../../home_page.dart';
import '../../transaction/view_transactions.dart';
import '../settings/home_page.dart';
import 'nav_bar_viewmodel.dart';
import 'package:greep/application/user/utils/get_current_user.dart';

class NavBarView extends StatefulWidget {
  const NavBarView({Key? key}) : super(key: key);

  @override
  State<NavBarView> createState() => _NavBarViewState();
}

class _NavBarViewState extends State<NavBarView> with ScaffoldMessengerService {
  int _currNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TransactionSummaryCubit, TransactionSummaryState>(
          listener: (context, state) {
            if (state is TransactionSummaryStateDone) {
              setState(() {});
            }
          },
        ),
        BlocListener<NewManagerRequestsCubit, NewManagerRequestsState>(
          listener: (context, state) {
            if (state is NewManagerRequestsStateAvailable) {
              showManagerRequest(state.request);
            }
          },
        ),
        BlocListener<NewManagerAcceptsCubit, NewManagerAcceptsState>(
          listener: (context, state) async {
            if (state is NewManagerAcceptsStateAccepted) {
              FirebaseApi.clearManagerAccepts(currentUser().id);
              Future.delayed(const Duration(seconds: 2), () {
                success = "Driver accepted request";
                GetIt.I<UserCubit>().fetchUser();
              });
              print("manager accepted");
            }
          },
        ),
        BlocListener<CustomerStatisticsCubit, CustomerStatisticsState>(
          listener: (context, state) {
            setState(() {});
          },
        ),
      ],
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currNavIndex,
          onTap: setCurrNav,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 11.sp,
          unselectedFontSize: 11.sp,
          items: getBottomIcons(),
          selectedItemColor: kPrimaryColor,
          selectedIconTheme: const IconThemeData(color: kPrimaryColor),
        ),
        body: UpgradeAlert(
          child: SafeArea(
            child: IndexedStack(
              index: _currNavIndex,
              children: _children,
            ),
          ),
        ),
      ),
    );
  }

  final List<Widget> _children = const [
    HomePage(),
    CustomerScreen(),
    TransactionView(),
    SettingsHome(),
  ];

  List<BottomNavigationBarItem> getBottomIcons() {
    List<SvgData> icons = [
      SvgAssets.home,
      SvgAssets.people,
      SvgAssets.history,
      SvgAssets.settings,
    ];

    List<SvgData> icon = [
      SvgAssets.homeActive,
      SvgAssets.peopleActive,
      SvgAssets.historyActive,
      SvgAssets.settingsActive,
    ];

    List<String> name = [
      'Home',
      'People',
      'History',
      'Settings',
    ];

    List<BottomNavigationBarItem> bottomNavList = List.generate(4, (i) {
      var item = BottomNavigationBarItem(
        label: '',
        icon: SvgIcon(
          svgIcon: icons[i],
          size: 25.r,
        ),
        activeIcon: SvgIcon(
          svgIcon: icon[i],
          color: AppColors.black,
          size: 25.r,
        ),
      );

      return item;
    });

    return bottomNavList;
  }

  void setCurrNav(int index) {
    setState(() {
      _currNavIndex = index;
    });
  }

  void showManagerRequest(ManagerRequest request) async {
    showDialog<bool?>(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          UserCrudCubit userCrudCubit = GetIt.I<UserCrudCubit>();
          return BlocProvider.value(
            value: userCrudCubit,
            child: Builder(builder: (context) {
              return BlocConsumer<UserCrudCubit, UserCrudState>(
                listener: (context, state) {
                  if (state is UserCrudStateFailure) {
                    Get.back();
                    error = state.errorMessage;
                  }
                  if (state is UserCrudStateSuccess) {
                    if (state.isManagerAdd) {
                      Get.back();
                      success = "Manager accepted";
                    }
                    if (state.isManagerReject) {
                      Get.back();
                      success = "Manager rejected";
                    }
                  }
                },
                builder: (context, state) {
                  return WillPopScope(
                    onWillPop: () {
                      return Future.value(false);
                    },
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: 0.5, sigmaY: 0.5, tileMode: TileMode.mirror),
                      child: Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(kDefaultSpacing)),
                        child: Container(
                          height: 300,
                          padding: const EdgeInsets.all(kDefaultSpacing),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "New Manager Request",
                                    style: kTitleTextStyle,
                                  ),
                                  kVerticalSpaceRegular,
                                  Text.rich(
                                    TextSpan(children: [
                                      TextSpan(
                                          text:
                                              "Manager ${request.managerName} ",
                                          style: kBoldTextStyle),
                                      const TextSpan(
                                        text: "with id ",
                                      ),
                                      TextSpan(
                                          text: request.managerId,
                                          style: kBoldTextStyle),
                                      TextSpan(
                                          text:
                                              " has requested to access your list of transactions and gets a commission of ",
                                          style: kDefaultTextStyle),
                                      TextSpan(
                                          text:
                                              "${(request.commission * 100).toStringAsFixed(1)}% ",
                                          style: kBoldTextStyle),
                                      TextSpan(
                                          text: "of every transactions made!",
                                          style: kDefaultTextStyle)
                                    ]),
                                  ),
                                  kVerticalSpaceRegular,
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      bool shouldAccept =
                                          await confirmRequest(true);
                                      if (shouldAccept) {
                                        userCrudCubit.acceptManager(
                                            managerId: request.managerId,
                                            driverId: request.driverId);
                                      }
                                    },
                                    child: state is UserCrudStateLoading &&
                                            state.isManagerAdd
                                        ? const CircularProgressIndicator()
                                        : Text(
                                            "Accept",
                                            style: kWhiteTextStyle.copyWith(
                                                fontWeight: FontWeight.bold),
                                          ),
                                    style: TextButton.styleFrom(
                                      textStyle: kWhiteTextStyle.copyWith(
                                          fontWeight: FontWeight.bold),
                                      backgroundColor: kPrimaryColor,
                                      padding: const EdgeInsets.all(
                                          kDefaultSpacing * 0.5),
                                      minimumSize: Size.zero,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      bool shouldAccept =
                                          await confirmRequest(false);
                                      if (shouldAccept) {
                                        userCrudCubit.rejectManager(
                                            managerId: request.managerId,
                                            driverId: request.driverId);
                                      }
                                    },
                                    child: state is UserCrudStateLoading &&
                                            state.isManagerReject
                                        ? const CircularProgressIndicator()
                                        : Text(
                                            "Reject",
                                            style: kBoldTextStyle,
                                          ),
                                    style: TextButton.styleFrom(
                                      textStyle: kBoldTextStyle,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      padding: const EdgeInsets.all(
                                          kDefaultSpacing * 0.5),
                                      minimumSize: Size.zero,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          );
        });
  }

  Future<bool> confirmRequest(bool shouldAccept) async {
    return await showDialog<bool?>(
            barrierDismissible: true,
            context: context,
            builder: (context) {
              return Dialog(
                  child: Container(
                padding: const EdgeInsets.all(kDefaultSpacing),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Are you sure you want to ${shouldAccept ? 'accept' : 'reject'} manager?",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: kDefaultTextStyle.copyWith(height: 1.35),
                    ),
                    kVerticalSpaceRegular,
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: kPrimaryColor,
                          ),
                          onPressed: () {
                            Get.back(result: true);
                          },
                          child: Text(
                            shouldAccept ? "Accept" : "Reject",
                            style: kBoldTextStyle.copyWith(color: kWhiteColor),
                          )),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: Text(
                        "Cancel",
                        style: kSubtitleTextStyle2,
                      ),
                      onPressed: () {
                        Get.back(result: false);
                      },
                    ),
                  ],
                ),
              ));
            }) ??
        false;
  }
}
