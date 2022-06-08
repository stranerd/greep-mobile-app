import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/domain/user/model/User.dart';

import '../../../../../utils/constants/app_styles.dart';
import '../widgets/account_item_card.dart';
import 'edit_profile.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  late User user;

  @override
  void initState() {
    user = GetIt.I<UserCubit>().user;
    super.initState();
  }
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
            children:  [
              AccountItemCard(title: "First name", subtitle: user.firstName),
              SizedBox(height: 8),
              AccountItemCard(title: "Last name", subtitle: user.lastName),
              SizedBox(height: 8),
              AccountItemCard(
                  title: "Email", subtitle: user.email),
              SizedBox(height: 8),
              AccountItemCard(title: "Driver type", subtitle: "Supervised"),
              SizedBox(height: 8),
              AccountItemCard(title: "Manager", subtitle: user.fullName),
            ],
          ),
        ),
      ),
    );
  }
}
