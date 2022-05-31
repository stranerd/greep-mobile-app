import 'package:flutter/material.dart';

class TransactionListCard extends StatelessWidget {
  const TransactionListCard(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.trailing,
      required this.titleStyle,
      required this.subtitleStyle,
      required this.trailingStyle})
      : super(key: key);
  final String title;
  final String subtitle;
  final String trailing;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final TextStyle trailingStyle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: titleStyle),
      subtitle: Text(
        subtitle,
        style: subtitleStyle,
      ),
      trailing: Text(
        trailing,
        style: trailingStyle,
      ),
    );
  }
}
