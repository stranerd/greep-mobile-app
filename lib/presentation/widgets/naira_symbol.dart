import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class NairaSymbol extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const NairaSymbol({Key? key, required this.width, this.color = Colors.black, required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/icons/naira.svg",
      width: width * 0.75,
      height: height * 0.75,
      color: color,
      fit: BoxFit.cover,
    );
  }
}
