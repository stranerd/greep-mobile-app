import 'package:flutter/material.dart';
import 'package:grip/commons/colors.dart';

class SplashTap extends StatelessWidget {
  final Function onTap;
  final Widget child;
  const SplashTap({Key? key, required this.onTap, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: kPrimaryColor.withOpacity(0.2),
      highlightColor: kPrimaryColor,
      hoverColor: kPrimaryColor,
      overlayColor: MaterialStateProperty.all(kPrimaryColor.withOpacity(0.2)),
      onTap: () {
        Future.delayed(const Duration(milliseconds: 150), (){
          onTap();
        });
      },

      child: child,
    );
  }
}
