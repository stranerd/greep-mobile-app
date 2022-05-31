import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/ui_helpers.dart';

class LoginTextField extends StatefulWidget {
  final String title;
  final bool isPassword;
  final Function(String) validator;
  final Function(String) onChanged;

  const LoginTextField(
      {Key? key,
      required this.title,
      required this.validator,
        required this.onChanged,
      required this.isPassword,})
      : super(key: key);

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  late TextEditingController editingController;
  bool isObscure = true;


  @override
  void initState() {
    editingController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title,style: kDefaultTextStyle,),
          kVerticalSpaceTiny,
          TextFormField(
            onChanged: widget.onChanged,
            controller: editingController,
            cursorColor: kPrimaryColor,
            style: Theme.of(context).textTheme.bodyText1,
            obscureText: widget.isPassword && isObscure,
            decoration: InputDecoration(
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          isObscure ? Icons.visibility : Icons.visibility_off,
                          color: kBlackColor
                        ),
                        onPressed: toggleObscurity,
                      )
                    : null,
                filled: true,
                fillColor: kBorderColor,
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: kErrorColor,width: 0.5),
                )),
            validator: (val) => widget.validator(val!),
          )
        ],
      ),
    );
  }

  void toggleObscurity(){
    setState(() {
      isObscure = !isObscure;
    });
  }

}
