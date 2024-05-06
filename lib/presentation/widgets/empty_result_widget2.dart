import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greep/presentation/widgets/text_widget.dart';

class EmptyResultWidget2 extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? icon;
  final double? top;
  final double? iconHolderRadius;
  final Widget? bottomCta;

  const EmptyResultWidget2({
    Key? key,
    this.iconHolderRadius,
    this.title,
    this.bottomCta,
    this.subtitle,
    this.icon,
    this.top,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        width: constraints.maxWidth,
        child: Column(
          children: [
            SizedBox(
              height: (16 + (top ?? 0)).h,
            ),
            if (icon != null)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  icon!,
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            if (title != null && title!.isNotEmpty)
              Column(
                children: [
                  TextWidget(
                    title!,
                    weight: FontWeight.bold,
                    fontSize: 20.sp,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10.h,
                  )
                ],
              ),
            if (subtitle != null && subtitle!.isNotEmpty)
              Column(
                children: [
                  TextWidget(
                    subtitle!,
                    textAlign: TextAlign.center,
                    fontSize: 14.sp,
                  )
                ],
              ),
            if (bottomCta!=null)Column(
              children: [
                SizedBox(height: 15.h,),
               bottomCta!
              ],
            )
          ],
        ),
      );
    });
  }
}
