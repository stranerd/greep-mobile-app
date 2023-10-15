import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:greep/application/user/user_crud_cubit.dart';
import 'package:greep/application/user/utils/get_current_user.dart';
import 'package:greep/commons/Utils/input_validator.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/scaffold_messenger_service.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/user/model/User.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/input_text_field.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_styles.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> with ScaffoldMessengerService, InputValidator {
  late UserCrudCubit _userCrudCubit;
  String _currentPassword = "", _newPassword = "", _confirmNewPassword = "";
  late TextEditingController _currentPasswordController, _newPasswordController, _confirmNewPasswordController;
  late User user;

  final formKey = GlobalKey<FormState>();
  bool hasPicked = false;

  @override
  void initState() {
    _userCrudCubit = GetIt.I<UserCrudCubit>();
    user = currentUser();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmNewPasswordController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _userCrudCubit,
      child: Builder(builder: (context) {
        return BlocConsumer<UserCrudCubit, UserCrudState>(
            listener: (context, state) {
              if (state is UserCrudStateFailure) {
                error = state.errorMessage;
              }
              if (state is UserCrudStateSuccess) {
                success = "Profile edited successfully";
                Future.delayed(const Duration(seconds: 2), () => Get.back());
              }
            }, builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: const BackIcon(isArrow:true,),
              title: TextWidget(
                "Security",
                fontSize: 18.sp,
                weight: FontWeight.bold,
              ),
              centerTitle: true,
              elevation: 0.0,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    key: formKey,
                    child: Container(
                      padding: const EdgeInsets.all(kDefaultSpacing),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          kVerticalSpaceRegular,
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InputTextField(
                                title: "Current password",
                                customController: _currentPasswordController,
                                validator: emptyFieldValidator,
                                onChanged: (String value) {
                                  _currentPassword = value;
                                  setState(() {});
                                },
                                hintText: "Current password",
                                withBorder: true,
                              ),
                              SizedBox(height: 24.h,),
                              InputTextField(

                                customController: _newPasswordController,
                                validator: emptyFieldValidator,
                                title: "New password",
                                onChanged: (String value) {
                                  setState(() {
                                    _newPassword = value;
                                  });
                                },
                                hintText: "Enter new password",
                                withBorder: true,
                              ),
                              SizedBox(height: 24.h,),
                              InputTextField(

                                customController: _confirmNewPasswordController,
                                validator: emptyFieldValidator,
                                title: "Confirm new password",
                                onChanged: (String value) {
                                  setState(() {
                                    _confirmNewPassword = value;
                                  });
                                },
                                hintText: "Confirm new password",
                                withTitle: true,
                                withBorder: true,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 24.0.h,
                          ),
                          SubmitButton(
                              enabled: (_currentPasswordController.text.isNotEmpty &&
                                  _newPasswordController.text.isNotEmpty),
                              text: "Save",
                              isLoading: state is UserCrudStateLoading,
                              onSubmit: _editUser)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      }),
    );
  }

  void _editUser() async {
    if (formKey.currentState!.validate()) {

    }
  }
}
