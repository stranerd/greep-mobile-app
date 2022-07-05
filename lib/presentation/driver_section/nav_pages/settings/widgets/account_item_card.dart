import 'package:flutter/material.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/ui_helpers.dart';

import '../../../../../utils/constants/app_styles.dart';

class AccountItemCard extends StatelessWidget {

  const AccountItemCard(
      {Key? key,
      required this.title,
      required this.subtitle,
      this.isSelectable = false})
      : super(key: key);
  final String title;
  final String subtitle;
  final bool isSelectable;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 0, 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: kLightGrayColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.blackSize14,
          ),
         kVerticalSpaceTiny,
          isSelectable
              ? SelectableText(
                  subtitle,
                  style: AppTextStyles.blackSize16,
                )
              : Text(
                  subtitle,
                  style: AppTextStyles.blackSize16,
                ),
        ],
      ),
    );
  }
}
