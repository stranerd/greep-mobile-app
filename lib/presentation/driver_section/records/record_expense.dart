import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:greep/application/transactions/transaction_crud_cubit.dart';
import 'package:greep/application/transactions/transaction_summary_cubit.dart';
import 'package:greep/commons/Utils/input_validator.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/scaffold_messenger_service.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/widgets/input_text_field.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_styles.dart';
import '../../../utils/constants/text_field.dart';

class RecordExpense extends StatefulWidget {
  const RecordExpense({Key? key}) : super(key: key);

  @override
  State<RecordExpense> createState() => _RecordExpenseState();
}

class _RecordExpenseState extends State<RecordExpense> with ScaffoldMessengerService, InputValidator{
  String _expenseName = "";
  String _price = "";
  String _description = "";
  List<String> expenseList = [];
  bool typeAheadError = false;
  bool dateError = false;

  late TextEditingController _expenseNameController;
  late TransactionCrudCubit _transactionCrudCubit;

  DateTime? recordDate;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    expenseList =
        GetIt.I<TransactionSummaryCubit>().expensesList();
    _expenseNameController = TextEditingController();
    _transactionCrudCubit = GetIt.I<TransactionCrudCubit>();


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
      success = "Expense recorded successfully";
      Future.delayed(const Duration(milliseconds: 1500), (){
        Get.back();
      });
  }
    if (state is TransactionCrudStateFailure){
      error = state.errorMessage;
    }
    },
  builder: (c, s) {
    return Scaffold(
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
                'Record an expense',
                style: AppTextStyles.blackSizeBold14,
              ),
              centerTitle: false,
              elevation: 0.0,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Expense Name",
                            style: AppTextStyles.blackSize14,

                          ),
                          kVerticalSpaceSmall,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TypeAheadField(
                                textFieldConfiguration: TextFieldConfiguration(
                                  autofocus: false,
                                  controller: _expenseNameController,
                                  onChanged: (s){
                                    setState(() {
                                      typeAheadError = false;
                                      _expenseName = s;
                                    });
                                  },
                                  style: kDefaultTextStyle,
                                  decoration:InputDecoration(
                                      filled: true,
                                      fillColor: kBorderColor,
                                      focusedBorder: InputBorder.none,
                                      border: InputBorder.none,
                                      enabledBorder:  typeAheadError ? OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(color: kErrorColor, width: 0.5),
                                      ): InputBorder.none
                                      ,
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(color: kErrorColor, width: 0.5),
                                      )),
                                ),
                                hideOnEmpty: true,
                                hideOnError: true,
                                hideOnLoading: true,

                                suggestionsCallback: (pattern) async {
                                  if (pattern.isEmpty){
                                    return [];
                                  }
                                  return expenseList.where((element) => element
                                      .toLowerCase()
                                      .startsWith(pattern.toLowerCase()));
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    title: Text(suggestion.toString()),
                                  );
                                },
                                onSuggestionSelected: (suggestion) {
                                  _expenseName = suggestion.toString();
                                  _expenseNameController.text=_expenseName;
                                },
                              ),
                              if (typeAheadError)Row(
                                children: [
                                  kHorizontalSpaceSmall,
                                  Text("This cannot be empty", style: kErrorColorTextStyle.copyWith(
                                    fontSize: 10
                                  ),),
                                ],
                              ),
                            ],
                          ),

                          kVerticalSpaceMedium,
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
                                    setState(() {
                                      dateError = false;
                                    });
                                    _pickDate();
                                  },
                                  child: Container(
                                    padding:
                                    const EdgeInsets.all(kDefaultSpacing * 0.5),
                                    height: 50,
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      color: kBorderColor,
                                      borderRadius: BorderRadius.circular(5),
                                      border: dateError ? Border.all(color: kErrorColor,): null,
                                    ),
                                    child: Text(
                                      recordDate == null
                                          ? "Select Date..."
                                          : DateFormat(
                                          "${DateFormat.DAY}/${DateFormat
                                              .MONTH}/${DateFormat
                                              .YEAR}  hh:${DateFormat.MINUTE} a")
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
                                    dateError  = false;
                                    recordDate = DateTime.now();
                                  });
                                },
                                child: Container(
                                  padding:
                                  const EdgeInsets.fromLTRB(20, 16, 20, 16),
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
                          if (dateError)Row(
                            children: [
                              kHorizontalSpaceSmall,
                              Text("Date cannot be empty", style: kErrorColorTextStyle.copyWith(
                                  fontSize: 13
                              ),),
                            ],
                          ),
                          kVerticalSpaceMedium,
                          Text(
                            "Expense Cost",
                            style: AppTextStyles.blackSize14,
                          ),
                          kVerticalSpaceSmall,
                          LoginTextField(
                            validator: emptyFieldValidator,
                            onChanged: (String v) {
                              setState(() {
                                _price = v;
                              });
                            },
                            withTitle: false,
                            inputType: TextInputType.number,
                          ),
                          kVerticalSpaceMedium,
                          Text(
                            "Expense Description",
                            style: AppTextStyles.blackSize14,
                          ),
                          kVerticalSpaceSmall,
                          LoginTextField(
                            validator: (_) {},
                            onChanged: (String v) {
                              setState(() {
                                _description = v;
                              });
                            },
                            minLines: 2,
                            withTitle: false,
                          ),
                          kVerticalSpaceRegular,
                          SubmitButton(
                              isLoading: s is TransactionCrudStateLoading,
                              backgroundColor: kGreenColor,
                              enabled: s is! TransactionCrudStateLoading,
                              text: "Submit", onSubmit: _recordExpense)
                        ],

                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  },
);
        }
      ),
    );
  }

  void _recordExpense() {
    formKey.currentState!.validate();
    if (recordDate == null){
      print("record date is false");
      setState(() {
        dateError = true
;      });
    }
    if (_expenseName.trim().isEmpty){
      setState(() {
        typeAheadError = true;      });
    }
    if (dateError ||typeAheadError){
      return;
    }
    if (formKey.currentState!.validate()) {
      _transactionCrudCubit.addExpense(
          name: _expenseName,
          amount: num.parse(_price),
          description: _description,
          dateRecorded: recordDate!);
    }
  }

  void _pickDate() {
    DatePicker.showDatePicker(context, theme: DatePickerTheme()).then((value) {
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
    //     context: context,
    //     initialDate: DateTime.now(),
    //     firstDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
    //     lastDate: DateTime.now().add(const Duration(days: 365 * 2)))
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
