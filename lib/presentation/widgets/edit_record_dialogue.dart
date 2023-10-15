import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:greep/Commons/colors.dart';
import 'package:greep/application/transactions/customer_statistics_cubit.dart';
import 'package:greep/application/transactions/transaction_crud_cubit.dart';
import 'package:greep/application/transactions/trip_direction_builder_cubit.dart';
import 'package:greep/commons/Utils/input_validator.dart';
import 'package:greep/commons/scaffold_messenger_service.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/transaction/TransactionData.dart';
import 'package:greep/domain/transaction/transaction.dart';
import 'package:greep/ioc.dart';
import 'package:greep/presentation/driver_section/transaction/transaction_details_screen.dart';
import 'package:greep/presentation/widgets/app_dialog.dart';
import 'package:greep/presentation/widgets/input_text_field.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';
import 'package:greep/utils/constants/app_styles.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dt;

class EditRecordDialogue extends StatefulWidget {
  final Transaction transaction;

  const EditRecordDialogue({Key? key, required this.transaction})
      : super(key: key);

  @override
  _EditRecordDialogueState createState() => _EditRecordDialogueState();
}

class _EditRecordDialogueState extends State<EditRecordDialogue>
    with ScaffoldMessengerService, InputValidator {
  String _customerName = "";
  String _price = "";
  String _paid = "";
  String _description = "";
  String _expenseName = "";
  bool dateError = false;
  bool typeAheadError = false;
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _paidController;
  late TextEditingController _descriptionController;
  late TransactionCrudCubit _transactionCrudCubit;
  late TripDirectionBuilderCubit directionBuilderCubit;

  DateTime? recordDate;
  List<String> paymentTypes = [];
  List<String> customersNames = [];
  final formKey = GlobalKey<FormState>();

  bool isExpense = false;


  @override
  void initState() {
    isExpense =
        widget.transaction.data.transactionType == TransactionType.expense;
    paymentTypes = PaymentType.values.map((e) => e.name).toList();
    directionBuilderCubit = getIt();
    _transactionCrudCubit = GetIt.I<TransactionCrudCubit>();

    customersNames = GetIt.I<CustomerStatisticsCubit>().getUserCustomers();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _paidController = TextEditingController();
    _descriptionController = TextEditingController();

    if (!isExpense){
    _paidController.text = widget.transaction.data.paidAmount?.toString() ?? "";
    _nameController.text = widget.transaction.data.customerName ??"";

    }
    else {
      _nameController.text = widget.transaction.data.name ??"";

    }
    _descriptionController.text = widget.transaction.description;
    _priceController.text = widget.transaction.amount.toString();
    recordDate = widget.transaction.timeAdded;


    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _paidController.dispose();
    _descriptionController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: "Edit ${!isExpense ? "trip" : "expense"}",
      height: isExpense ?0.6.sh : 0.75.sh,
      child: BlocProvider.value(
        value: _transactionCrudCubit,
        child: Builder(builder: (context) {
          return BlocConsumer<TransactionCrudCubit, TransactionCrudState>(
            listener: (context, state) {
              if (state is TransactionCrudStateSuccess) {
                success = state.isAdd
                    ? "Trip recorded successfully"
                    : "Expense recorded";
                Future.delayed(const Duration(milliseconds: 1500), () {
                  if (state.isAdd) {
                    Get.off(TransactionDetailsScreen(
                        transaction: state.transaction!));
                  } else {
                    Get.back();
                  }
                });
              }

              if (state is TransactionCrudStateFailure) {
                error = state.errorMessage;
              }
            },
            builder: (c, s) => BlocBuilder<TripDirectionBuilderCubit,
                TripDirectionBuilderState>(
              builder: (context, directionState) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isExpense)
                          Column(
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
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
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
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                              borderSide: BorderSide(
                                                  color: AppColors.gray2,
                                                  width: 2.w),
                                            ),
                                            isDense: true,
                                            hintText:
                                                "What is the name of the customer?",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                              borderSide: BorderSide(
                                                  color: AppColors.gray2,
                                                  width: 2.w),
                                            ),
                                            enabledBorder: typeAheadError
                                                ? OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.r),
                                                    borderSide: BorderSide(
                                                        color: kErrorColor,
                                                        width: 0.5.w),
                                                  )
                                                : OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.r),
                                                    borderSide: BorderSide(
                                                        color: AppColors.gray2,
                                                        width: 2.w),
                                                  ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              borderSide: const BorderSide(
                                                  color: kErrorColor,
                                                  width: 0.5),
                                            )),
                                      ),
                                      hideOnEmpty: true,
                                      hideOnError: true,
                                      hideOnLoading: true,
                                      suggestionsCallback: (pattern) async {
                                        if (pattern.isEmpty) {
                                          return [];
                                        }
                                        return customersNames.where((element) =>
                                            element.toLowerCase().startsWith(
                                                pattern.toLowerCase()));
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          title:
                                              TextWidget(suggestion.toString()),
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
                                    onTap: () {},
                                    child: Container(
                                      padding: EdgeInsets.all(12.5.r),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.r),
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
                                      style: kErrorColorTextStyle.copyWith(
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                            ],
                          ) else
                  InputTextField(
                  customController: _nameController,
                  validator: emptyFieldValidator,
                  onChanged: (String value) {
                    _expenseName = value;
                    setState(() {});
                  },
                  hintText:
                  "What is the name of this expense",
                  title: "Expense",
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
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 12.h),
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
                                    style: kDefaultTextStyle,
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
                          prefixIcon: "assets/icons/turkish2.svg",
                          customController: _priceController,
                          validator: emptyFieldValidator,
                          onChanged: (String value) {
                            _price = value;
                            setState(() {});
                          },
                          suffixSize: 25,
                          suffixIcon: "assets/icons/alert.svg",
                          hintText:
                              "What is the cost of this ${isExpense ? "expense" : "trip"}?",
                          title: "${isExpense ?"Cost" : "Price"} ",
                          inputType: TextInputType.number,
                        ),
                        SizedBox(height: 4.h,),
                        TextWidget(
                          "Administrative approval is needed before change reflects",
                          fontStyle: FontStyle.italic,
                          fontSize: 10.sp,
                        ),
                        kVerticalSpaceRegular,
                        if (!isExpense)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InputTextField(
                                customController: _paidController,
                                validator: emptyFieldValidator,
                                onChanged: (String value) {
                                  _paid = value;
                                  setState(() {});
                                },
                                suffixSize: 25,
                                prefixIcon: "assets/icons/turkish2.svg",
                                suffixIcon: "assets/icons/alert.svg",
                                hintText: "How much did the customer pay?",
                                title: "Paid",
                                inputType: TextInputType.number,
                              ),
                              SizedBox(height: 4.h,),
                              TextWidget(
                                "Administrative approval is needed before change reflects",
                                fontStyle: FontStyle.italic,
                                fontSize: 10.sp,
                              ),
                              kVerticalSpaceRegular,
                            ],
                          ),

                        InputTextField(
                          minLines: 4,
                          validator: (_) {},
                          customController: _descriptionController,
                          onChanged: (String v) {
                            _description = v;
                            setState(() {});
                          },
                          title: "Description",
                          hintText: "${isExpense ? "Expense": "Trip"} details",
                        ),
                        kVerticalSpaceRegular,
                        SubmitButton(
                          isLoading: s is TransactionCrudStateLoading,
                          enabled: s is! TransactionCrudStateLoading,
                          text: "Edit Record",
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
      ),
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
          paymentType: "cash",
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
