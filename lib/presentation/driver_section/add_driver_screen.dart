import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:greep/application/user/user_crud_cubit.dart';
import 'package:greep/commons/Utils/input_validator.dart';
import 'package:greep/application/user/utils/get_current_user.dart';
import 'package:greep/commons/colors.dart';

import 'package:greep/commons/scaffold_messenger_service.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/form_input_bg_widget.dart';
import 'package:greep/presentation/widgets/input_text_field.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';
import 'package:greep/utils/constants/app_styles.dart';

class AddDriverScreen extends StatefulWidget {
  const AddDriverScreen({Key? key}) : super(key: key);

  @override
  _AddDriverScreenState createState() => _AddDriverScreenState();
}

class _AddDriverScreenState extends State<AddDriverScreen> with ScaffoldMessengerService,InputValidator{
  String _driverId = "";

  late TextEditingController _driverIdController;
  late TextEditingController _commissionController;


  late UserCrudCubit _userCrudCubit;

  final formKey = GlobalKey<FormState>();

  int _commission = 0;

  @override
  void initState() {
    _driverIdController = TextEditingController();
    _commissionController = TextEditingController()..text="0";

    _userCrudCubit = GetIt.I<UserCrudCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _userCrudCubit,
      child: Builder(
          builder: (context) {
            return BlocConsumer<UserCrudCubit, UserCrudState>(
              listener: (context, state) {
                if (state is UserCrudStateSuccess){
                  if (state.isDriverAdd){
                  success = "Manager request sent";
                  Future.delayed(const Duration(milliseconds: 1500), (){
                    Get.back();
                  });
                  }
                }
                if (state is UserCrudStateFailure){
                  error = state.errorMessage.capitalize;
                }
              },
              builder: (c,s) => Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  leading: BackIcon(isArrow: true,),
                  title: TextWidget(
                    'Add a Driver',
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
                          const TextWidget(
                            "Driver",
                          ),
                          SizedBox(height: 8.h,),
                          InputTextField(
                            hintText: "Enter driver id",
                            customController: _driverIdController,
                            validator: emptyFieldValidator,

                            onChanged: (String v) {
                              setState(() {
                                _driverId = v;
                              });
                            },
                            withTitle: false,
                          ),
                          SizedBox(height: 16.h,),

                          TextWidget(
                            "Percentage Commission",
                            style: AppTextStyles.blackSize14,
                          ),
                          SizedBox(height: 8.h,),

                          FormInputBgWidget(
                              child: Row(

                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (_commission >= 0) {
                                        _commission--;
                                        _commissionController.text = _commission.toString();

                                        setState(() {

                                        });
                                      }
                                    },
                                    child: Container(
                                      width: 50.w,
                                      padding: const EdgeInsets.all(kDefaultSpacing * 0.3),
                                      decoration: const BoxDecoration(

                                      ),
                                      child: TextWidget(
                                        "-",
                                        style: kBoldTextStyle.copyWith(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50.w,
                                    height: 60.h,
                                    child: TextField(
                                      style: kBoldTextStyle.copyWith(
                                          fontSize: 18.sp
                                      ),
                                      controller: _commissionController,
                                      onChanged: (String s) {
                                        int l = int.tryParse(s)??0;
                                        _commission = l;
                                        _commissionController..text = _commission.toString()
                                          ..selection = TextSelection.fromPosition(
                                              TextPosition(offset: _commissionController.text.length));
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          enabledBorder:InputBorder.none
                                      ),
                                    ),
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      if (_commission <= 100) {
                                        _commission++;
                                        _commissionController.text = _commission.toString();

                                        setState(() {

                                        });
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      width: 50.w,
                                      padding: const EdgeInsets.all(kDefaultSpacing * 0.3),
                                      decoration: const BoxDecoration(),
                                      child: Text(
                                        "+",
                                        style: kBoldTextStyle.copyWith(fontSize: 20.sp),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          kVerticalSpaceMedium,
                          SubmitButton(
                            backgroundColor: kGreenColor,
                              isLoading: s is UserCrudStateLoading,
                              enabled: _commission <= 100 && _commission>=0 && s is! UserCrudStateLoading,
                              text: "Submit", onSubmit: _addDriver)
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

  void _addDriver() {
    if (formKey.currentState!.validate()){
      if (currentUser().id == _driverId){
        error = "You cannot add yourself";
        return;
      }

      _userCrudCubit.addDriver(
          managerId: currentUser().id,
          managerName: currentUser().fullName,
          driverId: _driverId, commission: _commission/100);
    }
  }

}
