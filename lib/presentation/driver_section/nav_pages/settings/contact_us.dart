import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/driver_section/widgets/settings_home_item.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:greep/presentation/widgets/text_widget.dart';

import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_styles.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _textController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackIcon(
          isArrow: true,
        ),
        title: TextWidget(
          "Support",
          fontSize: 18.sp,
          weight: FontWeight.bold,
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
          child: Column(
            children: [
              TextFormField(
                controller: _textController,
                minLines: 3,
                maxLines: 3,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(
                    16.w,
                    14.h,
                    16.w,
                    14.h,
                  ),
                  hintText: "Send us a message",
                  hintStyle: kDefaultTextStyle.copyWith(
                      fontSize: 14.sp, color: AppColors.veryLightGray),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(width: 2.w, color: AppColors.gray2),
                  ),
                ),
              ),
              SizedBox(
                height: 16.0.h,
              ),
              SubmitButton(
                text: "Send",
                onSubmit: () {},
              ),
              SizedBox(
                height: 24.h,
              ),
              Center(
                child: TextWidget(
                  "OR",
                  fontSize: 16.sp,
                  weight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 24.h,
              ),
              const SettingsHomeItem(
                title: "WhatsApp",
                icon: "assets/icons/whatsapp.svg",
                withTrail: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
