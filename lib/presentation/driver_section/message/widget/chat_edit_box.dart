// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:greep/utils/constants/app_colors.dart';

import 'action_message_button.dart';

ScrollController _scrollController = ScrollController();

class ChatEditBox extends StatelessWidget {
  final Function(String) onChanged;
  final FocusNode focusNode;
  final TextEditingController msgController;
  final Function() onSendMessage;

  const ChatEditBox({
    Key? key,
    required this.onChanged,
    required this.msgController,
    required this.onSendMessage,
    required this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isTyping = msgController.text.isNotEmpty;
    return SafeArea(
      child: Container(
        // height: 65.h,
        width: 1.sw,

        decoration: BoxDecoration(color: Colors.white),
        margin: EdgeInsets.only(top: 10.h),
        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
          vertical: 12.h,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.r),
                    border: Border.all(
                      color:
                          isTyping ? AppColors.veryLightGray : AppColors.gray2,
                      width: 2.w,
                    ),
                    color: Colors.white),
                // height: 40,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ConstrainedBox(
                        constraints: new BoxConstraints(
                          minWidth: 1.sw,
                          maxWidth: 1.sw,
                          // minHeight: 20.0.h,
                          maxHeight: 120.0.h,
                        ),
                        child: Scrollbar(
                          controller: _scrollController,
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: onChanged,
                            focusNode: focusNode,
                            // autofocus: true,
                            controller: msgController,
                            keyboardType: TextInputType.multiline,
                            style: kDefaultTextStyle.copyWith(
                                fontSize: 14.sp, color: AppColors.black),
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: "Enter message",
                              // fillColor: DColors.white,
                              hintStyle: kDefaultTextStyle.copyWith(
                                color: AppColors.veryLightGray,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              isDense: true,
                              // filled: true,
                              border: OutlineInputBorder(
                                  // borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10.w),
                            ),
                          ),
                        ),
                      ),
                    ),
                    kHorizontalSpaceSmall,
                    ActionMessageButton(
                      isTyping: isTyping,
                      onTap: onSendMessage,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
