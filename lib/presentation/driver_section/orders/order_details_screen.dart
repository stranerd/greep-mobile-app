import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:greep/domain/order/order.dart';
import 'package:greep/presentation/driver_section/nav_pages/nav_bar/nav_bar_view.dart';
import 'package:greep/presentation/driver_section/orders/views/delivery_contact_view.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/box_shadow_container.dart';
import 'package:greep/presentation/widgets/money_widget.dart';
import 'package:greep/presentation/widgets/profile_photo_widget.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/presentation/widgets/time_dot_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class OrderDetailsScreen extends StatefulWidget {
  final UserOrder order;
  final bool fromCheckout;

  const OrderDetailsScreen(
      {Key? key, required this.order, this.fromCheckout = false})
      : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: BackIcon(
          isArrow: true,
        ),
        title: TextWidget(
          "Delivery details",
          weight: FontWeight.bold,
          fontSize: 18.sp,
        ),
      ),
      body: SafeArea(
        child: Container(
          height: 1.sh,
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(
                  16.r,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BoxShadowContainer(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                MoneyWidget(
                                  amount: widget.order.fee.total ?? 0,
                                  size: 20,
                                  weight: FontWeight.bold,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            TextWidget(
                              "Delivery Agent",
                              color: AppColors.veryLightGray,
                              fontSize: 12.sp,
                            )
                          ],
                        ),
                        const ProfilePhotoWidget(
                          url: "",
                          radius: 22,
                          initials: "",
                        ),
                      ],
                    )),
                    SizedBox(
                      height: 24.h,
                    ),
                    BoxShadowContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buidItem("Price", "N/A",
                              widgetValue: MoneyWidget(
                                amount: widget.order.fee.total ?? 0,
                                flipped: true,
                                size: 14,
                              )),
                          SizedBox(
                            height: 24.h,
                          ),
                          _buidItem(
                            "Extra Charges",
                            "N/A",
                            widgetValue: MoneyWidget(
                              amount: 0,
                              flipped: true,
                              size: 14,
                            ),
                          ),
                          SizedBox(
                            height: 24.h,
                          ),
                          _buidItem(
                            "Discount",
                            "N/A",
                            widgetValue: MoneyWidget(
                              amount: 0,
                              flipped: true,
                              size: 14,
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    BoxShadowContainer(
                        child: Column(
                      children: [
                        _buidItem("TransactionID", widget.order.id),
                        SizedBox(
                          height: 24.h,
                        ),
                        _buidItem(
                          "Time",
                          "",
                          widgetValue: TimeDotWidget(
                            date: widget.order.date,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(
                          height: 24.h,
                        ),
                        _buidItem("Payment Type", "Wallet"),
                      ],
                    )),
                    SizedBox(
                      height: 16.h,
                    ),
                    BoxShadowContainer(
                      child: Column(
                        children: [
                          _buidItem(
                            "Delivery City",
                            "Lefke",
                          ),
                          SizedBox(
                            height: 24.h,
                          ),
                          _buidItem(
                            "Delivery Time",
                            "",
                            widgetValue: TimeDotWidget(
                              date: widget.order.deliveryDate,
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(
                            height: 24.h,
                          ),
                          if (widget.order.data.type == OrderType.cart)
                            _buidItem(
                              "Delivery Items",
                              "${widget.order.data.cartData!.products.map((e) => e.quantity).reduce((value, element) => value + element)}",
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                    DeliveryContactView(),
                    SizedBox(
                      height: 22.h,
                    ),

                    SubmitButton(
                      text: "Done",
                      onSubmit: () {
                        if (widget.fromCheckout) {
                          Get.offAll(() => const NavBarView());
                        } else {
                          Get.back();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buidItem(String title, String value, {Widget? widgetValue}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
          title,
          color: AppColors.veryLightGray,
          fontSize: 14.sp,
        ),
        (widgetValue != null)
            ? widgetValue
            : TextWidget(
                value,
                fontSize: 14.sp,
              )
      ],
    );
  }
}
