import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:greep/domain/order/order.dart';
import 'package:greep/presentation/driver_section/orders/track_order_screen.dart';
import 'package:greep/presentation/widgets/dot_circle.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
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
      subtitle:(order.data.type == OrderType.cart) ?Row(
        children: [
           TextWidget(
            "Qty: ${order.data.cartData!.products.length} pcs",
            color: AppColors.veryLightGray,
          ),
          SizedBox(width: 5.w,),
          // DotCircle(color: AppColors.veryLightGray,size: 3.r,),
          // SizedBox(width: 5.w,),
          //
          // const TextWidget("Kg: 7kg",color: AppColors.veryLightGray,),
        ],
      ): null,
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
