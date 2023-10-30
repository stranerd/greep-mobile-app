import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:greep/application/customers/user_customers_cubit.dart';
import 'package:greep/domain/customer/customer.dart';
import 'package:greep/ioc.dart';
import 'package:greep/presentation/driver_section/widgets/empty_result_widget.dart';
import 'package:greep/presentation/widgets/app_dialog.dart';
import 'package:greep/presentation/widgets/input_text_field.dart';
import 'package:greep/presentation/widgets/profile_photo_widget.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class AddCustomerDialog extends StatefulWidget {
  const AddCustomerDialog({Key? key, required this.onSelected})
      : super(key: key);
  final Function(Customer) onSelected;

  @override
  _AddCustomerDialogState createState() => _AddCustomerDialogState();
}

class _AddCustomerDialogState extends State<AddCustomerDialog> {
  String search = "";

  late UserCustomersCubit userCustomersCubit;

  Customer? selectedCustomer;

  @override
  void initState() {
    super.initState();
    userCustomersCubit = getIt();
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: "Add a customer",
      height: 0.8.sh,
      child: BlocBuilder<UserCustomersCubit, UserCustomersState>(
        builder: (context, customerState) {
          return Container(
            decoration: BoxDecoration(
            ),
            child: Column(
              children: [
                InputTextField(
                  withTitle: false,
                  validator: (_) {},
                  isSearch: true,
                  hintText: "Search",
                  onChanged: (s) {
                    setState(
                      () {
                        search = s;
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 16.h,
                ),
                Expanded(
                  child: Builder(builder: (context) {
                    if (customerState is UserCustomersStateFetched) {
                      if (customerState.customers.isEmpty) {
                        return const EmptyResultWidget(text: "No Customers");
                      }
                      customerState.customers.sort((a,b) => a.name.compareTo(b.name));

                      return ListView.separated(
                        itemBuilder: (context, index) {
                          Customer customer = customerState.customers[index];
                          return ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            title: TextWidget(
                              customer.name,
                              fontSize: 14.sp,
                              weight: FontWeight.bold,
                            ),
                            subtitle: TextWidget(
                              "#${customer.id}",
                              fontSize: 12.sp,
                              color: AppColors.veryLightGray,
                            ),
                            leading: ProfilePhotoWidget(
                              radius: 24,
                              url: "",
                              initials: customer.name,
                            ),
                            trailing: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCustomer = customer;
                                });
                              },
                              child: SizedBox(
                                width: 24.r,
                                height: 24.r,
                                child: SvgPicture.asset(
                                  "assets/icons/radio-${selectedCustomer == customer ? "on" : "off"}.svg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (c, i) => SizedBox(
                          height: 24.h,
                        ),
                        itemCount: customerState.customers.length,
                      );
                    }
                    return const EmptyResultWidget(text: "No Customers");
                  }),
                ),
                SizedBox(
                  height: 16.h,
                ),
                SubmitButton(
                  text: "Confirm",
                  onSubmit: () {
                    if (selectedCustomer != null) {
                      Get.back();
                      widget.onSelected(selectedCustomer!);
                    }
                  },
                  enabled: selectedCustomer != null,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
