import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:greep/Commons/colors.dart';
import 'package:greep/application/order/order_crud_cubit.dart';
import 'package:greep/application/order/request/assign_order_request.dart';
import 'package:greep/application/order/single_order_cubit.dart';
import 'package:greep/application/order/single_order_state.dart';
import 'package:greep/application/product/product_list_cubit.dart';
import 'package:greep/commons/Utils/utils.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/cart/cart.dart';
import 'package:greep/domain/order/order.dart';
import 'package:greep/ioc.dart';
import 'package:greep/presentation/driver_section/orders/confirm_order_screen.dart';
import 'package:greep/presentation/driver_section/orders/views/delivery_contact_view.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/confirmation_dialog.dart';
import 'package:greep/presentation/widgets/custom_stepper_widget.dart';
import 'package:greep/presentation/widgets/dot_circle.dart';
import 'package:greep/presentation/widgets/in_app_notification_widget.dart';
import 'package:greep/presentation/widgets/key_value_widget.dart';
import 'package:greep/presentation/widgets/loading_widget.dart';
import 'package:greep/presentation/widgets/money_widget.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';
import 'package:intl/intl.dart';

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({Key? key, required this.order}) : super(key: key);

  final UserOrder order;

  @override
  _TrackOrderScreenState createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  late ProductListCubit productListCubit;
  late SingleOrderCubit singleOrderCubit;
  late OrderCrudCubit orderCrudCubit;
  late UserOrder order;

  @override
  void initState() {
    super.initState();
    order = widget.order;
    productListCubit = getIt();
    singleOrderCubit = getIt()..fetchSingleOrder(requestId: order.id,);
    orderCrudCubit = getIt();
    if (order.data.type == OrderType.cart) {
      productListCubit.fetchProductsById(
          productIds: order.data.cartData!.products.map((e) => e.id).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: productListCubit,
        ),
        BlocProvider.value(
          value: orderCrudCubit,
        ),
        BlocProvider.value(
          value: singleOrderCubit,
        ),
      ],
      child: BlocListener<SingleOrderCubit, SingleOrderState>(
  listener: (context, singleOrderState) {
    print(singleOrderState);
    if (singleOrderState is SingleOrderStateFetched){
      setState(() {
        order = singleOrderState.order;
      });
    }
  },
  child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.darkGreen,
          leading: const BackIcon(
            isArrow: true,
            color: AppColors.white,
          ),
          actions: [
            SvgPicture.asset(
              "assets/icons/more_vert.svg",
            )
          ],
          title: TextWidget(
            "Track Order",
            weight: FontWeight.bold,
            fontSize: 18.sp,
            color: AppColors.white,
          ),
          leadingWidth: 50.w,
          centerTitle: false,
        ),
        body: BlocConsumer<OrderCrudCubit, OrderCrudState>(
          listener: (context, state) {
            print(state);
            if (state is OrderCrudStateError) {
              showInAppNotification(
                context,
                title: "Message",
                body: state.errorMessage!,
                isSuccess: false,
              );
            }
            if (state is OrderCrudStateMarkPaid){
              showInAppNotification(context, title: "Order Payment", body: "Order successfully marked as paid");
            }
            if (state is OrderCrudStateAssignedDriver) {
              showInAppNotification(
                context,
                title: "Accept Order",
                body:
                    "You have successfully accepted this order. Kindly wait for the vendor to approve shipping",
              );
              setState(() {
                order = state.response;
              });

            }
            if (state is OrderCrudStateCompleteOrder) {
              showInAppNotification(
                context,
                title: "Complete Order",
                body: "Bravo!!! You have successfully completed this order.",
              );
            }
            singleOrderCubit.fetchSingleOrder(requestId: order.id,);
          },
          builder: (context, crudState) {
            return BlocBuilder<ProductListCubit, ProductListState>(
              builder: (context, listState) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    vertical: 20.h,
                    horizontal: 16.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            "Order List",
                            fontSize: 16.sp,
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          if (order.data.type == OrderType.cart)
                            listState is! ProductListStateFetched
                                ? SizedBox(
                                    height: 40.r,
                                    width: 40.r,
                                    child: LoadingWidget(
                                      size: 40.r,
                                    ),
                                  )
                                : ListView.separated(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      CartItem item = widget
                                          .order.data.cartData!.products[index];
                                      var product = listState.products
                                          .firstWhereOrNull(
                                              (e) => e.id == item.id);
                                      return KeyValueWidget(
                                        title: "- ${product?.title ?? ""}",
                                        titleColor: AppColors.veryLightGray,
                                        value: "",
                                        widgetValue: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            MoneyWidget(
                                                amount:
                                                    product?.price.amount ?? 0),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            TextWidget(
                                              "(x${item.quantity})",
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (_, __) => SizedBox(
                                      height: 10.h,
                                    ),
                                    itemCount: widget
                                        .order.data.cartData!.products.length,
                                  ),
                          if (order.data.type == OrderType.dispatch)
                            ListView(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                KeyValueWidget(
                                  title: "Delivery Type",
                                  titleColor: AppColors.veryLightGray,
                                  fontSize: 12.sp,
                                  value: order.data.dispatchData!.deliveryType
                                      .name.capitalizeFirst!,
                                ),
                                SizedBox(
                                  height: 12.h,
                                ),
                                KeyValueWidget(
                                  title: "Delivery Size",
                                  titleColor: AppColors.veryLightGray,
                                  fontSize: 12.sp,
                                  value: "${order.data.dispatchData!.size}(kg)",
                                ),
                                SizedBox(
                                  height: 12.h,
                                ),
                                KeyValueWidget(
                                  title: "Description",
                                  titleColor: AppColors.veryLightGray,
                                  fontSize: 12.sp,
                                  value: widget
                                      .order.data.dispatchData!.description,
                                ),
                              ],
                            )
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      const Divider(
                        color: AppColors.lightGray2,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            "Order Details",
                            weight: FontWeight.w500,
                            fontSize: 16.sp,
                          ),
                          SizedBox(
                            height: 11.h,
                          ),
                          KeyValueWidget(
                            title: "Tracking ID",
                            value: "#${order.id}",
                            titleColor: AppColors.veryLightGray,
                            fontSize: 12.sp,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          KeyValueWidget(
                            title: "Payment",
                            value: order.payment,
                            titleColor: AppColors.veryLightGray,
                            fontSize: 12.sp,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          KeyValueWidget(
                            title: "Order date",
                            value:
                                " ${DateFormat("dd MMM yyyy, hh:mm a").format(order.date)}",
                            titleColor: AppColors.veryLightGray,
                            fontSize: 12.sp,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          KeyValueWidget(
                            title: "Delivery Location",
                            value:
                                " ${DateFormat("dd MMM yyyy, hh:mm a").format(order.date)}",
                            titleColor: AppColors.veryLightGray,
                            widgetValue: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 10.h,
                                ),
                                TextWidget(order.deliveryLocation?.name ?? ""),
                                SizedBox(
                                  height: 5.h,
                                ),
                                TextWidget(
                                  order.deliveryLocation?.location.address ??
                                      "",
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                if (order.deliveryLocation != null)
                                  SubmitButton(
                                    text: "See this Location",
                                    onSubmit: () {
                                      Utils.openMapsApp(
                                          order.deliveryLocation!.location);
                                    },
                                    width: 150.w,
                                    height: 35.h,
                                    padding: 8,
                                  ),
                              ],
                            ),
                            fontSize: 12.sp,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      const Divider(
                        color: AppColors.lightGray2,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            "Order Status",
                            fontSize: 16.sp,
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          CustomStepperWidget(steps: [
                            StepperChild(
                              title: "Order Placed",
                              subTitle: DateFormat("dd MMM yyyy, hh:mm a")
                                  .format(
                                      order.status.created ?? DateTime.now()),
                              icon: SvgPicture.asset(
                                "assets/icons/note.svg",
                                color: kPrimaryColor,
                              ),
                              isFirst: true,
                              isLast: false,
                              isSuccess: true,
                            ),
                            StepperChild(
                              title: "Order Accepted",
                              subTitle: order.isAccepted
                                  ? DateFormat("dd MMM yyyy, hh:mm a").format(
                                      order.status.accepted ?? DateTime.now())
                                  : "pending",
                              icon: SvgPicture.asset(
                                "assets/icons/box.svg",
                                color: kPrimaryColor,
                              ),
                              isFirst: false,
                              isLast: false,
                              isSuccess: order.isAccepted,
                            ),
                            StepperChild(
                              title: "Driver Assigned",
                              subTitle: order.isDriverAssigned
                                  ? DateFormat("dd MMM yyyy, hh:mm a").format(
                                      order.status.driverAssigned ??
                                          DateTime.now())
                                  : "pending",
                              icon: SvgPicture.asset(
                                "assets/icons/box.svg",
                                color: kPrimaryColor,
                              ),
                              isFirst: false,
                              isLast: false,
                              isSuccess: order.isDriverAssigned,
                            ),
                            if (order.data.type == OrderType.cart)
                              StepperChild(
                                title: "Order Shipped",
                                subTitle: order.isShipped
                                    ? DateFormat("dd MMM yyyy, hh:mm a").format(
                                        order.status.shipped ?? DateTime.now())
                                    : "pending",
                                icon: SvgPicture.asset(
                                  "assets/icons/truck.svg",
                                  color: kPrimaryColor,
                                ),
                                isFirst: false,
                                isLast: false,
                                isSuccess: order.isShipped,
                              ),
                            if (!order.isPaid)
                              StepperChild(
                                title: "Order Paid",
                                subTitle: order.isPaid
                                    ? DateFormat("dd MMM yyyy, hh:mm a").format(
                                        order.status.paid ?? DateTime.now())
                                    : "pending",
                                icon: SvgPicture.asset(
                                  "assets/icons/box.svg",
                                  color: kPrimaryColor,
                                ),
                                isFirst: false,
                                isLast: false,
                                isSuccess: order.isPaid,
                              ),
                            StepperChild(
                              title: "Order Completed",
                              subTitle: !order.isCompleted
                                  ? "pending"
                                  : DateFormat("dd MMM yyyy, hh:mm a").format(
                                      order.status.completed ?? DateTime.now(),
                                    ),
                              icon: SvgPicture.asset(
                                "assets/icons/box.svg",
                                color: kPrimaryColor,
                              ),
                              isFirst: false,
                              isLast: true,
                              isSuccess: order.isCompleted,
                            ),
                          ]),
                          // CustomStepperWidget(
                          //   steps:
                          //       List.generate(order.timeline.length, (index) {
                          //     OrderTimeline e = order.timeline[index];
                          //     String status = e.status;
                          //     return StepperChild(
                          //       title: e.title,
                          //       subTitle: e.date == null
                          //           ? "pending"
                          //           : DateFormat("dd MMM yyyy, hh:mm a")
                          //               .format(e.date ?? DateTime.now()),
                          //       icon: SvgPicture.asset(
                          //         "assets/icons/${status == "created" ? "note" : status == "shipped" ? "truck" : status == "accepted" ? "box" : "box"}.svg",
                          //         color: kPrimaryColor,
                          //       ),
                          //       isFirst: index == 0,
                          //       isLast: index == order.timeline.length - 1,
                          //       isSuccess: e.done,
                          //     );
                          //   }),
                          // )
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      DeliveryContactView(),
                      SizedBox(
                        height: 20.h,
                      ),
                      if (order.isAccepted && !order.isDriverAssigned)
                        Column(
                          children: [
                            SubmitButton(
                              text: "Accept Order",
                              isLoading: crudState is OrderCrudStateLoading &&
                                  crudState.isAccept,
                              enabled: crudState is! OrderCrudStateLoading,
                              onSubmit: () async {
                                var result = await showDialog<bool?>(
                                  context: context,
                                  builder: (c) => ConfirmationDialog(
                                    content: TextWidget(
                                        "Are you sure you want to accept this order?"),
                                    yesText: "Yes",
                                    icon: TextWidget(
                                      "Accept Order?",
                                      weight: FontWeight.bold,
                                      fontSize: 18.sp,
                                    ),
                                    noText: "No",
                                    noColor: AppColors.red,
                                  ),
                                );
                                if (result ?? false) {
                                  orderCrudCubit.assignDriver(
                                      request: AssignOrderRequest(
                                    orderId: order.id,
                                  ));
                                } else {}
                              },
                            ),
                          ],
                        ),
                      if (!order.isPaid)
                        Column(
                          children: [
                            SubmitButton(
                              isLoading: crudState is OrderCrudStateLoading && !order.isPaid,
                              text: "Confirm Order Payment",
                              onSubmit: () async {
                                var result = await showDialog<bool?>(
                                  context: context,
                                  builder: (c) => ConfirmationDialog(
                                    content: TextWidget(
                                        "By clicking Yes, you are confirming that you have received payment for this order?"),
                                    yesText: "Yes",
                                    icon: TextWidget(
                                      "Confirm Order Payment",
                                      weight: FontWeight.bold,
                                      fontSize: 18.sp,
                                    ),
                                    noText: "No",
                                    noColor: AppColors.red,
                                  ),
                                );
                                if (result ?? false) {
                                  orderCrudCubit.markOrderPaid(
                                    order.id,
                                  );
                                } else {}
                              },
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                          ],
                        ),
                      if ((order.data.type == OrderType.cart &&
                              order.isShipped &&
                              !order.isCompleted) ||
                          order.data.type == OrderType.dispatch &&
                              order.isDriverAssigned &&
                              !order.isCompleted)
                        SubmitButton(
                          text: "Confirm Order",
                          enabled: order.isPaid,
                          onSubmit: () async {
                            var result = await Get.to(() => ConfirmOrderScreen(
                                  order: order,
                                ));
                            singleOrderCubit.fetchSingleOrder(requestId: order.id);
                          },
                        ),
                      SizedBox(
                        height: 100.h,
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
),
    );
  }
}
