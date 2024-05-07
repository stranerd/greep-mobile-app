import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greep/application/user/user_util.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/widgets/custom_popup_menu_divider.dart';
import 'package:greep/presentation/widgets/custom_popup_menu_item.dart';
import 'package:greep/presentation/widgets/dot_circle.dart';
import 'package:greep/presentation/widgets/money_widget.dart';
import 'package:greep/presentation/widgets/progress_indicator_container.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomeOverviewCard extends StatefulWidget {
  const HomeOverviewCard({Key? key}) : super(key: key);

  @override
  State<HomeOverviewCard> createState() => _HomeOverviewCardState();
}

class _HomeOverviewCardState extends State<HomeOverviewCard> {
  int selectedInterval = 0;

  num getSelectedIntervalAmount() {
    return selectedInterval == 0
        ? getUser().rankings?.daily?.value ?? 0
        : selectedInterval == 1
            ? getUser().rankings?.weekly?.value ?? 0
            : selectedInterval == 2
                ? getUser().rankings?.monthly?.value ?? 0
                : 0;
  }

  double getSelectedIntervalRatio() {
    return (selectedInterval == 0
            ? getUser().rankings?.daily?.value ?? 0
            : selectedInterval == 1
                ? getUser().rankings?.weekly?.value ?? 0
                : selectedInterval == 2
                    ? getUser().rankings?.monthly?.value ?? 0
                    : 0) /
        getSelectedIntervalTarget;
  }

  num getSelectedIntervalTarget = 10000;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 12.h,
        horizontal: 12.w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r,),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [
            0.7,
            0.9,
            1
          ],
              colors: [
            Color(
              0xff10BB76,
            ),
            Color(
              0xff10BB76,
            ),
            Color(
              0xff10BB76,
            ).withOpacity(0.75),
          ])),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                "Overview",
                weight: FontWeight.w600,
                color: Colors.white,
                fontSize: 16.sp,
              ),
              PopupMenuButton<int>(
                position: PopupMenuPosition.over,
                splashRadius: 1.r,
                padding: EdgeInsets.symmetric(vertical: 5.h),
                color: Colors.white,
                // initialValue: 1,
                onSelected: (int i) {
                  setState(() {
                    selectedInterval = i;
                  });
                  switch (i) {
                    case 1:
                      {}
                      break;
                    case 2:
                      {}
                      break;
                    case 3:
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
                    PopupMenuItem<int>(
                      height: 35.h,
                      value: 0,
                      child:  CustomPopupMenuItem(
                        text: "Today",
                        textColor: selectedInterval  == 0? AppColors.green : AppColors.black,
                        // icon: "assets/icons/trash.svg",
                        // textColor: Color(0xffF04438),
                      ),
                    ),
                    CustomPopupMenuDivider(
                      color: AppColors.black.withOpacity(0.15),
                      height: 0.5.h,
                      thickness: 0.5.r,
                    ),
                    PopupMenuItem<int>(
                      height: 30.h,
                      value: 1,
                      child:  CustomPopupMenuItem(
                        text: "Week",
                        textColor: selectedInterval  == 1? AppColors.green : AppColors.black,
                        // icon: "assets/icons/help.svg",
                      ),
                    ),
                    CustomPopupMenuDivider(
                      color: AppColors.black.withOpacity(0.15),
                      height: 0.5.h,
                      thickness: 0.5.r,
                    ),
                    PopupMenuItem<int>(
                      height: 30.h,
                      value: 2,
                      child:  CustomPopupMenuItem(
                        text: "Month",
                        textColor: selectedInterval  == 2? AppColors.green : AppColors.black,

                        // icon: "assets/icons/help.svg",
                      ),
                    ),
                  ];
                },
                child: Row(
                  children: [
                    TextWidget(
                      selectedInterval == 0 ? "Today" : selectedInterval == 1 ? "This Week" : "This Month",
                      color: Colors.white,

                    ),
                    kHorizontalSpaceTiny,
                    SvgPicture.asset(
                      "assets/icons/filter.svg",
                      color: Colors.white,

                    )
                  ],
                ),
              ),
            ],
          ),
          kVerticalSpaceRegular,
          ProgressIndicatorContainer(
            progress: getSelectedIntervalRatio(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  "${selectedInterval == 0 ? "Daily" : selectedInterval == 1 ? "Weekly" : "Monthly"} target",
                ),
                Row(
                  children: [
                    MoneyWidget(
                      amount: getSelectedIntervalAmount(),
                      weight: FontWeight.bold,
                    ),
                    kHorizontalSpaceTiny,
                    const TextWidget(
                      "/",
                      weight: FontWeight.bold,
                    ),
                    kHorizontalSpaceTiny,
                    MoneyWidget(
                      amount: getSelectedIntervalTarget,
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
                          TextWidget("Target reached",
                          color: Colors.white,
                          ),
                        ],
                      ),
                      kVerticalSpaceRegular,
                      Row(
                        children: [
                          DotCircle(color: AppColors.coinGold),
                          kHorizontalSpaceSmall,
                          TextWidget("Above average",
                          color: Colors.white,
                          ),
                        ],
                      ),
                      kVerticalSpaceRegular,
                      Row(
                        children: [
                          DotCircle(color: AppColors.red),
                          kHorizontalSpaceSmall,
                          TextWidget("Poor performance",
                          color: Colors.white,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  width: cs.maxWidth * 0.5,
                  alignment: Alignment.centerRight,
                  child: Builder(builder: (context) {
                    return SizedBox(
                      width: 108.r,
                      height: 108.r,
                      child: CircularPercentIndicator(
                        backgroundColor: AppColors.gray2,
                        percent: getSelectedIntervalRatio(),
                        startAngle: 90,
                        animation: true,
                        animationDuration: 1200,
                        circularStrokeCap: CircularStrokeCap.round,
                        radius: 50.r,
                        progressColor: AppColors.coinGold,
                        lineWidth: 20.w,
                        center: TextWidget(
                          "${getSelectedIntervalRatio() * 100}%",
                          color: getSelectedIntervalRatio() >= 1
                              ? AppColors.green
                              : getSelectedIntervalRatio() < 0.5
                                  ? AppColors.red
                                  : AppColors.coinGold,
                          fontSize: 18.sp,
                          weight: FontWeight.bold,
                        ),
                      ),
                    );
                  }),
                )
              ],
            );
          })
        ],
      ),
    );
  }
}
