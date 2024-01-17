import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:greep/presentation/driver_section/settings/maintenance_form_screen.dart';
import 'package:greep/presentation/driver_section/widgets/settings_home_item.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';

import '../../../utils/constants/app_colors.dart';

class UsefulLinks extends StatefulWidget {
  const UsefulLinks({Key? key}) : super(key: key);

  @override
  _UsefulLinksState createState() => _UsefulLinksState();
}

class _UsefulLinksState extends State<UsefulLinks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TextWidget("Useful Links",weight: FontWeight.bold,fontSize: 18.sp,),
        leading: const BackIcon(isArrow: true,),

      ),
      body: Container(
        padding: EdgeInsets.all(16.r,),
        child: Column(
          children: [
            SplashTap(
              onTap: () {
                Get.to(() => const MaintenanceFormScreen());
              },
              child: const SettingsHomeItem(
                  title: "Maintenance Form",
                  color: AppColors.black,
                  withIcon: false,
                  withTrail: true,
                  icon: "assets/icons/copy.svg"),
            ),
            SizedBox(
              height: 3.h,
            ),
            Row(
              children: [
                SizedBox(
                  width: 10.w,
                ),
                SvgPicture.asset(
                  "assets/icons/info.svg",
                  width: 10.sp,
                  height: 10.sp,color: AppColors.black,
                ),
                SizedBox(
                  width: 3.w,
                ),
                TextWidget(
                  "This is for ONLY Greep managed drivers",
                  fontSize: 10.sp,
                  fontStyle: FontStyle.italic,
                  color: AppColors.black,
                )
              ],
            )
          ],

        ),
      ),
    );
  }
}
