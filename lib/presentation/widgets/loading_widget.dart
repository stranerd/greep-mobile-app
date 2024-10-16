import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/utils/constants/app_colors.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class LoadingWidget extends StatelessWidget {
  final double? size;
  final Color? color;
  final bool isGreep;
  final double? topPadding;

  const LoadingWidget({
    Key? key,
    this.size,
    this.color,
    this.topPadding,
    this.isGreep = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double sizee = size?.r ?? 40.r;

    return isGreep
        ? Container(
            height: sizee + 10,
            margin: EdgeInsets.only(top: topPadding ?? 0),
            width: sizee + 10,
            child: Stack(
              children: [
                Positioned.fill(
                    child: SleekCircularSlider(
                        appearance: CircularSliderAppearance(
                  customWidths: CustomSliderWidths(
                    trackWidth: 0.r,
                    progressBarWidth: 4.r,
                    handlerSize: 0,
                  ),
                  customColors: CustomSliderColors(
                    trackColor: Colors.transparent,
                    progressBarColor: AppColors.black,
                  ),
                  spinnerMode: true,
                ))),
                Align(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    "assets/icons/greep_icon.svg",
                    height: sizee,
                    width: sizee,
                  ),
                )
              ],
            ),
          )
        : Container(
            height: sizee,
            margin: EdgeInsets.only(top: topPadding ?? 0),
            alignment: Alignment.center,
            width: sizee,
            child: CircularProgressIndicator(
              color: color ?? kGreenColor,
            ),
          );
  }
}
