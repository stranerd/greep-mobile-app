import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/presentation/widgets/text_widget.dart';

class DriverItemWidget extends StatelessWidget {
  final String name;
  final String asset;
  final bool isSelected;
  final Color textColor;

  const DriverItemWidget(
      {Key? key,
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
           SizedBox(
            height: 4.0.h,
          ),
          TextWidget(
            name,
            style: isSelected
                ? kBoldTextStyle2.copyWith(
              color: textColor,
              fontSize: 13
            )
                : kDefaultTextStyle.copyWith(fontSize: 12,color: textColor),
          ),
        ],
      ),
    );
  }
}
