import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/transactions/transaction_crud_cubit.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/scaffold_messenger_service.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/domain/transaction/TransactionData.dart';
import 'package:grip/presentation/widgets/form_input_bg_widget.dart';
import 'package:grip/presentation/widgets/input_text_field.dart';
import 'package:grip/presentation/widgets/submit_button.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_styles.dart';
import '../../../utils/constants/text_field.dart';

class RecordTrip extends StatefulWidget {
  const RecordTrip({Key? key}) : super(key: key);

  @override
  State<RecordTrip> createState() => _RecordTripState();
}

class _RecordTripState extends State<RecordTrip> with ScaffoldMessengerService{
   String _customerName = "";
   String _price = "";
   String _paid = "";
   String _paymentType = "cash";
   String _description = "";
   late TextEditingController _nameController;
   late TextEditingController _priceController;
   late TextEditingController _paidController;
   
   late TransactionCrudCubit _transactionCrudCubit;

   DateTime? recordDate;
  List<String> paymentTypes = [];
   final formKey = GlobalKey<FormState>();

  int _destinationCount = 1;

  @override
  void initState() {
    paymentTypes = PaymentType.values.map((e) => e.name).toList();
    _transactionCrudCubit = GetIt.I<TransactionCrudCubit>();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _paidController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
value: _transactionCrudCubit,
  child: Builder(
    builder: (context) {
      return BlocConsumer<TransactionCrudCubit, TransactionCrudState>(
  listener: (context, state) {
    if (state is TransactionCrudStateSuccess){
      success = "Trip recorded successfully";
      Future.delayed(const Duration(milliseconds: 1500), (){
        Get.back();
      });
    }
  },
  builder: (c,s) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 16,
                ),
                color: AppColors.black),
            title: Text(
              'Record a trip',
              style: AppTextStyles.blackSizeBold14,
            ),
            centerTitle: false,
            elevation: 0.0,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultSpacing),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Customer Name",
                      style: AppTextStyles.blackSize14,
                    ),
                    kVerticalSpaceSmall,
                    LoginTextField(
                      customController: _nameController,
                      validator: (_) {},
                      onChanged: (String v) {
                        setState(() {
                          _customerName = v;
                        });
                      },
                      withTitle: false,
                    ),
                    kVerticalSpaceRegular,
                    Text(
                      "Date/Time",
                      style: AppTextStyles.blackSize14,
                    ),
                    kVerticalSpaceSmall,
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _pickDate();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(kDefaultSpacing * 0.5),
                              height: 50,
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: kBorderColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
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
                        const SizedBox(
                          width: 16.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              recordDate = DateTime.now();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: AppColors.black,
                            ),
                            child: Text(
                              "Now",
                              style: AppTextStyles.whiteSize14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      "Destination Count",
                      style: AppTextStyles.blackSize14,
                    ),
                    kVerticalSpaceSmall,
                    FormInputBgWidget(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_destinationCount > 1) {
                              _destinationCount--;
                              setState(() {

                              });
                            }
                          },
                          child: Container(
                            width: 50,
                            padding: const EdgeInsets.all(kDefaultSpacing * 0.3),
                            decoration: const BoxDecoration(

                            ),
                            child: Text(
                              "-",
                              style: kBoldTextStyle.copyWith(fontSize: 20),
                            ),
                          ),
                        ),
                        Text(
                          _destinationCount.toString(),
                          style: kBoldTextStyle.copyWith(fontSize: 20),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_destinationCount < 10) {
                              _destinationCount++;
                              setState(() {

                              });
                            }
                          },
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.all(kDefaultSpacing * 0.3),
                            decoration: BoxDecoration(

                            ),
                            child: Text(
                              "+",
                              style: kBoldTextStyle.copyWith(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    )),
                    SizedBox(
                      height: 16.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Price", style: AppTextStyles.blackSize14),
                              kVerticalSpaceSmall,
                              LoginTextField(
                                customController: _priceController,

                                validator: (_){}, onChanged: (String value){
                                _price = value;
                                setState(() {

                                });
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
                              Text("Paid", style: AppTextStyles.blackSize14),
                              kVerticalSpaceSmall,
                              LoginTextField(
                                customController: _paidController,

                                validator: (_){}, onChanged: (String value){
                                num paid = num.tryParse(value) ?? 0;
                                num price = num.tryParse(_price) ?? 0;
                                if ( paid > price) {
                                  _paidController.text = _price;
                                }
                                else {

                                  _paid = value;
                                }
                                setState(() {

                                });
                              },
                                withTitle: false,
                                inputType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Discount", style: AppTextStyles.blackSize14),
                              kVerticalSpaceSmall,
                              LoginTextField(validator: (_){}, onChanged: (String value){

                              },
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
                              Text("Payment Type", style: AppTextStyles.blackSize14),
                              kVerticalSpaceSmall,
                              FormInputBgWidget(
                                child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                  items: paymentTypes.map((e) {
                                    return DropdownMenuItem<String>(child: Text(e, style: kBoldTextStyle,),value: e,);
                                  }).toList(),
                                      value: _paymentType,
                                      onChanged: (String? value) {
                                    if (value!=null) {
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
                    const SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      "Trip Description",
                      style: AppTextStyles.blackSize14,
                    ),
                    kVerticalSpaceSmall,

                    LoginTextField(
                        minLines: 3,
                        validator: (_){}, onChanged: (String v){
                      _description = v;
                      setState(() {

                      });
                    },
                      withTitle: false,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    SubmitButton(
                        isLoading: s is TransactionCrudStateLoading,
                        enabled: s is! TransactionCrudStateLoading,
                        text: "Submit", onSubmit: _recordTrip)
                  ],
                ),
              ),
            ),
          ),
        ),
);
    }
  ),
);
  }

  void _recordTrip() {
    if (formKey.currentState!.validate()){

    _transactionCrudCubit.addTrip(customerName: _customerName, paidAmount: num.parse(_paid), amount: num.parse(_price), paymentType: _paymentType, description: _description, dateRecorded: recordDate!);
    }
  }

  void _pickDate() {
    // DatePicker.showDateTimePicker(context,
    //   theme: DatePickerTheme()
    //
    // ).then((value) {
    //   if (value == null) return;
    //   setState(() {
    //     recordDate = value;
    //   });
    // });
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
            lastDate: DateTime.now().add(const Duration(days: 365 * 2)))
        .then((value) {
      if (value == null) return;
      DateTime selectedDate = value;
      showTimePicker(context: context, initialTime: TimeOfDay.now())
          .then((value) {
        TimeOfDay timeOfDay = value ?? TimeOfDay.now();
        selectedDate = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          timeOfDay.hour,
          timeOfDay.minute,
        );
        setState(() {
          recordDate = selectedDate;
        });
      });
    });
  }
}
