import 'package:flutter/material.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/ui_helpers.dart';

class FormInputBgWidget extends StatelessWidget {
  final Widget child;
  const FormInputBgWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: kDefaultSpacing * 0.5, horizontal: kDefaultSpacing),
    height: 50,
    alignment: Alignment.centerLeft,
    decoration: BoxDecoration(
    color: kBorderColor,
    borderRadius: BorderRadius.circular(5),
    ),
    child: child,);
  }
}
