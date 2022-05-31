import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomerRecordCard extends StatelessWidget {
  const CustomerRecordCard(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.titleStyle,
      required this.subtitleStyle,
      required this.subtextTitle,
      required this.subtextTitleStyle})
      : super(key: key);

  final String title;
  final String subtitle;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final String subtextTitle;
  final TextStyle subtextTitleStyle;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: 104.w,
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
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
            Text(title, style: titleStyle),
            const SizedBox(height: 8.0),
            Text(subtitle, style: subtitleStyle),
            const SizedBox(height: 8.0),
            Text(subtextTitle, style: subtextTitleStyle),
          ],
        ),
      ),
    );
  }
}
