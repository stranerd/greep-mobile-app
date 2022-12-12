import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:greep/application/transactions/customer_statistics_cubit.dart';
import 'package:greep/application/transactions/transaction_crud_cubit.dart';
import 'package:greep/application/transactions/trip_direction_builder_cubit.dart';
import 'package:greep/commons/Utils/input_validator.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/scaffold_messenger_service.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/transaction/TransactionData.dart';
import 'package:greep/ioc.dart';
import 'package:greep/presentation/driver_section/nav_pages/nav_bar/nav_bar_view.dart';
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

  late TransactionCrudCubit _transactionCrudCubit;
  late TripDirectionBuilderCubit directionBuilderCubit;

  DateTime? recordDate;
  List<String> paymentTypes = [];
  List<String> customersNames = [];
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
              success = "Trip recorded successfully";
              Future.delayed(const Duration(milliseconds: 1500), () {
                Get.back();
              });
            }

            if (state is TransactionCrudStateFailure) {
              error = state.errorMessage;
            }
          },
          builder: (c, s) =>
              BlocBuilder<TripDirectionBuilderCubit, TripDirectionBuilderState>(
            builder: (context, directionState) {
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  leading: IconButton(
                    onPressed: () async {
                      if (directionState is TripDirectionBuilderStateEndTrip) {
                        bool shouldDelete = await showDialog<bool?>(
                                barrierDismissible: true,
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                      child: Container(
                                    padding:
                                        const EdgeInsets.all(kDefaultSpacing),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Are you sure you want to cancel your trip progress?",
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                          style: kDefaultTextStyle.copyWith(
                                              height: 1.35),
                                        ),
                                        kVerticalSpaceRegular,
                                        Flexible(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: TextButton(
                                                    style: TextButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        backgroundColor:
                                                            kPrimaryColor,
                                                        minimumSize:
                                                            Size(150, 50)),
                                                    onPressed: () {
                                                      Get.back(result: false);
                                                    },
                                                    child: Text(
                                                      "Go back",
                                                      style: kBoldTextStyle
                                                          .copyWith(
                                                              color:
                                                                  kWhiteColor),
                                                    )),
                                              ),
                                              kHorizontalSpaceSmall,
                                              Flexible(
                                                child: TextButton(
                                                  style: TextButton.styleFrom(
                                                      padding: EdgeInsets.zero,
                                                      backgroundColor:
                                                          AppColors.red,
                                                      minimumSize:
                                                          Size(150, 50)),
                                                  child: Text(
                                                    "Cancel",
                                                    style: kWhiteTextStyle,
                                                  ),
                                                  onPressed: () {
                                                    Get.back(result: true);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                                }) ??
                            false;

                        if (shouldDelete) {
                          directionBuilderCubit.cancelProgress();
                          Get.off(NavBarView());
                        }
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 16,
                    ),
                    color: AppColors.black,
                  ),
                  title: TextWidget(
                    directionState is TripDirectionBuilderStateEndTrip
                        ? "Record a custom trip"
                        : 'Record a trip',
                    style: AppTextStyles.blackSizeBold14,
                  ),
                  centerTitle: false,
                  elevation: 0.0,
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultSpacing),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            "Customer Name",
                            style: AppTextStyles.blackSize14,
                          ),
                          kVerticalSpaceSmall,
                          TypeAheadField(
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
                                  filled: true,
                                  fillColor: kBorderColor,
                                  focusedBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  enabledBorder: typeAheadError
                                      ? OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          borderSide: const BorderSide(
                                              color: kErrorColor, width: 0.5),
                                        )
                                      : InputBorder.none,
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
                          if (typeAheadError)
                            Row(
                              children: [
                                kHorizontalSpaceSmall,
                                TextWidget(
                                  "This cannot be empty",
                                  style: kErrorColorTextStyle.copyWith(
                                      fontSize: 13),
                                ),
                              ],
                            ),
                          kVerticalSpaceRegular,
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
                                    padding: const EdgeInsets.all(
                                        kDefaultSpacing * 0.5),
                                    height: Get.mediaQuery.orientation ==
                                            Orientation.landscape
                                        ? 120.h
                                        : 50.h,
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      color: kBorderColor,
                                      border: dateError
                                          ? Border.all(
                                              color: kErrorColor,
                                            )
                                          : null,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: TextWidget(
                                      recordDate == null
                                          ? "Select Date..."
                                          : DateFormat(
                                                  "${DateFormat.DAY}/${DateFormat.MONTH}/${DateFormat.YEAR}  hh:${DateFormat.MINUTE} a")
                                              .format(recordDate!),
                                      style: kDefaultTextStyle,
                                    ),
                                  ),
                                ),
                              ),
                              kHorizontalSpaceRegular,
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
                                  style: kErrorColorTextStyle.copyWith(
                                      fontSize: 13),
                                ),
                              ],
                            ),
                          kVerticalSpaceRegular,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget("Price",
                                        style: AppTextStyles.blackSize14),
                                    kVerticalSpaceSmall,
                                    LoginTextField(
                                      customController: _priceController,
                                      validator: emptyFieldValidator,
                                      onChanged: (String value) {
                                        _price = value;
                                        setState(() {});
                                      },
                                      withTitle: false,
                                      inputType: TextInputType.number,
                                    ),
                                  ],
                                ),
                              ),
                              kHorizontalSpaceRegular,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget("Paid",
                                        style: AppTextStyles.blackSize14),
                                    kVerticalSpaceSmall,
                                    LoginTextField(
                                      customController: _paidController,
                                      validator: emptyFieldValidator,
                                      onChanged: (String value) {
                                        _paid = value;
                                        setState(() {});
                                      },
                                      withTitle: false,
                                      inputType: TextInputType.number,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          kVerticalSpaceRegular,
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget("Discount",
                                        style: AppTextStyles.blackSize14),
                                    kVerticalSpaceSmall,
                                    LoginTextField(
                                      validator: (_) {},
                                      onChanged: (String value) {},
                                      withTitle: false,
                                    ),
                                  ],
                                ),
                              ),
                              kHorizontalSpaceRegular,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget("Payment Type",
                                        style: AppTextStyles.blackSize14),
                                    kVerticalSpaceSmall,
                                    FormInputBgWidget(
                                      child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                        isExpanded: true,
                                        items: paymentTypes.map((e) {
                                          return DropdownMenuItem<String>(
                                            value: e,
                                            child: TextWidget(
                                              e,
                                              style: kBoldTextStyle,
                                            ),
                                          );
                                        }).toList(),
                                        value: _paymentType,
                                        onChanged: (String? value) {
                                          if (value != null) {
                                            setState(() {
                                              _paymentType = value;
                                            });
                                          }
                                        },
                                      )),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          kVerticalSpaceRegular,
                          TextWidget(
                            "Trip Description",
                            style: AppTextStyles.blackSize14,
                          ),
                          kVerticalSpaceSmall,
                          LoginTextField(
                            minLines: 3,
                            validator: (_) {},
                            onChanged: (String v) {
                              _description = v;
                              setState(() {});
                            },
                            withTitle: false,
                          ),
                          kVerticalSpaceRegular,
                          SubmitButton(
                              backgroundColor: kGreenColor,
                              isLoading: s is TransactionCrudStateLoading,
                              enabled: s is! TransactionCrudStateLoading,
                              text: "Submit",
                              onSubmit: _recordTrip),
                          kVerticalSpaceRegular
                        ],
                      ),
                    ),
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
          dateRecorded: recordDate!);
    }
  }

  void _pickDate() {
    DatePicker.showDatePicker(context,
            maxTime: DateTime.now(), theme: DatePickerTheme())
        .then((value) {
      if (value == null) return;
      DateTime selectedDate = value;
      DatePicker.showTime12hPicker(
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
