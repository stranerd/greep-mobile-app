import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:greep/application/user/user_list_cubit.dart';
import 'package:greep/domain/user/model/User.dart';
import 'package:greep/ioc.dart';
import 'package:greep/presentation/driver_section/leaderboard/widgets/leaderboard_achievement_widget.dart';
import 'package:greep/presentation/driver_section/leaderboard/widgets/leaderboard_ranking_widget.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/box_shadow_container.dart';
import 'package:greep/presentation/widgets/custom_popup_menu_divider.dart';
import 'package:greep/presentation/widgets/custom_popup_menu_item.dart';
import 'package:greep/presentation/widgets/empty_result_widget2.dart';
import 'package:greep/presentation/widgets/loading_widget.dart';
import 'package:greep/presentation/widgets/progress_indicator_container.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late UserListCubit userListCubit;

  String rankingType = "daily";
  @override
  void initState() {
    super.initState();
    userListCubit = getIt()..fetchUserRankings(rankingType: rankingType);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: userListCubit,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: const BackIcon(
              isArrow: true,
            ),
          ),
          centerTitle: true,
          title: TextWidget(
            "Leaderboard",
            fontSize: 18.sp,
            weight: FontWeight.bold,
          ),
        ),
        body: RefreshIndicator.adaptive(
          onRefresh: () async {
            userListCubit.fetchUserRankings(rankingType: rankingType);
          },
          child: ListView(
            padding: EdgeInsets.all(16.r),
            shrinkWrap: true,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    "Your level",
                    fontSize: 16.sp,
                    weight: FontWeight.bold,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/star-gold.svg",
                        width: 12.r,
                        height: 12.r,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      TextWidget(
                        "Recruit",
                        fontSize: 16.sp,
                        weight: FontWeight.bold,
                        color: AppColors.coinGold,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      SvgPicture.asset(
                        "assets/icons/star-gold.svg",
                        width: 12.r,
                        height: 12.r,
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 16.h,
              ),
              BoxShadowContainer(
                  child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        "Next level",
                        color: AppColors.veryLightGray,
                      ),
                      TextWidget(
                        "Private",
                        color: AppColors.veryLightGray,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  ProgressIndicatorContainer(
                    progress: 0,
                    child: Container(),
                    height: 12.h,
                  ),
                ],
              )),
              SizedBox(
                height: 24.h,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    "Achievements",
                    fontSize: 14.sp,
                    weight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                          child: LeaderboardAchievementWidget(
                              asset: "assets/icons/cup.svg",
                              title: "0",
                              subtitle: "Top 3 finishes")),
                      SizedBox(
                        width: 12.w,
                      ),
                      const Expanded(
                          child: LeaderboardAchievementWidget(
                              asset: "assets/icons/flash.svg",
                              title: "0",
                              subtitle: "Top 3 Streak")),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 24.h,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        "${rankingType.capitalizeFirst} ranking",
                        fontSize: 16.sp,
                        weight: FontWeight.bold,
                      ),
                      PopupMenuButton<String>(
                        position: PopupMenuPosition.over,
                        splashRadius: 1.r,
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        color: Colors.white,
                        // initialValue: 1,
                        onSelected: (String i) {
                          setState(() {
                            rankingType = i;
                          });
                          userListCubit.fetchUserRankings(rankingType: rankingType);
                          switch (i) {
                            case "daily":
                              {}
                              break;
                            case "weekly":
                              {}
                              break;
                            case "monthly":
                              {}
                              break;
                          }
                        },
                        onOpened: () {
                          print("Opened");
                        },
                        itemBuilder: (context) {
                          // if (index != 4) {
                          //   return [];
                          // }
                          return [
                            PopupMenuItem<String>(
                              height: 35.h,
                              value: "daily",
                              child:  CustomPopupMenuItem(
                                text: "Daily",
                                textColor: rankingType == "daily"? AppColors.green : AppColors.black,
                                // icon: "assets/icons/trash.svg",
                                // textColor: Color(0xffF04438),
                              ),
                            ),
                            CustomPopupMenuDivider(
                              color: AppColors.black.withOpacity(0.15),
                              height: 0.5.h,
                              thickness: 0.5.r,
                            ),
                            PopupMenuItem<String>(
                              height: 30.h,
                              value: "weekly",
                              child:  CustomPopupMenuItem(
                                text: "Weekly",
                                textColor: rankingType  == "weekly"? AppColors.green : AppColors.black,
                                // icon: "assets/icons/help.svg",
                              ),
                            ),
                            CustomPopupMenuDivider(
                              color: AppColors.black.withOpacity(0.15),
                              height: 0.5.h,
                              thickness: 0.5.r,
                            ),
                            PopupMenuItem<String>(
                              height: 30.h,
                              value: "monthly",
                              child:  CustomPopupMenuItem(
                                text: "Monthly",
                                textColor: rankingType  == "monthly"? AppColors.green : AppColors.black,

                                // icon: "assets/icons/help.svg",
                              ),
                            ),
                          ];
                        },
                        child: SvgPicture.asset(
                          "assets/icons/filter.svg",

                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  BlocBuilder<UserListCubit, UserListState>(
                    builder: (context, listState) {
                      if (listState is UserListStateLoading) {
                        return Center(
                          child: LoadingWidget(
                            size: 50.r,
                            topPadding: 60.h,
                            isGreep: true,
                          ),
                        );
                      }
                      if (listState is UserListStateRankings) {
                        if (listState.users.isEmpty) {
                          return EmptyResultWidget2(
                            top: 50.h,
                            subtitle: "No rankings data found",
                          );
                        }

                        return ListView.separated(
                          padding: EdgeInsets.only(
                            bottom: 100.h
                          ),
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (_, __) => SizedBox(
                            height: 12.h,
                          ),
                          shrinkWrap: true,
                          itemCount: listState.users.length,
                          itemBuilder: (c, index) {
                            User user = listState.users[index];
                            return LeaderboardRankingWidget(
                              user: user,
                              index: index + 1,
                            );
                          },
                        );
                      }
                      return Container();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
