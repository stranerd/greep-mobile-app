import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';


showInAppNotification(BuildContext context,{required String title,required String body, int? duration, bool isSuccess = true,}){

  Get.showSnackbar(
      GetSnackBar(
        titleText: TextWidget(
          title,
          weight: FontWeight.bold,
          fontSize: 12.sp,
          color: const Color(0xff2F3F53),
        ),
        icon: SvgPicture.asset(
          "assets/icons/${isSuccess ? 'in-app-success' : 'in-app-failure'}.svg",

          width: 24.r,
          height: 24.r,
        ),
        messageText: TextWidget(
          body,
          softWrap: true,
          fontSize: 10.sp,
          color: const Color(0xff2F3F53),
        ),
        borderRadius: 12.r,
        borderColor:  isSuccess ? const Color(0xff48C1B5) : AppColors.red,
        maxWidth: 0.9.sw,
        backgroundColor:
        isSuccess
            ? const Color(0xffF6FFF9)
            : const Color(
          0xffF2DCDC,
        ),
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: duration ?? 2),
      ),
  );
}

class InAppNotificationWidget extends StatelessWidget {
  final String title;
  final String body;
  final bool isSuccess;
  final BuildContext parentContext;

  const InAppNotificationWidget(this.parentContext,{
    Key? key,
    required this.title,
    required this.body,

    this.isSuccess = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.05.sw,),
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 12.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          12.r,
        ),
        color: isSuccess
            ? const Color(0xffF6FFF9)
            : const Color(
                0xffF2DCDC,
              ),
        border:
            Border.all(color: isSuccess ? const Color(0xff48C1B5) : AppColors.red),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            "assets/icons/${isSuccess ? 'in-app-success' : 'in-app-failure'}.svg",
            width: 24.r,
            height: 24.r,
          ),
          SizedBox(
            width: 12.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  title,
                  weight: FontWeight.bold,
                  fontSize: 12.sp,
                  color: const Color(0xff2F3F53),
                ),
                SizedBox(
                  height: 4.h,
                ),
                TextWidget(
                  body,
                  softWrap: true,
                  fontSize: 10.sp,
                  color: const Color(0xff2F3F53),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w,),
          GestureDetector(
            onTap: (){
              // Get.back();
              // InAppNotification.dismiss(context: context,);
            },
            child: SvgPicture.asset(
              "assets/icons/close2.svg",
              width: 24.r,
              height: 24.r,
            ),
          ),

        ],
      ),
    );
  }
}
