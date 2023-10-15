import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greep/application/user/utils/get_current_user.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/driver_section/transaction/view_range_transactions.dart';
import 'package:greep/presentation/widgets/app_dialog.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/submit_button.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as dt;
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';
import 'package:greep/utils/constants/app_styles.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart' as g;


class DateRangeView extends StatefulWidget {
  const DateRangeView({Key? key, required this.onSelectedDate}) : super(key: key);
  final Function(DateTime,DateTime) onSelectedDate;
  @override
  _DateRangeViewState createState() => _DateRangeViewState();
}

class _DateRangeViewState extends State<DateRangeView> {


  DateTime? from;
  DateTime? to;
  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: "Date range",
      // height: 250.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _pickDate(true),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 12.h,),
                    decoration: BoxDecoration(
                      border: Border.all(width: 2.w,color: AppColors.gray2),

                      borderRadius:
                      BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextWidget(
                            from == null
                                ? "From"
                                : DateFormat(
                                "${DateFormat.DAY}-${DateFormat.MONTH}-${DateFormat.YEAR} ")
                                .format(from!),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            fontSize: from == null ? null : 13.sp,
                            color: from == null ? AppColors.veryLightGray : AppColors.black,
                          ),
                        ),
                        SvgPicture.asset("assets/icons/calendar.svg")
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w,),
              SvgPicture.asset("assets/icons/minus.svg"),
              SizedBox(width: 3.w,),

              Expanded(
                child: SplashTap(
                  onTap: () => _pickDate(false),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 12.h,),

                    decoration: BoxDecoration(
                      border: Border.all(width: 2.w,color: AppColors.gray2),
                      borderRadius:
                      BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextWidget(
                            to == null
                                ? "To"
                                : DateFormat(
                                "${DateFormat.DAY}-${DateFormat.MONTH}-${DateFormat.YEAR} ")
                                .format(to!),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            fontSize: to == null ? null : 13.sp,

                            color: to == null ? AppColors.veryLightGray : AppColors.black,

                          ),
                        ),
                        SvgPicture.asset("assets/icons/calendar.svg")

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h,),
          // Spacer(),
          SubmitButton(
              text: "Apply",
              enabled: from != null && to != null,
              onSubmit: () {
                widget.onSelectedDate(from!,to!);
                // g.Get.to(
                //         () => RangeTransactionsScreen(
                //       userId: currentUser().id,
                //       from: from!,
                //       to: to!,
                //     ),
                //     transition: g.Transition.fadeIn);
              }),
        ],
      ),
    );
  }

  void _pickDate(bool isFrom) {
    dt.DatePicker.showDatePicker(context, theme: const dt.DatePickerTheme())
        .then((value) {
      if (value != null) {
        if (isFrom) {
          from = value;
        } else {
          to = value;
        }
        setState(() {});
      }
    });
    // showDatePicker(
    //         context: context,
    //         initialDate: DateTime.now(),
    //         firstDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
    //         lastDate: DateTime.now().add(const Duration(days: 365 * 2)))
    //     .then((value) {
    //   if (value != null) {
    //     if (isFrom) {
    //       from = value;
    //     } else {
    //       to = value;
    //     }
    //     setState(() {});
    //   }
    // });
  }

}
