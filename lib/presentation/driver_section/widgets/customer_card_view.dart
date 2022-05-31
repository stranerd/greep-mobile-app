import 'package:flutter/material.dart';

class CustomerCardView extends StatelessWidget {
  const CustomerCardView(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.titleStyle,
      required this.subtitleStyle})
      : super(key: key);

  final String title;
  final String subtitle;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromRGBO(221, 226, 224, 1),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
        child: Row(
          children: [
            Text(
              title,
              style: titleStyle,
            ),
            const Spacer(),
            Text(
              subtitle,
              style: subtitleStyle,
            ),
          ],
        ),
      ),
    );
  }
}
