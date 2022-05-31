import 'package:flutter/material.dart';

import '../../../../utils/constants/app_styles.dart';
import '../../widgets/settings_home_item.dart';
import 'about/about_home.dart';
import 'account/view_profile.dart';
import 'commission/commission.dart';
import 'contact_us.dart';

class SettingsHome extends StatelessWidget {
  const SettingsHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Settings",
          style: AppTextStyles.blackSizeBold14,
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: SafeArea(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileView(),
                    ),
                  );
                },
                child: const SettingsHomeItem(
                    title: "Account", icon: "assets/icons/person.svg"),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CommissionHome(),
                    ),
                  );
                },
                child: const SettingsHomeItem(
                    title: "Commission",
                    icon: "assets/icons/monetization_on.svg"),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutHome(),
                    ),
                  );
                },
                child: const SettingsHomeItem(
                    title: "About", icon: "assets/icons/info.svg"),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactUs(),
                    ),
                  );
                },
                child: const SettingsHomeItem(
                    title: "Contact Us", icon: "assets/icons/headphones.svg"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
