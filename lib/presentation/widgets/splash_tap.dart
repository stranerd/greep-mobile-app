import 'package:flutter/material.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/ui_helpers.dart';

class SplashTap extends StatelessWidget {
  final Function? onTap;
  final Widget child;
  const SplashTap({Key? key, required this.onTap, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: kPrimaryColor.withOpacity(0.2),
      highlightColor: kPrimaryColor.withOpacity(0.2),
      hoverColor: kPrimaryColor.withOpacity(0.2),

      borderRadius: const BorderRadius.all(Radius.circular(kDefaultSpacing * 0.5)),
      overlayColor: MaterialStateProperty.all(kPrimaryColor.withOpacity(0.2)),
      onTap: () {
        if (onTap!=null){
        Future.delayed(const Duration(milliseconds: 150), (){

          onTap!();
        });
        }
      },

      child: child,
    );
  }
}
