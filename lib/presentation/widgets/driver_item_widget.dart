import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/widgets/driver_location_status_widget.dart';
import 'package:greep/presentation/widgets/text_widget.dart';

class DriverItemWidget extends StatelessWidget {
  final String name;
  final String id;
  final String asset;
  final bool isSelected;
  final Color textColor;

  const DriverItemWidget(
      {Key? key,
        required this.id,
      required this.name,
      required this.isSelected,
        this.textColor = kBlackColor,
      required this.asset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: (kDefaultSpacing * 0.25).w),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 55.h,
                width: 55.w,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(asset),
                        fit: BoxFit.cover),
                    shape: BoxShape.circle,
                    // borderRadius: isSelected ? BorderRadius.circular(kDefaultSpacing): null,
                    border: isSelected ? Border.all(width: 2.w,color: textColor == kBlackColor ? kBlackColor : kGreenColor) : null),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: DriverLocationStatusWidget(
                  userId: id,
                ),
              ),
            ],
          ),
           SizedBox(
            height: 4.0.h,
          ),
          TextWidget(
            name,
            style: isSelected
                ? kBoldTextStyle2.copyWith(
              color: textColor,
              fontSize: 18.sp
            )
                : kDefaultTextStyle.copyWith(fontSize: 16.sp,color: textColor),
          ),
        ],
      ),
    );
  }
}
