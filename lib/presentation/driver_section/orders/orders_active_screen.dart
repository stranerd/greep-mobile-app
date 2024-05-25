import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:greep/application/order/order_list_cubit.dart';
import 'package:greep/domain/order/order.dart';
import 'package:greep/presentation/driver_section/orders/track_order_screen.dart';
import 'package:greep/presentation/driver_section/orders/widget/active_order_item_widget.dart';
import 'package:greep/presentation/driver_section/widgets/empty_result_widget.dart';
import 'package:greep/presentation/widgets/empty_result_widget2.dart';
import 'package:greep/presentation/widgets/loading_widget.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/utils/constants/app_colors.dart';

class OrdersActiveScreen extends StatefulWidget {
  const OrdersActiveScreen({Key? key}) : super(key: key);

  @override
  _OrdersActiveScreenState createState() => _OrdersActiveScreenState();
}

class _OrdersActiveScreenState extends State<OrdersActiveScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderListCubit, OrderListState>(
      builder: (context, orderState) {
        if (orderState is OrderListStateFetched) {
          if (orderState.orders.isEmpty) {
            return EmptyResultWidget2(
              top: 0.2.sh,
              icon: SvgPicture.asset("assets/icons/empty_result.svg"),
              subtitle:
              "You have no active orders",
            );
          }
          return ListView.separated(
            padding: EdgeInsets.only(
              top: 15.h,
            ),
            itemBuilder: (context, index) {
              UserOrder order = orderState.orders[index];
              return SplashTap(
                  onTap: (){
                    Get.to(() => TrackOrderScreen(order: order));
                  },

                  child: ActiveOrderItemWidget(order: order));
            },
            separatorBuilder: (context, index) => Divider(
              color: AppColors.veryLightGray.withOpacity(0.3),
            ),
            itemCount: orderState.orders.length,
            shrinkWrap: true,
          );
        }
        if (orderState is OrderListStateLoading){
          return Center(
            child: LoadingWidget(

              isGreep: true,
            ),
          );
        }

        return EmptyResultWidget2(
          top: 0.20.sh,

          icon: SvgPicture.asset("assets/icons/empty_result.svg"),
          subtitle:
              "You have no active orders",
        );
      },
    );
  }
}
