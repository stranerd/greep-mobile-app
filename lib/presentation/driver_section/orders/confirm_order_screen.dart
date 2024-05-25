import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:greep/application/order/order_crud_cubit.dart';
import 'package:greep/application/order/request/complete_order_request.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/order/order.dart';
import 'package:greep/ioc.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/in_app_notification_widget.dart';
import 'package:greep/presentation/widgets/number_dialer.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ConfirmOrderScreen extends StatefulWidget {
  final UserOrder order;

  const ConfirmOrderScreen({Key? key, required this.order}) : super(key: key);

  @override
  _ConfirmOrderScreenState createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  late OrderCrudCubit orderCrudCubit;
  String pin = "";
  TextEditingController codeController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    codeController.dispose();
  }

  @override
  void initState() {
    super.initState();
    orderCrudCubit = getIt();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: orderCrudCubit,
      child: BlocConsumer<OrderCrudCubit, OrderCrudState>(
        listener: (context, state) {
          if (state is OrderCrudStateError) {
            showInAppNotification(
              context,
              title: "Confirm Order",
              body: state.errorMessage ?? "",
              isSuccess: false,
            );
          }
          if (state is OrderCrudStateCompleteOrder) {
            Get.back();
            showInAppNotification(
              context,
              title: "Confirm Order",
              body: "Order successfully confirmed",
            );

          }
        },
        builder: (context, crudState) {
          return Scaffold(
            appBar: AppBar(
              title: TextWidget(
                "Confirm Order",
                weight: FontWeight.bold,
                fontSize: 18.sp,
              ),
              leading: Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: BackIcon(
                  isArrow: true,
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                          ),
                          child: const TextWidget(
                            "Kindly obtain the PIN from the customer to confirm your order.",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        PinCodeTextField(
                          onChanged: (String value) {
                            if (value.length < 4) {
                              setState(() {});
                            }
                          },
                          readOnly: true,
                          length: 4,
                          textStyle: kPrimaryTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 28.sp,
                          ),
                          controller: codeController,
                          pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(
                                12.r,
                              ),
                              fieldHeight: 50.r,
                              fieldWidth: 50.r,
                              // inactiveFillColor: AppColors.black,
                              inactiveColor: AppColors.gray2,
                              activeColor: AppColors.gray2,
                              selectedColor: AppColors.black),
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          onCompleted: (str) async {},
                          appContext: context,
                        ),
                        SizedBox(
                          height: 40.h,
                        ),
                        NumberDialer(
                          onClear: () {
                            if (codeController.text.isNotEmpty) {
                              codeController.text =
                                  "${codeController.text.substring(0, codeController.text.length - 1)}";
                              setState(() {});
                            }
                          },
                          onSelect: (a) {
                            print("on select $a");
                            if (codeController.text.length < 4) {
                              codeController.text = "${codeController.text}$a";
                              setState(() {});
                            }
                          },
                          onValue: (s) {},
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        SubmitButton(
                          text: "Confirm",
                          isLoading: crudState is OrderCrudStateLoading,
                          enabled: codeController.text.length == 4 && crudState is! OrderCrudStateLoading,
                          onSubmit: () {
                            orderCrudCubit.completeDelivery(
                              request: CompleteOrderRequest(
                                orderId: widget.order.id,
                                token: codeController.text,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
