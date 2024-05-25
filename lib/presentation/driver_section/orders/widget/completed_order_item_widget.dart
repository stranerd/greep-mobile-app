import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:greep/domain/order/order.dart';
import 'package:greep/presentation/widgets/dot_circle.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/presentation/widgets/time_dot_widget.dart';
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset("assets/icons/refresh.svg"),
          SizedBox(width: 20.w,),
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
