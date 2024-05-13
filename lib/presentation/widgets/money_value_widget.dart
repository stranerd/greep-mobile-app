import 'package:flutter/material.dart';
import 'package:greep/presentation/widgets/box_shadow_container.dart';
import 'package:greep/presentation/widgets/money_widget.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/utils/constants/app_colors.dart';

class MoneyValueWidget extends StatelessWidget {
  final Function(num) onSelect;
  final bool isSelected;
  final num value;
  const MoneyValueWidget({Key? key, required this.onSelect, required this.value, required this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashTap(
      onTap: () {
        onSelect(value);
      },
      child: BoxShadowContainer(
        verticalPadding: 12,
        horizontalPadding: 13,
        borderColor: isSelected ? AppColors.black : null,
        child: Center(
          child: MoneyWidget(
            amount: value,
          ),
        ),
      ),
    );
  }
}
