import 'package:flutter/material.dart';

import '../../../../utils/constants/app_styles.dart';
import '../../../driver_section/nav_pages/settings/account/view_profile.dart';
import '../../../driver_section/widgets/settings_home_item.dart';

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
              const SettingsHomeItem(
                  title: "Drivers", icon: "assets/icons/local_taxi.svg"),
              const SizedBox(height: 8),
              const SettingsHomeItem(
                  title: "Total Income",
                  icon: "assets/icons/monetization_on.svg"),
              const SizedBox(height: 8),
              const SettingsHomeItem(
                  title: "Payment", icon: "assets/icons/payment.svg"),
              const SizedBox(height: 8),
              const SettingsHomeItem(
                  title: "About", icon: "assets/icons/info.svg"),
              const SizedBox(height: 8),
              const SettingsHomeItem(
                  title: "Contact Us", icon: "assets/icons/headphones.svg"),
            ],
          ),
        ),
      ),
    );
  }
}
