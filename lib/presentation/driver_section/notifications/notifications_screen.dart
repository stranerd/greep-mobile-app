import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greep/domain/notification/notification.dart';
import 'package:greep/presentation/driver_section/notifications/dialog/cash_request_dialog.dart';
import 'package:greep/presentation/driver_section/notifications/dialog/trip_request_dialog.dart';
import 'package:greep/presentation/driver_section/notifications/widget/notifications_item_widget.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';
import 'package:greep/utils/constants/app_styles.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
  }

  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackIcon(
          isArrow: true,
        ),
        centerTitle: true,
        title: TextWidget(
          "Notifications",
          weight: FontWeight.w700,
          fontSize: 18.sp,
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16.r),
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(width: 1, color: AppColors.black)),
                  child: TabBar(
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: Colors.black,
                    ),
                    labelColor: Colors.white,
                    labelStyle: AppTextStyles.whiteSize12,
                    unselectedLabelColor: Colors.black,
                    unselectedLabelStyle: AppTextStyles.blackSize12,
                    tabs: [
                      Tab(
                        height: 35.h,
                        text: 'Personal',
                      ),
                      Tab(
                        height: 35.h,
                        text: 'Requests',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ListView.separated(
                        separatorBuilder: (_, __) => SizedBox(
                          height: 12.h,
                        ),
                        itemCount: 5,
                        itemBuilder: (c, i) => SplashTap(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return CashRequestDialog();
                                });
                          },
                          child: NotificationsItemWidget(
                            notification: UserNotification.random(),
                          ),
                        ),
                        shrinkWrap: true,
                      ),
                      ListView.separated(
                        separatorBuilder: (_, __) => SizedBox(
                          height: 12.h,
                        ),
                        itemCount: 5,
                        itemBuilder: (c, i) => SplashTap(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return TripRequestDialog();
                                });
                          },
                          child: NotificationsItemWidget(
                            notification: UserNotification.random(),
                          ),
                        ),
                        shrinkWrap: true,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
