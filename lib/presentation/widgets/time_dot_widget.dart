import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';
import 'package:intl/intl.dart';

class TimeDotWidget extends StatelessWidget {
  const TimeDotWidget({Key? key,this.showYear = false, required this.date, this.fontSize = 12, this.color = AppColors.veryLightGray,}) : super(key: key);
  final DateTime date;
  final Color color;
final double fontSize;
final bool showYear;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextWidget(
          DateFormat("${DateFormat.ABBR_MONTH} ${DateFormat.DAY} ${showYear ? DateFormat.YEAR:""}").format(date),
          color: color,
          weight: FontWeight.w400,
          fontSize: fontSize.sp,
        ),
        kHorizontalSpaceSmall,
        Container(
          width: 3.r,
          height: 3.r,
          decoration:  BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        kHorizontalSpaceSmall,
        TextWidget(
          DateFormat("hh:mm a").format(date),
          color: color,
          weight: FontWeight.w400,
          fontSize: fontSize.sp,
        )
      ],
    );
  }
}
