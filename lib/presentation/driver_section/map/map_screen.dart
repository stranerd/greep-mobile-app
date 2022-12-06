import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' as g;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:greep/Commons/colors.dart';
import 'package:greep/application/driver/drivers_cubit.dart';
import 'package:greep/application/location/driver_location_status_cubit.dart';
import 'package:greep/application/user/user_cubit.dart';
import 'package:greep/application/user/user_util.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/ioc.dart';
import 'package:greep/presentation/driver_section/nav_pages/settings/account/view_profile.dart';
import 'package:greep/presentation/widgets/driver_selector_widget.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_styles.dart';
import 'package:intl/intl.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  late DriverLocationStatusCubit driverLocationStatusCubit;

  // static const CameraPosition _grandCubana = CameraPosition(
  //   target: LatLng(
  //     9.064246972613308,
  //     7.424030426684654,
  //   ),
  //   zoom: 15,
  // );

  String? userId;

  @override
  void initState() {
    driverLocationStatusCubit = getIt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlackColor,
      body: SafeArea(
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, userState) {
            return BlocConsumer<DriversCubit, DriversState>(
              listener: (context, driverState) async {
                if (driverState is DriversStateFetched) {
                  userId = driverState.selectedUser.id;

                  setState(() {});
                  print("userId $userId");
                }
              },
              builder: (context, driverState) {
                return BlocProvider.value(
                  value: driverLocationStatusCubit
                    ..checkOnlineStatus(userId ?? getUser().id),
                  child: BlocConsumer<DriverLocationStatusCubit,
                      DriverLocationStatusState>(
                    listener: (context, locationState) async {
                      if (locationState is DriverLocationStatusStateFetched) {
                        print(locationState);
                        var mapController = await _controller.future;
                        if (double.parse(locationState.status.longitude) == 0 ||
                            double.parse(locationState.status.latitude) == 0) {
                          mapController.animateCamera(
                              CameraUpdate.newCameraPosition(
                                  const CameraPosition(
                                      target: LatLng(
                                          9.570340603589216, 7.806149434951432),
                                      zoom: 5,),),);
                        } else {
                          mapController.animateCamera(CameraUpdate.newCameraPosition(
                            CameraPosition(target: LatLng(
                              double.parse(locationState.status.latitude),
                              double.parse(locationState.status.longitude),
                            ),zoom: 15)

                          ));
                        }
                      }
                    },
                    builder: (context, locationState) {
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      kVerticalSpaceRegular,
                                      ListTile(
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                0, 0, 0, 0),
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
                                                    userState
                                                            is UserStateFetched
                                                        ? userState
                                                            .user.photoUrl
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
                              decoration:
                                  const BoxDecoration(color: kWhiteColor),
                              child: GoogleMap(
                                myLocationEnabled: true,
                                compassEnabled: true,
                                tiltGesturesEnabled: false,
                                zoomControlsEnabled: false,
                                mapType: MapType.normal,
                                initialCameraPosition: locationState
                                        is DriverLocationStatusStateFetched
                                    ? CameraPosition(
                                        target: LatLng(
                                          double.parse(
                                              locationState.status.latitude),
                                          double.parse(
                                              locationState.status.longitude),
                                        ),
                                        zoom: 15,
                                      )
                                    : const CameraPosition(
                                        target: LatLng(
                                          9.064246972613308,
                                          7.424030426684654,
                                        ),
                                        zoom: 15,
                                      ),
                                onMapCreated: (c) {
                                  _controller.complete(c);
                                },
                                markers: {
                                  Marker(
                                    markerId: const MarkerId("driver"),
                                    position: const LatLng(
                                      9.064246972613308,
                                      7.424030426684654,
                                    ),
                                    infoWindow: const InfoWindow(
                                      title: "driver",
                                    ),
                                    icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueBlue,
                                    ),
                                  )
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
