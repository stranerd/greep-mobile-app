import 'package:flutter/material.dart';
import 'package:greep/commons/ui_helpers.dart';

class EmptyResultWidget extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;

  const EmptyResultWidget({Key? key, required this.text, this.textStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: textStyle ?? kDefaultTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
