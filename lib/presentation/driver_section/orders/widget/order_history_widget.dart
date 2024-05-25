import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greep/domain/order/order.dart';
import 'package:greep/presentation/widgets/money_widget.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/presentation/widgets/time_dot_widget.dart';

class OrderHistoryWidget extends StatelessWidget {
  const OrderHistoryWidget({Key? key, required this.order})
      : super(key: key);
  final UserOrder order;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              Image.asset(
                "assets/images/wallet_delivery.png",
                scale: 2,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: 12.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      "Order ${order.id.characters.take(8)}",
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    TimeDotWidget(
                      date: order.date,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        MoneyWidget(amount: order.fee.total ?? 0)

      ],
    );
  }
}
