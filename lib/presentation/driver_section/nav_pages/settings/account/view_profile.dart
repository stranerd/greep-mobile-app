import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/user/utils/get_current_user.dart';

import 'package:grip/application/driver/drivers_cubit.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/commons/ui_helpers.dart';
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
    user = currentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserStateFetched) {
          setState(() {
            user = state.user;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
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
          centerTitle: false,
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                kVerticalSpaceRegular,
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                  radius: 50,
                ),
                kVerticalSpaceRegular,
                AccountItemCard(
                    title: "Driver Id", subtitle: user.id, isSelectable: true),
                kVerticalSpaceSmall,
                AccountItemCard(title: "First name", subtitle: user.firstName),
                SizedBox(height: 8),
                AccountItemCard(title: "Last name", subtitle: user.lastName),
                SizedBox(height: 8),
                AccountItemCard(title: "Email", subtitle: user.email),
                SizedBox(height: 8),
                BlocBuilder<DriversCubit, DriversState>(
                  builder: (context, state) {
                    String driverType = state is DriversStateManager
                        ? "Manager"
                        : currentUser().hasManager
                            ? "Supervised"
                            : "Independent";

                    return AccountItemCard(
                        title: "Driver type", subtitle: driverType);
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    AccountItemCard(title: "Manager", subtitle: user.fullName),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
