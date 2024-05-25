import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:greep/domain/order/order.dart';
import 'package:greep/presentation/driver_section/orders/track_order_screen.dart';
import 'package:greep/presentation/widgets/dot_circle.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/presentation/widgets/time_dot_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class ActiveOrderItemWidget extends StatelessWidget {
  const ActiveOrderItemWidget({Key? key, required this.order}) : super(key: key);
  final UserOrder order;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset(
        "assets/icons/active_order_item.svg",
      ),
      title: TextWidget(
        "Order #${order.id.characters.take(6)}...",
        weight: FontWeight.w500,
      ),
      subtitle:
      Row(
        children: [
          TextWidget(
            (order.data.type == OrderType.cart) ? "cart":"dispatch",
            fontStyle: FontStyle.italic,
            color: AppColors.veryLightGray,
            fontSize: 11.sp,
            weight: FontWeight.bold,
          ),
          SizedBox(
            width: 8.w,
          ),

          SizedBox(
            width: 5.w,
          ),
          TimeDotWidget(date: order.date,fontSize: 11.sp,),
        ],
      )
      ,
      trailing: SplashTap(
        onTap: (){
          Get.to(() => TrackOrderScreen(order: order,));
        },
        child: TextWidget(
          "Track Order",
          color: AppColors.blue,
          decoration: TextDecoration.underline,
          fontSize: 12.sp,
        ),
      ),
    );
  }
}
