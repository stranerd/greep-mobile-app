import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.trailing,
      required this.titleStyle,
      required this.subtitleStyle,
      required this.trailingStyle,
      required this.subTrailing,
      required this.subTrailingStyle})
      : super(key: key);
  final String title;
  final String subtitle;
  final String trailing;
  final String subTrailing;

  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final TextStyle trailingStyle;
  final TextStyle subTrailingStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: titleStyle),
            const SizedBox(
              height: 4,
            ),
            Text(
              subtitle,
              style: subtitleStyle,
            ),
          ],
        ),
        const Spacer(),
        Column(
          children: [
            Text(
              trailing,
              style: trailingStyle,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              subTrailing,
              style: subTrailingStyle,
            ),
          ],
        ),
      ],
    );
  }
}
