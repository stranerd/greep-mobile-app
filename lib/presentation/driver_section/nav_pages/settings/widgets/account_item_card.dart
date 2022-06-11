import 'package:flutter/material.dart';

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
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: const Color.fromRGBO(221, 226, 224, 1),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.blackSize12,
          ),
          const SizedBox(
            height: 4.0,
          ),
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
