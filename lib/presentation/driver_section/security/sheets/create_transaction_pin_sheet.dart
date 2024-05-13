import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:greep/application/auth/password/request/create_transaction_pin_request.dart';
import 'package:greep/application/auth/password/reset_password_cubit.dart';
import 'package:greep/commons/Utils/validators.dart';
import 'package:greep/ioc.dart';
import 'package:greep/presentation/widgets/app_dialog.dart';
import 'package:greep/presentation/widgets/input_text_field.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:greep/presentation/widgets/text_widget.dart';


class CreateTransactionPinSheet extends StatefulWidget {
  const CreateTransactionPinSheet({Key? key, required this.onFinished})
      : super(key: key);
  final Function(String) onFinished;

  @override
  _CreateTransactionPinSheetState createState() =>
      _CreateTransactionPinSheetState();
}

class _CreateTransactionPinSheetState extends State<CreateTransactionPinSheet> {
  String pin = "";
  String confirmPin = "";

  late PasswordCrudCubit passwordCubit;

  @override
  void initState() {
    super.initState();
    passwordCubit = getIt();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider.value(
        value: passwordCubit,
        child: BlocConsumer<PasswordCrudCubit, PasswordCrudState>(
          listener: (context, state) {
            if (state is PasswordCrudStateSuccess) {
              Get.back();
              widget.onFinished(pin);
            }
          },
          builder: (context, crudState) {
            return SingleChildScrollView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: AppDialog(
                    title: "Create Transaction PIN",
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            color: Color(0xffF0F3F6),
                            borderRadius: BorderRadius.circular(
                              6.r,
                            ),
                          ),
                          child: TextWidget(
                            "Your 4-digit transaction PIN secures your transactions. Do not share it with anyone.",
                          ),
                        ),
                        SizedBox(
                          height: 24.h,
                        ),
                        InputTextField(
                          validator: requiredValidator,
                          isPassword: true,
                          inputType: TextInputType.number,
                          onChanged: (s) {
                            setState(() {
                              pin = s;
                            });
                          },
                          maxTextLength: 4,
                          title: "New PIN",
                          hintText: "****",
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        InputTextField(
                          validator: requiredValidator,
                          isPassword: true,
                          maxTextLength: 4,
                          inputType: TextInputType.number,
                          onChanged: (s) {
                            setState(() {
                              confirmPin = s;
                            });
                          },
                          title: "Confirm new PIN",
                          hintText: "****",
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        SubmitButton(
                          text: "Create",
                          isLoading: crudState is PasswordCrudStateLoading,
                          onSubmit: () {
                            passwordCubit.updateTransactionPin(
                                UpdateTransactionPinRequest(
                              oldPin: null,
                              pin: pin,
                            ));
                          },
                          enabled: pin.isNotEmpty &&
                              confirmPin.isNotEmpty &&
                              pin == confirmPin && crudState is! PasswordCrudStateLoading,
                        )
                      ],
                    )));
          },
        ),
      ),
    );
  }
}
