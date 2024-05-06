import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dt;

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:greep/application/transactions/customer_statistics_cubit.dart';
import 'package:greep/application/transactions/transaction_crud_cubit.dart';
import 'package:greep/application/transactions/trip_direction_builder_cubit.dart';
import 'package:greep/commons/Utils/input_validator.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/scaffold_messenger_service.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/customer/customer.dart';
import 'package:greep/domain/transaction/TransactionData.dart';
import 'package:greep/ioc.dart';
import 'package:greep/presentation/driver_section/customer/views/add_customer_dialog.dart';
import 'package:greep/presentation/driver_section/nav_pages/nav_bar/nav_bar_view.dart';
import 'package:greep/presentation/driver_section/transaction/transaction_details.dart';
import 'package:greep/presentation/driver_section/transaction/transaction_details_screen.dart';
import 'package:greep/presentation/widgets/action_status_dialog.dart';
import 'package:greep/presentation/widgets/form_input_bg_widget.dart';
import 'package:greep/presentation/widgets/input_text_field.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';
import 'package:greep/utils/constants/app_styles.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

class RecordTrip extends StatefulWidget {
  const RecordTrip({Key? key}) : super(key: key);

  @override
  State<RecordTrip> createState() => _RecordTripState();
}

class _RecordTripState extends State<RecordTrip>
    with ScaffoldMessengerService, InputValidator {
  String _customerName = "";
  String _price = "";
  String _paid = "";
  String _paymentType = "cash";
  String _description = "";
  bool dateError = false;
  bool typeAheadError = false;
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _paidController;
  Customer? selectedCustomer;

  late TransactionCrudCubit _transactionCrudCubit;
  late TripDirectionBuilderCubit directionBuilderCubit;

  DateTime? recordDate;
  List<String> paymentTypes = [];
  List<String> customersNames = [];
  bool isFromTrips = false;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    paymentTypes = PaymentType.values.map((e) => e.name).toList();
    directionBuilderCubit = getIt();
    _transactionCrudCubit = GetIt.I<TransactionCrudCubit>();
    if (directionBuilderCubit.state is TripDirectionBuilderStateEndTrip) {
      recordDate =
          (directionBuilderCubit.state as TripDirectionBuilderStateEndTrip)
              .directionProgress
              .date;
      isFromTrips = true;
    }
    customersNames = GetIt.I<CustomerStatisticsCubit>().getUserCustomers();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _paidController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _transactionCrudCubit,
      child: Builder(builder: (context) {
        return BlocConsumer<TransactionCrudCubit, TransactionCrudState>(
          listener: (context, state) {
            if (state is TransactionCrudStateSuccess) {
              // success = state.isAdd
              //     ? "Trip recorded successfully"
              //     : "Expense recorded";
              Future.delayed(const Duration(milliseconds: 1500), () {
                if (isFromTrips) {
                  directionBuilderCubit.cancelProgress(isCompleted: true);
                }
                if (state.isAdd) {
                  Get.back();
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const ActionStatusDialog(
                          text: "Trip recorded successfully",
                          tapText: "Got it",
                        );
                      });
                  // Get.off(TransactionDetailsScreen(transaction: state.transaction!));
                } else {
                  Get.back();
                }
              });
            }

            if (state is TransactionCrudStateFailure) {
              Get.back();
              showDialog(
                  context: context,
                  builder: (context) {
                    return ActionStatusDialog(
                      text: state.errorMessage,
                      tapText: "Go Back",
                      isSuccess: false,
                    );
                  });
            }
          },
          builder: (c, s) =>
              BlocBuilder<TripDirectionBuilderCubit, TripDirectionBuilderState>(
            builder: (context, directionState) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        "Customer",
                        style: AppTextStyles.blackSize14,
                      ),
                      kVerticalSpaceSmall,
                      Row(
                        children: [
                          Expanded(
                            child: TypeAheadField(
                              textFieldConfiguration: TextFieldConfiguration(
                                autofocus: false,
                                controller: _nameController,
                                onChanged: (s) {
                                  setState(() {
                                    typeAheadError = false;
                                    _customerName = s;
                                  });
                                },
                                style: kDefaultTextStyle,
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                      borderSide: BorderSide(
                                          color: AppColors.gray2, width: 2.w),
                                    ),
                                    isDense: true,
                                    hintText:
                                        "What is the name of the customer?",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                      borderSide: BorderSide(
                                          color: AppColors.gray2, width: 2.w),
                                    ),
                                    enabledBorder: typeAheadError
                                        ? OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                            borderSide: BorderSide(
                                                color: kErrorColor,
                                                width: 0.5.w),
                                          )
                                        : OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                            borderSide: BorderSide(
                                                color: AppColors.gray2,
                                                width: 2.w),
                                          ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                      borderSide: const BorderSide(
                                          color: kErrorColor, width: 0.5),
                                    )),
                              ),
                              hideOnEmpty: true,
                              hideOnError: true,
                              hideOnLoading: true,
                              suggestionsCallback: (pattern) async {
                                if (pattern.isEmpty) {
                                  return [];
                                }
                                return customersNames.where((element) => element
                                    .toLowerCase()
                                    .startsWith(pattern.toLowerCase()));
                              },
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  title: TextWidget(suggestion.toString()),
                                );
                              },
                              onSuggestionSelected: (suggestion) {
                                _customerName = suggestion.toString();
                                _nameController.text = _customerName;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 12.w,
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                  context: context, builder: (context) {

                                  return AddCustomerDialog(onSelected:(customer){
                                    setState(() {
                                      selectedCustomer = customer;
                                      _nameController.text = customer.name;
                                    });
                                  });
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(12.5.r),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                color: AppColors.black,
                              ),
                              child: SvgPicture.asset(
                                "assets/icons/customers.svg",
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (typeAheadError)
                        Row(
                          children: [
                            kHorizontalSpaceSmall,
                            TextWidget(
                              "This cannot be empty",
                              style:
                                  kErrorColorTextStyle.copyWith(fontSize: 13),
                            ),
                          ],
                        ),
                      kVerticalSpaceRegular,
                      TextWidget(
                        "Date/Time",
                        style: AppTextStyles.blackSize14,
                      ),
                      kVerticalSpaceSmall,
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                dateError = false;
                                _pickDate();
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.all(kDefaultSpacing * 0.5),
                                height: Get.mediaQuery.orientation ==
                                        Orientation.landscape
                                    ? 120.h
                                    : 50.h,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: dateError
                                          ? kErrorColor
                                          : AppColors.gray2,
                                      width: 2.w),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: TextWidget(
                                  recordDate == null
                                      ? "Select Date..."
                                      : DateFormat(
                                              "${DateFormat.DAY}/${DateFormat.MONTH}/${DateFormat.YEAR}  hh:${DateFormat.MINUTE} a")
                                          .format(recordDate!),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 12.w,
                          ),
                          GestureDetector(
                            onTap: () {
                              dateError = false;
                              setState(() {
                                recordDate = DateTime.now();
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(
                                16.w,
                                13.h,
                                16.w,
                                13.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: AppColors.black,
                              ),
                              child: TextWidget(
                                "Now",
                                style: AppTextStyles.whiteSize14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (dateError)
                        Row(
                          children: [
                            kHorizontalSpaceSmall,
                            TextWidget(
                              "Date cannot be empty",
                              style:
                                  kErrorColorTextStyle.copyWith(fontSize: 13),
                            ),
                          ],
                        ),
                      kVerticalSpaceRegular,
                      InputTextField(
                        customController: _priceController,
                        validator: emptyFieldValidator,

                        onChanged: (String value) {
                          _price = value;
                          setState(() {});
                        },
                        hintText: "What is the cost of this trip?",
                        inputType: TextInputType.number,
                        title: "Price",
                      ),
                      kVerticalSpaceRegular,
                      InputTextField(
                        customController: _paidController,
                        validator: emptyFieldValidator,
                        onChanged: (String value) {
                          _paid = value;
                          setState(() {});
                        },
                        hintText: "How much did the customer pay?",
                        inputType: TextInputType.number,
                        title: "Paid",
                      ),
                      kVerticalSpaceRegular,
                      InputTextField(
                        minLines: 4,
                        validator: (_) {},
                        onChanged: (String v) {
                          _description = v;
                          setState(() {});
                        },
                        title: "Description",
                        hintText: "Trip details",
                      ),
                      kVerticalSpaceRegular,
                      SubmitButton(
                        isLoading: s is TransactionCrudStateLoading,
                        enabled: s is! TransactionCrudStateLoading,
                        text: "Record",
                        onSubmit: _recordTrip,
                      ),
                      kVerticalSpaceRegular
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _recordTrip() {
    formKey.currentState!.validate();
    if (recordDate == null) {
      setState(() {
        dateError = true;
      });
    }
    if (_customerName.trim().isEmpty) {
      setState(() {
        typeAheadError = true;
      });
    }

    if (typeAheadError || dateError) {
      return;
    }
    if (formKey.currentState!.validate()) {
      _transactionCrudCubit.addTrip(
          customerName: _customerName,
          paidAmount: num.parse(_paid),
          amount: num.parse(_price),
          paymentType: _paymentType,
          description: _description,
          trip: directionBuilderCubit.state is TripDirectionBuilderStateEndTrip
              ? (directionBuilderCubit.state
                      as TripDirectionBuilderStateEndTrip)
                  .directions
              : null,
          dateRecorded: recordDate!);
    }
  }

  void _pickDate() {
    dt.DatePicker.showDatePicker(context,
            maxTime: DateTime.now(), theme: const dt.DatePickerTheme())
        .then((value) {
      if (value == null) return;
      DateTime selectedDate = value;
      dt.DatePicker.showTime12hPicker(
        context,
      ).then((value) {
        if (value == null) {
          return;
        }
        setState(() {
          recordDate = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            value.hour,
            value.minute,
          );
        });
      });
    });
    // showDatePicker(
    //         context: context,
    //         initialDate: DateTime.now(),
    //         firstDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
    //         lastDate: DateTime.now().add(const Duration(days: 365 * 2)))
    //     .then((value) {
    //   if (value == null) return;
    //   DateTime selectedDate = value;
    //   showTimePicker(context: context, initialTime: TimeOfDay.now())
    //       .then((value) {
    //     TimeOfDay timeOfDay = value ?? TimeOfDay.now();
    //     selectedDate = DateTime(
    //       selectedDate.year,
    //       selectedDate.month,
    //       selectedDate.day,
    //       timeOfDay.hour,
    //       timeOfDay.minute,
    //     );
    //     setState(() {
    //       recordDate = selectedDate;
    //     });
    //   });
    // });
  }
}
