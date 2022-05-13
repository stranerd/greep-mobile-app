import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/constants/app_styles.dart';

class SettingsHomeItem extends StatelessWidget {
  const SettingsHomeItem({Key? key, required this.title, required this.icon})
      : super(key: key);

  final String title;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: const Color.fromRGBO(221, 226, 224, 1),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(icon),
          const SizedBox(width: 20.0),
          Text(title, style: AppTextStyles.blackSize16),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}
