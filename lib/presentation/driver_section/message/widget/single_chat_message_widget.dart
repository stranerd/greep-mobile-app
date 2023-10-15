import 'dart:math';

import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/message/chat_message.dart';
import 'package:greep/presentation/widgets/profile_photo_widget.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:bubble/bubble.dart';
import 'package:greep/domain/message/chat_message.dart';
import 'package:greep/utils/constants/app_colors.dart';

class SingleChatMessageWidget extends StatefulWidget {
  final ChatMessage chatMessage;

  const SingleChatMessageWidget({
    super.key,
    required this.chatMessage,
  });

  @override
  State<SingleChatMessageWidget> createState() =>
      _SingleChatMessageWidgetState();
}

class _SingleChatMessageWidgetState extends State<SingleChatMessageWidget> {


  @override
  Widget build(BuildContext context) {
    // ↓ save screen size
    return Container(
      width: 1.sw,
      alignment: widget.chatMessage.isSender
          ? Alignment.centerLeft
          : Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: kDefaultSpacing.w * 1.3),
      decoration: const BoxDecoration(
        // color: AppColors.red,
      ),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: !widget.chatMessage.isSender
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
          children: [
            if (!widget.chatMessage.isSender)
              Container(
                constraints: BoxConstraints(maxWidth: 0.7.sw),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Flexible(
                      child: IntrinsicWidth(
                        child: Bubble(
                            nip: BubbleNip.leftTop,
                            nipWidth: 0.01.w,
                            padding: BubbleEdges.symmetric(
                                vertical: 12.h,horizontal: 16.w
                            ),
                            radius:
                            Radius.circular(16.r),
                            nipHeight: 23.h,
                            nipRadius: 0,
                            elevation: 0,
                            borderWidth: 0.5.w,
                            borderColor: AppColors.gray2,
                            color: AppColors.gray2,
                            child: TextWidget(
                              widget.chatMessage.message,
                              color: AppColors.black,
                            )),
                      ),
                    )
                  ],
                ),
              )
            else
              Flexible(
                child: LayoutBuilder(builder: (context, constr) {
                  print(constr.maxWidth);
                  return Container(
                    constraints:
                    BoxConstraints(maxWidth: constr.maxWidth * 0.7),
                    decoration: BoxDecoration(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: IntrinsicWidth(
                            child: Bubble(
                                nip: BubbleNip.rightTop,
                                nipWidth: 0.01.w,
                                padding: BubbleEdges.symmetric(
                                  vertical: 12.h,horizontal: 16.w
                                ),
                                radius:
                                Radius.circular(16.r),
                                nipHeight: 23.h,
                                nipRadius: 0,
                                elevation: 0,
                                borderWidth: 0.5.w,
                                borderColor: AppColors.blue,
                                color: AppColors.blue,
                                child: TextWidget(
                                  widget.chatMessage.message,
                                  color: AppColors.white,
                                )),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              )
          ],
        ),
      ),
    );
  }
}
