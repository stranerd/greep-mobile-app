import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/box_shadow_container.dart';
import 'package:greep/presentation/widgets/progress_indicator_container.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackIcon(isArrow: true,),
        centerTitle: true,
        title: TextWidget("Leaderboard",fontSize: 18.sp,weight: FontWeight.bold,),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.r),
        shrinkWrap: true,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget("Your level",fontSize: 16.sp,weight: FontWeight.bold,),
              Row(
                children: [
                  SvgPicture.asset("assets/icons/star-gold.svg",width: 12.r,height: 12.r,),
                  SizedBox(width: 4.w,),
                  TextWidget("Recruit",fontSize: 16.sp,weight: FontWeight.bold,color: AppColors.coinGold,),
                  SizedBox(width: 4.w,),

                  SvgPicture.asset("assets/icons/star-gold.svg",width: 12.r,height: 12.r,),

                ],
              )
            ],
          ),
          SizedBox(height: 16.h,),
          BoxShadowContainer(child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget("Next level",color: AppColors.veryLightGray,),
                  TextWidget("Private",color: AppColors.veryLightGray,),

                ],
              ),
              SizedBox(height: 8.h,),
              ProgressIndicatorContainer(progress: 0.6, child: Container(),height: 12.h,),
            ],
          ))
        ],
      ),
    );
  }
}
