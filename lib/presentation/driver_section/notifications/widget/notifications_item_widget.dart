import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greep/domain/notification/user_notification.dart';
import 'package:greep/presentation/widgets/box_shadow_container.dart';
import 'package:greep/presentation/widgets/dot_circle.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/presentation/widgets/time_dot_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class NotificationsItemWidget extends StatelessWidget {
  final UserNotification notification;

  const NotificationsItemWidget({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BoxShadowContainer(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                notification.title,
              ),
              TextWidget(
                notification.body,
                fontSize: 12.sp,
                color: AppColors.veryLightGray,
              ),
            ],
          ),
        ),
        SizedBox(width: 10.w,),
        if (notification.seen) DotCircle(color: AppColors.blue)
      ],
    ));
  }
}
