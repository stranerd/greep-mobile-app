import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greep/application/notification/user_notification_cubit.dart';
import 'package:greep/domain/notification/user_notification.dart';
import 'package:greep/ioc.dart';
import 'package:greep/presentation/driver_section/notifications/dialog/cash_request_dialog.dart';
import 'package:greep/presentation/driver_section/notifications/dialog/trip_request_dialog.dart';
import 'package:greep/presentation/driver_section/notifications/widget/notifications_item_widget.dart';
import 'package:greep/presentation/driver_section/widgets/empty_result_widget.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/empty_result_widget2.dart';
import 'package:greep/presentation/widgets/loading_widget.dart';
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

  late UserNotificationCubit notificationCubit;

  @override
  void initState() {
    super.initState();
    notificationCubit = getIt()..fetchNotifications();
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
          padding: EdgeInsets.all(16.r,),
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r,),
                      color: Color(0xffF0F3F6)
                  ),
                  child: TabBar(
                    onTap: (i) {
                      setState(() {
                        tabIndex = i;
                      });
                    },
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r,),
                        color:AppColors.black
                    ),
                    labelColor: Colors.white,
                    labelStyle: AppTextStyles.whiteSize12.copyWith(
                        fontWeight: FontWeight.bold

                    ),
                    unselectedLabelColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.tab,

                    unselectedLabelStyle: AppTextStyles.blackSize12.copyWith(
                    ),
                    tabs: [
                      Tab(
                        height: 35.h,
                        text: 'Personal',
                      ),
                      Tab(
                        height: 35.h,
                        text: 'Campaign',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      notificationCubit.fetchNotifications();
                    },
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: BlocBuilder<UserNotificationCubit, UserNotificationState>(
                        builder: (context, notificationState) {
                          if (notificationState is UserNotificationStateLoading){
                            return LoadingWidget(
                              isGreep: true,
                              topPadding: 60.h,
                            );
                          }
                          if (notificationState is UserNotificationStateFetched){
                            if (notificationState.notifications.isEmpty){
                              return EmptyResultWidget2(
                                top: 60.h,
                                icon: SvgPicture.asset("assets/icons/empty_result.svg"),
                                subtitle:
                                "No notifications yet? The calm before the excitement. Stay tuned for updates!",
                              );
                            }
                            return ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (_, __) =>
                                  SizedBox(
                                    height: 12.h,
                                  ),
                              itemCount: notificationState.notifications.length,
                              itemBuilder: (c, i) {
                                var notification = notificationState.notifications[i];
                                return SplashTap(
                                  onTap: () {
                                    // showModalBottomSheet(
                                    //     context: context,
                                    //     builder: (context) {});
                                  },
                                  child: NotificationsItemWidget(
                                    notification: notification,
                                  ),
                                );
                              },
                              shrinkWrap: true,
                            );
                          }
                          return EmptyResultWidget2(
                            top: 60.h,
                            icon: SvgPicture.asset("assets/icons/empty_result.svg"),
                            subtitle:
                            "No notifications yet? The calm before the excitement. Stay tuned for updates!",
                          );
                        },
                      ),
                    ),
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
