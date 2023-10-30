import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/driver_section/qr_code/scan_qr_code.dart';
import 'package:greep/presentation/widgets/app_dialog.dart';
import 'package:greep/presentation/widgets/box_shadow_container.dart';
import 'package:greep/presentation/widgets/money_widget.dart';
import 'package:greep/presentation/widgets/profile_photo_widget.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class CashRequestDialog extends StatefulWidget {
  const CashRequestDialog({Key? key}) : super(key: key);

  @override
  _CashRequestDialogState createState() => _CashRequestDialogState();
}

class _CashRequestDialogState extends State<CashRequestDialog> {
  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: "Cash Request",
      child: Column(
        children: [
          const MoneyWidget(
            amount: 150,
            weight: FontWeight.bold,
            size: 28,
          ),
          SizedBox(
            height: 16.h,
          ),
          BoxShadowContainer(
              child: LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: constraints.maxWidth * 0.46,
                        child: const TextWidget(
                          "Location",
                          color: AppColors.veryLightGray,
                        )),
                    Container(
                      width: constraints.maxWidth * 0.46,
                      child: const TextWidget(
                        "11 James Onaja Cresecent Avujs",
                        softWrap: true,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 16.h,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    const TextWidget(
                      "Customer",
                      color: AppColors.veryLightGray,
                    ),
                    Row(
                      children: [
                        const TextWidget(
                          "Alber Wilson",
                          weight: FontWeight.bold,
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        const ProfilePhotoWidget(
                          url: "",
                          radius: 12,
                          initials: "",
                        ),
                      ],
                    ),

                  ],
                ),

              ],
            );
          })),
          SizedBox(height: 24.h,),
          SubmitButton(text: "Accept", onSubmit: (){
            Get.to(() => ScanQrCode());
          },),
          SizedBox(height: 12.h,),
          SubmitButton(text: "Reject", onSubmit: (){


          },backgroundColor: Colors.white,isBorder: true,borderColor: AppColors.black,textStyle: kDefaultTextStyle.copyWith(
              fontSize: 14.sp
          ),)
        ],
      ),
    );
  }
}
