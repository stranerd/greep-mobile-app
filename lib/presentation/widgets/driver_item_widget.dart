import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grip/commons/ui_helpers.dart';

class DriverItemWidget extends StatelessWidget {
  final String name;
  final String asset;
  final bool isSelected;

  const DriverItemWidget(
      {Key? key,
      required this.name,
      required this.isSelected,
      required this.asset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultSpacing * 0.25),
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(asset),
                    fit: BoxFit.cover),
                shape: BoxShape.circle,
                // borderRadius: isSelected ? BorderRadius.circular(kDefaultSpacing): null,
                border: isSelected ? Border.all(width: 2) : null),
          ),
          const SizedBox(
            height: 4.0,
          ),
          Text(
            name,
            style: isSelected
                ? kBoldTextStyle2.copyWith()
                : kDefaultTextStyle.copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
