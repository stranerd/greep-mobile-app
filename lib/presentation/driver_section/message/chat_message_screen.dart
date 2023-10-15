import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:greep/domain/message/chat_message.dart';
import 'package:greep/domain/message/message_list.dart';
import 'package:greep/presentation/driver_section/message/widget/chat_edit_box.dart';
import 'package:greep/presentation/driver_section/message/widget/single_chat_message_widget.dart';
import 'package:greep/presentation/widgets/profile_photo_widget.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class ChatMessageScreen extends StatefulWidget {
  final MessageList messageList;

  const ChatMessageScreen({Key? key, required this.messageList})
      : super(key: key);

  @override
  _ChatMessageScreenState createState() => _ChatMessageScreenState();
}

class _ChatMessageScreenState extends State<ChatMessageScreen> {
  FocusNode focusNode = FocusNode();
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        leadingWidth: 55.w,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            width: 52.w,
            alignment: Alignment.center,
            height: double.maxFinite,
            decoration: const BoxDecoration(),
            child: SvgPicture.asset(
              "assets/icons/arrowleft.svg",
              color: AppColors.black,
            ),
          ),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            const ProfilePhotoWidget(
              url: "",
              radius: 24,
            ),
            SizedBox(
              width: 12.w,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  widget.messageList.receiver.firstName,
                  weight: FontWeight.bold,
                ),
                const TextWidget(
                  "Last seen 12:11",
                  color: AppColors.veryLightGray,
                ),
              ],
            ),
          ],
        ),
        actions: [
          SplashTap(
            onTap: () {},
            child: SvgPicture.asset(
              "assets/icons/scanner.svg",
              width: 24.r,
              height: 24.r,
            ),
          ),
          SizedBox(
            width: 16.w,
          ),
          SplashTap(
            onTap: () {},
            child: SvgPicture.asset(
              "assets/icons/dollar.svg",
              width: 24.r,
              height: 24.r,
            ),
          ),
          SizedBox(
            width: 16.w,
          ),
          SplashTap(
            onTap: () {},
            child: SvgPicture.asset(
              "assets/icons/call.svg",
              width: 24.r,
              height: 24.r,
            ),
          ),
          SizedBox(
            width: 16.w,
          )
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView.separated(
                reverse: true,
                padding: EdgeInsets.only(
                  bottom: 90.h,
                  top: 10.h,
                ),
                itemCount: 20,
                separatorBuilder: (_, __) => SizedBox(
                      height: 16.h,
                    ),
                itemBuilder: (context, index) {
                  return SingleChatMessageWidget(
                    chatMessage: ChatMessage.random(),
                  );
                }),
            Align(
              alignment: Alignment.bottomCenter,
              child: ChatEditBox(
                focusNode: focusNode,
                onChanged: (value) {
                  setState(() {});
                },
                msgController: messageController,
                onSendMessage: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
