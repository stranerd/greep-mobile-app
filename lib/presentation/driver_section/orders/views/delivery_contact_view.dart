import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greep/presentation/widgets/text_widget.dart';

class DeliveryContactView extends StatelessWidget {
  const DeliveryContactView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextWidget("You can contact the delivery man directly or chat with our support",fontSize: 10.sp,),
        SizedBox(height: 10.h,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/icons/call-delivery-agent.svg",),
            SizedBox(width: 16.w,),
            SvgPicture.asset("assets/icons/call-support.svg",),

          ],
        ),
      ],
    );
  }
}
