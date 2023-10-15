import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greep/commons/money.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/widgets/naira_symbol.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/presentation/widgets/turkish_symbol.dart';

enum MoneyCurrency {
  naira,
  turkish,
}

class MoneyWidget extends StatelessWidget {
  const MoneyWidget(
      {Key? key,
      this.size,
      this.currency = MoneyCurrency.turkish,
      this.flipped = false,
      this.onlyAmount = false,
      this.withSymbol = true,
      required this.amount,
      this.weight,
      this.color})
      : super(key: key);

  final double? size;
  final num amount;
  final FontWeight? weight;
  final Color? color;
  final bool withSymbol;
  final bool onlyAmount;
  final bool flipped;
  final MoneyCurrency currency;

  @override
  Widget build(BuildContext context) {
    if (flipped ) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextWidget(
            "${!withSymbol && !onlyAmount ? "NGN" : ""}${amount.toMoney}",
            fontSize: size?.sp,
            weight: weight,
            color: color,
          ),
          SizedBox(width: 1.2.w,),

          if (withSymbol)
            currency == MoneyCurrency.turkish
                ? TurkishSymbol(
                    width: size?.r,
                    height: size?.r,
                    color: color ?? Colors.black,
                  )
                : NairaSymbol(
                    width: size ?? kDefaultSpacing,
                    height: size ?? kDefaultSpacing,
                    color: color ?? Colors.black,
                  ),
        ],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (withSymbol)
          currency == MoneyCurrency.turkish
              ? TurkishSymbol(
                  width: size?.r,
                  height: size?.r,
                  color: color ?? Colors.black,
                )
              : NairaSymbol(
                  width: size ?? kDefaultSpacing,
                  height: size ?? kDefaultSpacing,
                  color: color ?? Colors.black,
                ),
        SizedBox(width: 1.2.w,),

        TextWidget(
          "${!withSymbol && !onlyAmount ? "NGN" : ""}${amount.toMoney}",
          fontSize: size?.sp,
          weight: weight,
          color: color,
        ),
      ],
    );
  }
}
