import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/user/user_crud_cubit.dart';
import 'package:grip/commons/Utils/input_validator.dart';
import 'package:grip/application/user/utils/get_current_user.dart';
import 'package:grip/commons/colors.dart';

import 'package:grip/commons/scaffold_messenger_service.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/presentation/widgets/form_input_bg_widget.dart';
import 'package:grip/presentation/widgets/input_text_field.dart';
import 'package:grip/presentation/widgets/submit_button.dart';
import 'package:grip/utils/constants/app_colors.dart';
import 'package:grip/utils/constants/app_styles.dart';

class AddDriverScreen extends StatefulWidget {
  const AddDriverScreen({Key? key}) : super(key: key);

  @override
  _AddDriverScreenState createState() => _AddDriverScreenState();
}

class _AddDriverScreenState extends State<AddDriverScreen> with ScaffoldMessengerService,InputValidator{
  String _driverId = "";

  late TextEditingController _driverIdController;

  late UserCrudCubit _userCrudCubit;

  final formKey = GlobalKey<FormState>();

  int _commission = 0;

  @override
  void initState() {
    _driverIdController = TextEditingController();
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
                          Text(
                            "Driver",
                            style: AppTextStyles.blackSize14,
                          ),
                          kVerticalSpaceSmall,
                          LoginTextField(
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
                          kVerticalSpaceRegular,
                          Text(
                            "Percentage Commission",
                            style: AppTextStyles.blackSize14,
                          ),
                          kVerticalSpaceSmall,
                          FormInputBgWidget(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (_commission >= 0) {
                                        _commission--;
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
                                    _commission.toString(),
                                    style: kBoldTextStyle.copyWith(fontSize: 20),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (_commission <= 100) {
                                        _commission++;
                                        setState(() {

                                        });
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      width: 50,
                                      padding: const EdgeInsets.all(kDefaultSpacing * 0.3),
                                      decoration: const BoxDecoration(),
                                      child: Text(
                                        "+",
                                        style: kBoldTextStyle.copyWith(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          kVerticalSpaceMedium,
                          SubmitButton(
                            backgroundColor: kGreenColor,
                              isLoading: s is UserCrudStateLoading,
                              enabled: _driverId.isNotEmpty && _commission <= 100 && _commission>=0 && s is! UserCrudStateLoading,
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
