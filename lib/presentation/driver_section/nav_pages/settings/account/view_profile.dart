import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:greep/application/auth/AuthenticationCubit.dart';
import 'package:greep/application/user/utils/get_current_user.dart';

import 'package:greep/application/driver/drivers_cubit.dart';
import 'package:greep/application/user/user_cubit.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/scaffold_messenger_service.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/user/UserService.dart';
import 'package:greep/domain/user/model/User.dart';
import 'package:greep/presentation/driver_section/widgets/settings_home_item.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';

import '../../../../../utils/constants/app_styles.dart';
import '../widgets/account_item_card.dart';
import 'edit_profile.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with ScaffoldMessengerService {
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
          leading: const BackIcon(isArrow:true,),


          title: TextWidget(
            "Account",
            fontSize: 18.sp,
            weight: FontWeight.bold,
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
              icon: SvgPicture.asset("assets/icons/edit.svg"),
            ),
            SizedBox(width: 8.w,),
          ],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                kVerticalSpaceRegular,
                Align(
                  alignment: Alignment.centerLeft,
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      user.photoUrl,
                    ),
                    radius: 50,
                  ),
                ),
                kVerticalSpaceRegular,
                AccountItemCard(
                    title: "Driver Id", subtitle: user.id, isSelectable: true),
                kVerticalSpaceSmall,
                AccountItemCard(title: "First name", subtitle: user.firstName),
                kVerticalSpaceRegular,
                AccountItemCard(title: "Last name", subtitle: user.lastName),
                kVerticalSpaceRegular,
                AccountItemCard(title: "Email", subtitle: user.email),
                kVerticalSpaceRegular,
                BlocBuilder<DriversCubit, DriversState>(
                  builder: (context, state) {
                    String driverType = state is DriversStateManager
                        ? "Manager"
                        : currentUser().hasManager
                            ? "Supervised"
                            : "Independent";

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AccountItemCard(
                            title: "Driver type", subtitle: driverType),
                        kVerticalSpaceRegular,
                        if (user.hasManager && user.managerName != null)
                          AccountItemCard(
                              title: "Manager", subtitle: user.managerName!),
                      ],
                    );
                  },
                ),
                kVerticalSpaceLarge,
                kVerticalSpaceRegular,
                Align(
                  alignment: Alignment.centerLeft,
                  child: SplashTap(
                    onTap: () {
                      deleteAccount();
                    },
                    child: const SettingsHomeItem(
                      title: "Delete account",
                      icon: "assets/icons/trash.svg",
                      color: AppColors.red,
                      withTrail: false,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<void> deleteAccount() async {
    bool shouldDelete = await showDialog<bool?>(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return Dialog(
              child: Container(
                padding: const EdgeInsets.all(kDefaultSpacing),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Are you sure you want to delete your account? This action is irreversible",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: kDefaultTextStyle.copyWith(height: 1.35),
                    ),
                    kVerticalSpaceRegular,

                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    backgroundColor: kPrimaryColor,
                                    minimumSize: Size(150, 50)),
                                onPressed: () {
                                  Get.back(result: false);
                                },
                                child: Text(
                                  "Cancel",
                                  style: kBoldTextStyle.copyWith(
                                      color: kWhiteColor),
                                )),
                          ),
                          kHorizontalSpaceSmall,
                          Flexible(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  backgroundColor: AppColors.red,
                                  minimumSize: Size(150, 50)),
                              child: Text(
                                "Delete",
                                style: kWhiteTextStyle,
                              ),
                              onPressed: () {
                                Get.back(result: true);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        }) ??
        false;

    if (shouldDelete) {
      var response =
      await GetIt.instance<UserService>().deleteUser();
      if (response.isError) {
        error = response.errorMessage ??
            "An error occurred deleting. Try again";
      } else {
        success = "Account deletion successful";
        GetIt.instance<AuthenticationCubit>().signout();
      }
    }
  }
}
