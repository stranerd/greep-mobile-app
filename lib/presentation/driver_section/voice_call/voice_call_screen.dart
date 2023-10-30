import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/profile_photo_widget.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class VoiceCallScreen extends StatefulWidget {
  const VoiceCallScreen({Key? key}) : super(key: key);

  @override
  _VoiceCallScreenState createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen> {
  bool isMuted = false;
  bool isSpeaker = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackIcon(
          isArrow: true,
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 34.w,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  ProfilePhotoWidget(
                    url: "",
                    initials: "AL",
                    radius: 64,
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  TextWidget(
                    "Albert Johnson",
                    fontSize: 22.sp,
                    weight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  TextWidget(
                    "Calling",
                    color: AppColors.veryLightGray,
                    fontSize: 16.sp,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildItem(
                      asset: "call-speaker",
                      color: !isSpeaker ?AppColors.lightGray: AppColors.black,
                      iconColor: isSpeaker ? Colors.white : AppColors.black,
                      onTap: () {
                        setState(() {
                          isSpeaker = !isSpeaker;
                        });
                      }),
                  _buildItem(
                      asset: "call-mute",
                      color: !isMuted ?AppColors.lightGray: AppColors.black,
                      iconColor: isMuted ? Colors.white : AppColors.black,
                      onTap: () {
                        setState(() {
                          isMuted = !isMuted;
                        });
                      }),
                  _buildItem(
                      asset: "call-end",
                      color: AppColors.red,
                      iconColor: Colors.white ,
                      onTap: () {
                        Get.back();
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem({
    required String asset,
    required Color color,
    Color iconColor = AppColors.black,
    required Function onTap,
  }) {
    return SplashTap(

      onTap: (){
        onTap();
      },
      child: Container(
          width: 56.r,
          height: 56.r,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            "assets/icons/$asset.svg",
            fit: BoxFit.cover,
            color: iconColor,
          )),
    );
  }
}
