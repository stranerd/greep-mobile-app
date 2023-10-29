import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greep/commons/money.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/widgets/naira_symbol.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/presentation/widgets/turkish_symbol.dart';
import 'package:greep/utils/constants/app_colors.dart';

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
      this.isPositive = false,
      this.isNegative = false,
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
  final bool isPositive;
  final bool isNegative;

  @override
  Widget build(BuildContext context) {
    double? currencySize = size != null ? (size! * 0.9).r : null;
    var notation = TextWidget(
      isPositive
          ? "+"
          : isNegative
              ? "-"
              : "",
      color: isPositive
          ? AppColors.green
          : isNegative
              ? AppColors.red
              : AppColors.black,
      fontSize: size?.sp,
      weight: weight,
    );

    if (flipped) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          notation,
          TextWidget(
            "${!withSymbol && !onlyAmount ? "NGN" : ""}${amount.toMoney}",
            fontSize: size?.sp,
            weight: weight,
            color: isNegative
                ? AppColors.red
                : isPositive
                    ? AppColors.green
                    : color,
          ),
          SizedBox(
            width: 1.2.w,
          ),
          if (withSymbol)
            currency == MoneyCurrency.turkish
                ? TurkishSymbol(
                    width: currencySize,
                    height: currencySize,
                    color: isNegative
                        ? AppColors.red
                        : isPositive
                            ? AppColors.green
                            : color ?? Colors.black,
                  )
                : NairaSymbol(
                    width: currencySize,
                    height: currencySize,
                    color: isNegative
                        ? AppColors.red
                        : isPositive
                            ? AppColors.green
                            : color ?? Colors.black,
                  ),
        ],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        notation,
        if (withSymbol)
          currency == MoneyCurrency.turkish
              ? TurkishSymbol(
                  width: currencySize,
                  height: currencySize,
                  color: isNegative
                      ? AppColors.red
                      : isPositive
                          ? AppColors.green
                          : color ?? Colors.black,
                )
              : NairaSymbol(
                  width: currencySize,
                  height: currencySize,
                  color: isNegative
                      ? AppColors.red
                      : isPositive
                          ? AppColors.green
                          : color ?? Colors.black,
                ),
        SizedBox(
          width: 1.2.w,
        ),
        TextWidget(
          "${!withSymbol && !onlyAmount ? "NGN" : ""}${amount.toMoney}",
          fontSize: size?.sp,
          weight: weight,
          color: isNegative
              ? AppColors.red
              : isPositive
                  ? AppColors.green
                  : color,
        ),
      ],
    );
  }
}
