import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/driver_section/widgets/settings_home_item.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:upgrader/upgrader.dart';

import '../../../../../utils/constants/app_styles.dart';
import 'privacy_policy.dart';
import 'terms_and_conditions.dart';

class AboutHome extends StatelessWidget {
  const AboutHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios, size: 16)),
        title: Text(
          "About",
          style: AppTextStyles.blackSizeBold14,
        ),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            children: [
              kVerticalSpaceLarge,
              Center(
                child: Image.asset(
                  "assets/images/about_greep.png",
                  scale: 2,
                ),
              ),
              kVerticalSpaceRegular,
              FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (c,s){
                    if (s.hasData){
                return TextWidget("v${s.data?.version} (${s.data?.buildNumber})");}
                    return const SizedBox();
              }),
              kVerticalSpaceLarge,
              SplashTap(
                onTap: () {},
                child: const SettingsHomeItem(
                    title: "Like us on Facebook ", icon: "assets/icons/fb.svg"),
              ),
              kVerticalSpaceSmall,
              SplashTap(
                onTap: () {
                  // Get.to(() => const AboutHome());
                },
                child: const SettingsHomeItem(
                    title: "Follow us on Twitter",
                    icon: "assets/icons/twitter.svg"),
              ),
              SizedBox(height: 8.h),
              SplashTap(
                onTap: () {
                  // Get.to(() => const ContactUs());
                },
                child: const SettingsHomeItem(
                    title: "Join us on Telegram",
                    icon: "assets/icons/telegram.svg"),
              ),
              kVerticalSpaceLarge,
              kVerticalSpaceLarge,

              const Divider(),
              ListTile(
                onTap: (){

                },
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: SvgPicture.asset("assets/icons/updates.svg"),
                title: const TextWidget(
                  "Check for updates",
                ),
                subtitle: TextWidget( Upgrader().isUpdateAvailable() ? "You have a new update":"Your current version is up to date."),
              )
            ],
          ),
        ),
      ),
    );
  }
}
