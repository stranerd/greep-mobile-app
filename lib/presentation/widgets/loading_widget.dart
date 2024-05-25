import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greep/Commons/colors.dart';

class LoadingWidget extends StatelessWidget {
  final double? size;
  final Color? color;
  final bool isGreep;

  const LoadingWidget({
    Key? key,
    this.size,
    this.color,
    this.isGreep = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        alignment: Alignment.center,
        constraints: BoxConstraints(
            minHeight: size ?? 40.r,
            maxHeight: constraints.maxWidth,
            maxWidth: constraints.maxWidth,
            minWidth: size ?? 40.r),
        child: CircularProgressIndicator(
          color: color ?? kGreenColor,
        ),
      );
    });
  }
}
