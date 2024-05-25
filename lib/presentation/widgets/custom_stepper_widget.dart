import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class StepperChild {
  final String title;
  final String subTitle;
  final Widget icon;
  final bool isFirst;
  final bool isLast;
  final bool isSuccess;

  StepperChild(
      {required this.title,
      required this.subTitle,
      required this.icon,
      required this.isFirst,
      required this.isLast,
      required this.isSuccess});

  @override
  String toString() {
    return 'StepperChild{title: $title, subTitle: $subTitle, icon: $icon, isFirst: $isFirst, isLast: $isLast, isSuccess: $isSuccess}';
  }
}

class CustomStepperWidget extends StatefulWidget {
  final List<StepperChild> steps;

  const CustomStepperWidget({Key? key, required this.steps}) : super(key: key);

  @override
  _CustomStepperWidgetState createState() => _CustomStepperWidgetState();
}

class _CustomStepperWidgetState extends State<CustomStepperWidget> {
  @override
  void initState() {
    super.initState();
    print(widget.steps);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: widget.steps.map((e) => StepChildWidget(stepper: e)).toList(),
    );
  }
}

class StepChildWidget extends StatelessWidget {
  final StepperChild stepper;

  const StepChildWidget({super.key, required this.stepper});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 55.h,
                  width: 25.w,
                  child: Column(
                    children: [
                      Expanded(
                        child: Visibility(
                          child: Container(
                            width: 2.w,
                            height: 10.h,
                            decoration: BoxDecoration(
                              color: kPrimaryColor.withOpacity(stepper.isFirst
                                  ? 0
                                  : stepper.isSuccess
                                      ? 1
                                      : 0.1),
                            ),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.check_circle_rounded,
                        color: kPrimaryColor
                            .withOpacity(stepper.isSuccess ? 1 : 0.1),
                      ),
                      Expanded(
                        child: Visibility(
                          child: Container(
                            width: 2.w,
                            height: 10.h,
                            decoration: BoxDecoration(
                              color: kPrimaryColor.withOpacity(stepper.isLast
                                  ? 0
                                  : stepper.isSuccess
                                      ? 1
                                      : 0.1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 12.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextWidget(
                      stepper.title,
                      fontSize: 13.sp,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    TextWidget(
                      stepper.subTitle,
                      color: AppColors.veryLightGray,
                      fontSize: 11.sp,
                    ),
                  ],
                )
              ],
            ),
          ),
          stepper.icon
        ],
      ),
    );
  }
}
