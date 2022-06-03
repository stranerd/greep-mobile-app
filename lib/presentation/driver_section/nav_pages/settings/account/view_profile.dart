import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/app_styles.dart';
import '../widgets/account_item_card.dart';
import 'edit_profile.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 16,
          ),
        ),
        title: Text(
          "Account",
          style: AppTextStyles.blackSizeBold14,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfile(),
                ),
              );
            },
            icon: SvgPicture.asset("assets/icons/edit-icon.svg"),
          ),
        ],
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: SafeArea(
          child: Column(
            children: const [
              AccountItemCard(title: "Username", subtitle: "Wizzy"),
              SizedBox(height: 8),
              AccountItemCard(title: "Full name", subtitle: "Wizard Wilson"),
              SizedBox(height: 8),
              AccountItemCard(title: "Phone", subtitle: "+357 22 661656"),
              SizedBox(height: 8),
              AccountItemCard(
                  title: "Email", subtitle: "wizzywilson@gmail.com"),
              SizedBox(height: 8),
              AccountItemCard(title: "Driver type", subtitle: "Supervised"),
              SizedBox(height: 8),
              AccountItemCard(title: "Manager", subtitle: "Godwin Nwachukwu"),
            ],
          ),
        ),
      ),
    );
  }
}
