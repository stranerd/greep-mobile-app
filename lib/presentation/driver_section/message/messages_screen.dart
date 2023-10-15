import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/message/message_list.dart';
import 'package:greep/presentation/driver_section/message/chat_message_screen.dart';
import 'package:greep/presentation/driver_section/message/widget/message_list_widget.dart';
import 'package:greep/presentation/widgets/custom_appbar.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        title: "Chat",
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16.r),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: kDefaultSpacing.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    12.r,
                  ),
                  border: Border.all(color: const Color(0xFFE0E2E4), width: 2),
                ),
                height: 50.h,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/search.svg",
                      width: 24.r,
                      height: 24.r,
                    ),
                    kHorizontalSpaceSmall,
                    Expanded(
                      child: TextField(
                        onChanged: (s) {
                          if (s.isNotEmpty) {
                          } else {}
                          setState(() {});
                        },
                        style: kDefaultTextStyle.copyWith(
                          fontSize: 15.sp,
                        ),
                        decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.only(
                              left: kDefaultSpacing * 0.5,
                              top: kDefaultSpacing * 0.5,
                              bottom: kDefaultSpacing * 0.5,
                            ),
                            hintText: "Search",
                            border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(
                    vertical: 32.h,
                  ),
                  itemBuilder: (c, i) {
                    var message = MessageList.random();
                    return SplashTap(
                        onTap: () {
                          Get.to(() => ChatMessageScreen(messageList: message));
                        },
                        child: MessageListWidget(messageList: message));
                  },
                  separatorBuilder: (_, __) => SizedBox(
                    height: 24.h,
                  ),
                  itemCount: 5,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
