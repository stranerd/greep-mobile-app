import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:greep/commons/Utils/utils.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/driver_section/widgets/settings_home_item.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../utils/constants/app_styles.dart';
import 'privacy_policy.dart';
import 'terms_and_conditions.dart';

class AboutHome extends StatefulWidget {
  const AboutHome({Key? key}) : super(key: key);

  @override
  State<AboutHome> createState() => _AboutHomeState();
}

class _AboutHomeState extends State<AboutHome> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackIcon(isArrow: true,),
        title: TextWidget(
          "About",
          fontSize: 16.sp,
          weight: FontWeight.bold,

        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
          child: Column(
            children: [
              SplashTap(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicy(),
                    ),
                  );
                },
                child: const SettingsHomeItem(
                    title: "Privacy policy",
                    withIcon: false,
                    icon: "assets/icons/privacy.svg"),
              ),
              SizedBox(height: 12.h,),
              SplashTap(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const TermsAndConditions(),
                    ),
                  );
                },
                child: const SettingsHomeItem(
                    title: "Terms and conditions",
                    withIcon: false,

                    icon: "assets/icons/terms.svg"),
              ),
              SizedBox(height: 32.h,),
              // Center(
              //   child: Image.asset(
              //     "assets/images/about_greep.png",
              //     scale: 2,
              //   ),
              // ),
              // kVerticalSpaceRegular,
              // FutureBuilder<PackageInfo>(
              //     future: PackageInfo.fromPlatform(),
              //     builder: (c,s){
              //       if (s.hasData){
              //   return TextWidget("v${s.data?.version} (${s.data?.buildNumber})");}
              //       return const SizedBox();
              // }),
              Align(
                  alignment: Alignment.centerLeft,

                  child: TextWidget("Socials",fontSize: 16.sp,weight: FontWeight.bold,)),
              SizedBox(height: 10.h,),
              SplashTap(
                onTap: () {
                  Utils.launchURL("https://www.facebook.com/profile.php?id=100082853892890");

                },
                child: const SettingsHomeItem(
                    title: "Facebook ", icon: "assets/icons/facebook.svg"),
              ),
              kVerticalSpaceSmall,
              SplashTap(
                onTap: () {

                },
                child: const SettingsHomeItem(
                    title: "Instagram",
                    icon: "assets/icons/instagram.svg"),
              ),
              SizedBox(height: 8.h),
              SplashTap(
                onTap: () {
                  // Get.to(() => const ContactUs());
                },
                child: const SettingsHomeItem(
                    title: "WhatsApp",
                    icon: "assets/icons/whatsapp.svg"),
              ),
              SizedBox(height: 12.h,),
              SplashTap(
                onTap: () {
                  Utils.launchURL("https://www.twitter.com/AppGreep");

                  // Get.to(() => const ContactUs());
                },
                child: const SettingsHomeItem(
                    title: "X (Twitter)",
                    icon: "assets/icons/x.svg"),
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
