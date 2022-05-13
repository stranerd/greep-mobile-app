import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecordCard extends StatelessWidget {
  const RecordCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.titleStyle,
    required this.subtitleStyle,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        width: 104.w,
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
          ],
        ),
      ),
    );
  }
}
