import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:greep/Commons/colors.dart';
import 'package:greep/application/driver/drivers_cubit.dart';
import 'package:greep/application/user/user_cubit.dart';
import 'package:greep/application/user/utils/get_current_user.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/presentation/driver_section/nav_pages/settings/account/view_profile.dart';
import 'package:greep/presentation/widgets/driver_selector_widget.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_styles.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart' as g;

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _grandCubana = CameraPosition(
    target: LatLng(
      9.064246972613308,
      7.424030426684654,
    ),
    zoom: 10,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlackColor,
      body: SafeArea(
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, userState) {
            return BlocBuilder<DriversCubit, DriversState>(
              builder: (context, driverState) {
                return Column(
                  children: [
                    Container(
                      // height: driverState is DriversStateDriver ? 190.h : ((driverState is DriversStateFetched &&
                      //     driverState.selectedUser == currentUser()) ? 245.h: 180.h),
                      width: 1.sw,
                      padding: EdgeInsets.symmetric(
                        horizontal: kDefaultSpacing.w,
                        vertical: (kDefaultSpacing * 0.5).h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          kVerticalSpaceSmall,
                          const DriverSelectorRow(
                            withWhiteText: true,
                          ),
                          if (driverState is DriversStateDriver?)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                kVerticalSpaceRegular,
                                ListTile(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  title: TextWidget(
                                    DateFormat(
                                            "${DateFormat.ABBR_WEEKDAY}, ${DateFormat.ABBR_MONTH} ${DateFormat.DAY}")
                                        .format(DateTime.now()),
                                    style: AppTextStyles.whiteSize12,
                                  ),
                                  subtitle: TextWidget(
                                      "Hi ${userState is UserStateFetched ? userState.user.firstName : "!"}",
                                      style: kBoldWhiteTextStyle),
                                  trailing: SplashTap(
                                    onTap: () {
                                      g.Get.to(
                                        () => const ProfileView(),
                                        transition: g.Transition.fadeIn,
                                      );
                                    },
                                    child: CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              userState is UserStateFetched
                                                  ? userState.user.photoUrl
                                                  : ""),
                                      child: const TextWidget(""),
                                    ),
                                  ),
                                ),
                                kVerticalSpaceRegular,
                              ],
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(color: kWhiteColor),
                        child: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: _grandCubana,
                          onMapCreated: (c) {
                            _controller.complete(c);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
