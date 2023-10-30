import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greep/domain/message/message_list.dart';
import 'package:greep/presentation/widgets/profile_photo_widget.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class MessageListWidget extends StatelessWidget {
  final MessageList messageList;
  const MessageListWidget({Key? key, required this.messageList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                ProfilePhotoWidget(
                  url: "",
                  radius: 24,
                  initials: "",
                ),
                SizedBox(width: 12.w),

                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          messageList.receiver.firstName,
                          textAlign: TextAlign.right,
                          weight: FontWeight.w600,
                        ),
                        const SizedBox(height: 1),
                        Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextWidget(
                                'I have arrived',
                                textAlign: TextAlign.center,
                                fontSize: 12.sp,
                                color: AppColors.veryLightGray,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextWidget(
                '10:48',
                color: AppColors.veryLightGray,
                fontSize: 12.sp,

              ),
              SizedBox(height: 1.h),
              Container(
                width: 20.r,
                height: 20.r,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFF0150C5),
                  shape: BoxShape.circle
                ),
                child: TextWidget(
                  messageList.unreadCount.toString(),
                  color: AppColors.white,
                  fontSize: 12.sp,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
