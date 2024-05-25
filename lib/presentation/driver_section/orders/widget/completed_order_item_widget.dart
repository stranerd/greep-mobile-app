import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:greep/domain/order/order.dart';
import 'package:greep/presentation/widgets/dot_circle.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class CompletedOrderItemWidget extends StatelessWidget {
  final UserOrder order;
  const CompletedOrderItemWidget({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset(
        "assets/icons/active_order_item.svg",
      ),
      title:  TextWidget(
        "Order #${order.id.characters.take(6)}",
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset("assets/icons/refresh.svg"),
          SizedBox(width: 28.w,),
          TextWidget(
            "View order",
            color: AppColors.blue,
            decoration: TextDecoration.underline,
            fontSize: 12.sp,
          ),
        ],
      ),
    );
  }
}
