import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({Key? key, required this.content, required this.yesText, required this.noText, this.icon, this.yesColor, this.noColor}) : super(key: key);
  final Widget content;
  final String yesText;
  final String noText;
  final Widget? icon;
  final Color? yesColor;
  final Color? noColor;


  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(kDefaultSpacing
      ),
        child: Container(
          padding: const EdgeInsets.all(kDefaultSpacing),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon ?? SvgPicture.asset("assets/icons/gift.svg", color: AppColors.coinGold,width: 33.w,height: 33.h,),
              kVerticalSpaceRegular,
              content,
              kVerticalSpaceMedium,

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SplashTap(
                      onTap: () {
                        Get.back(result: false);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(kDefaultSpacing * 0.5),
                        decoration: BoxDecoration(
                          color: noColor ?? AppColors.black,
                          borderRadius: BorderRadius.circular(kDefaultSpacing * 0.3)
                        ),
                        child: TextWidget(
                          noText,
                          color: Colors.white,
                          weight: FontWeight.bold,
                          fontSize: 17.sp,
                        ),
                      ),
                    ),
                  ),
                  kHorizontalSpaceRegular,
                  Expanded(
                    child: SplashTap(
                      onTap: () {
                        Get.back(result: true);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(kDefaultSpacing * 0.5),
                        decoration: BoxDecoration(
                            color: yesColor ?? AppColors.black,
                            borderRadius: BorderRadius.circular(kDefaultSpacing * 0.3)
                        ),
                        child: TextWidget(
                          yesText,
                          color: Colors.white,
                          weight: FontWeight.bold,
                          fontSize: 17.sp,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ));

  }
}
