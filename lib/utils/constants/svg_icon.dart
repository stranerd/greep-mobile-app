import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgAssets {
  static final SvgData home = SvgData('assets/icons/home2.svg');
  static final SvgData people = SvgData('assets/icons/people2.svg');
  static final SvgData history = SvgData('assets/icons/history2.svg');
  static final SvgData settings = SvgData('assets/icons/settings.svg');
  static final SvgData message = SvgData('assets/icons/message.svg');

  static final SvgData map = SvgData("assets/icons/map.svg");

  static final SvgData homeActive = SvgData('assets/icons/home-active.svg');
  static final SvgData peopleActive = SvgData('assets/icons/people-active.svg');
  static final SvgData historyActive =
      SvgData('assets/icons/history-active.svg');
  static final SvgData settingsActive =
      SvgData('assets/icons/settings-active.svg');

  static final SvgData mapActive = SvgData("assets/icons/location.png");

}

class SvgData {
  final String data;
  SvgData(this.data, {icon});
}

///Use SvgAsset.iconName to specify the svg icon
class SvgIcon extends StatelessWidget {
  final SvgData svgIcon;
  final Color? color;
  final double? size;
  final bool? noColor;

  const SvgIcon({
    Key? key,
    required this.svgIcon,
    this.color,
    this.noColor,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return svgIcon.data.endsWith(".png") ?Image.asset(
      svgIcon.data,
      color: noColor == true
          ? null
          : color ?? Theme.of(context).textTheme.bodyText1!.color,
      height: size,
    ) :  SvgPicture.asset(
      svgIcon.data,
      color: noColor == true
          ? null
          : color ?? Theme.of(context).textTheme.bodyText1!.color,
      height: size,
    );
  }
}
