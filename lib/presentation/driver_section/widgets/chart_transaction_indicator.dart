import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/presentation/widgets/turkish_symbol.dart';

class ChartTransactionIndicator extends StatelessWidget {
  final Color color;
  final Color backgroundColor;
  final String text;
  final bool isNegative;
  final String amount;
  final String icon;
  final bool isSelected;

  const ChartTransactionIndicator({
    Key? key,
    required this.color,
    required this.text,
     this.isNegative = false,
    required this.amount,
    required this.icon,
    required this.backgroundColor,
    this.isSelected = false,
  }) : super(key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 27.w,
          height: 50.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kDefaultSpacing * 0.4),
              color: backgroundColor),
          child: SvgPicture.asset(
            icon,
            height: 15.h,
          ),
        ),
        kHorizontalSpaceSmall,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isNegative)TextWidget(
                  "-",
                  color: color,
                  fontSize: isSelected ? 19 : 17,
                  weight: FontWeight.bold,
                ),
                TurkishSymbol(
                  width: isSelected ? 17.r : 16.r,
                  height: isSelected ? 17.r : 16.r,
                  color: color,
                ),
                TextWidget(
                  amount,
                  color: color,
                  fontSize: isSelected ? 19 : 17,
                  weight: FontWeight.bold,
                ),
              ],
            ),
            TextWidget(
              text,
              fontSize: 12.8,
              weight: isSelected ? FontWeight.bold : FontWeight.normal ,
            ),
          ],
        )
      ],
    );
  }
}
