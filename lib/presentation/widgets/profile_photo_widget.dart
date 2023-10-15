import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class ProfilePhotoWidget extends StatelessWidget {
  final String url;
  final double radius;
  const ProfilePhotoWidget({Key? key, required this.url, this.radius = 16}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: AppColors.lightGray,
      backgroundImage:
      CachedNetworkImageProvider(url),
      radius: radius.r,
      child:
      const TextWidget("",),
    );
  }
}
