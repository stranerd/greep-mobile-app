import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/ui_helpers.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: kDefaultSpacing * 0.25),
      child: Column(
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(asset),
                    fit: BoxFit.cover),
                shape: BoxShape.circle,
                // borderRadius: isSelected ? BorderRadius.circular(kDefaultSpacing): null,
                border: isSelected ? Border.all(width: 2,color: textColor == kBlackColor ? kBlackColor : kGreenColor) : null),
          ),
          const SizedBox(
            height: 4.0,
          ),
          Text(
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
