import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greep/utils/constants/app_colors.dart';

class ProgressIndicatorContainer extends StatelessWidget {
  const ProgressIndicatorContainer({
    Key? key,
    required this.progress,
    required this.child,
    this.height,
  }) : super(key: key);
  final double progress;
  final Widget child;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        return Container(
          height: height ?? 40.h,
          width: width,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            borderRadius: BorderRadius.circular(6.r)
          ),
          child: Stack(
            children: [
              Container(
                width: width * progress,
                decoration: BoxDecoration(
              color: AppColors.coinGold
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  alignment: Alignment.center,
                  child: child,
                ),
              )
            ],
          ),
        );
      }
    );
  }
}
