import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greep/application/order/order_list_cubit.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/ioc.dart';
import 'package:greep/presentation/driver_section/orders/orders_active_screen.dart';
import 'package:greep/presentation/driver_section/orders/orders_completed_screen.dart';
import 'package:greep/presentation/driver_section/orders/orders_new_screen.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late OrderListCubit orderListCubit;

  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    orderListCubit = getIt()..fetchNewOrders();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: orderListCubit,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: BackIcon(
            isArrow: true,
          ),
          title: TextWidget(
            "Orders",
            fontSize: 18.sp,
            weight: FontWeight.w600,
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Column(
          children: [
            Expanded(
              child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      TabBar(
                        onTap: (i) {
                          if (i > 0) {
                            orderListCubit.fetchUserOrders(
                              isActive: i == 1,
                            );
                          }
                          else {
                            orderListCubit.fetchNewOrders();
                          }
                          setState(() {
                            tabIndex = i;
                          });
                        },
                        indicator: BoxDecoration(
                            border: Border(
                          bottom: BorderSide(
                              width: 2.w, color: AppColors.darkGreen),
                        )),
                        dividerColor: AppColors.veryLightGray,
                        labelColor: AppColors.darkGreen,
                        unselectedLabelColor: AppColors.veryLightGray,
                        labelStyle: kDefaultTextStyle.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,

                        unselectedLabelStyle: kDefaultTextStyle.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.veryLightGray,
                        ),
                        tabs: const [
                          Tab(
                            text: "New",
                          ),
                          Tab(
                            text: "Active",
                          ),
                          Tab(
                            text: "Completed",
                          )
                        ],
                      ),
                      const Expanded(
                          child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          OrdersNewScreen(),
                          OrdersActiveScreen(),
                          OrdersCompletedScreen(),
                        ],
                      ))
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
