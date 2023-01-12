import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' as g;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:greep/Commons/colors.dart';
import 'package:greep/application/driver/drivers_cubit.dart';
import 'package:greep/application/location/driver_location_status_cubit.dart';
import 'package:greep/application/location/location.dart';
import 'package:greep/application/location/location_cubit.dart';
import 'package:greep/application/location/location_state.dart';
import 'package:greep/application/user/user_cubit.dart';
import 'package:greep/application/user/user_util.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/direction/direction_client.dart';
import 'package:greep/domain/direction/directions.dart';
import 'package:greep/domain/user/model/driver_location_status.dart';
import 'package:greep/domain/user/model/ride_status.dart';
import 'package:greep/ioc.dart';
import 'package:greep/presentation/driver_section/nav_pages/settings/account/view_profile.dart';
import 'package:greep/presentation/widgets/driver_selector_widget.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';
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

  RideStatus rideStatus = RideStatus.ended;

  double defaultLat = 9.064246972613308;
  double defaultLong = 7.424030426684654;

  String? userId;

  Directions? directions;

  Marker? currentLocationMarker;

  Marker? gotTripMarker;

  Marker? startTripMarker;

  Marker? endTripMarker;

  @override
  void initState() {
    driverLocationStatusCubit = getIt();
    super.initState();
  }

  void calculateDistance(DriverLocation driverLocation) async {
    List<Location> wayPoints = [];

    if (driverLocation.startDirection != null) {
      wayPoints.add(driverLocation.startDirection!.location);
    }

    if (driverLocation.endDirection != null) {
      wayPoints.add(driverLocation.endDirection!.location);
    }

    var currLocation = Location(
      longitude: double.tryParse(driverLocation.longitude) ?? 0,
      latitude: double.tryParse(driverLocation.latitude) ?? 0,
    );
    var directions = await DirectionsClient.instance.getDirections(
        origin: driverLocation.gotDirection?.location ??
            driverLocation.startDirection?.location ??
            driverLocation.endDirection?.location ??
            currLocation,
        destination: currLocation,
        waypoints: wayPoints);
    this.directions = directions!;
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
                  driverLocationStatusCubit
                      .checkOnlineStatus(userId ?? getUser().id);

                  setState(() {});
                }
              },
              builder: (context, driverState) {
                return BlocProvider.value(
                  value: driverLocationStatusCubit,
                  child: BlocConsumer<DriverLocationStatusCubit,
                      DriverLocationStatusState>(
                    listener: (context, locationState) async {
                      if (locationState is DriverLocationStatusStateFetched) {
                        // print("driver location found ${locationState.status}");
                        rideStatus = locationState.status.rideStatus;
                        var mapController = await _controller.future;
                        currentLocationMarker = Marker(
                            markerId: const MarkerId("Driver"),
                            position: LatLng(
                              double.parse(locationState.status.latitude),
                              double.parse(locationState.status.longitude),
                            ),
                            infoWindow: const InfoWindow(
                              title: "Driver",
                            ),
                            icon: await BitmapDescriptor.fromAssetImage(
                                const ImageConfiguration(),
                                "assets/icons/map_pin_${Platform.isIOS ? "1x" : "2x"}.png"));
                        // print("Update current location marker");

                        if (locationState.status.gotDirection != null) {
                          gotTripMarker = Marker(
                            markerId: const MarkerId("Got Trip"),
                            position: LatLng(
                              locationState
                                      .status.gotDirection?.location.latitude ??
                                  0,
                              locationState.status.startDirection?.location
                                      .longitude ??
                                  0,
                            ),
                            infoWindow: const InfoWindow(
                              title: "Got Trip",
                            ),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueBlue,
                            ),
                          );
                        }
                        if (locationState.status.startDirection != null) {
                          startTripMarker = Marker(
                            markerId: const MarkerId("Start Trip"),
                            position: LatLng(
                              locationState.status.startDirection?.location
                                      .latitude ??
                                  0,
                              locationState.status.startDirection?.location
                                      .longitude ??
                                  0,
                            ),
                            infoWindow: const InfoWindow(
                              title: "Start Trip",
                            ),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueGreen,
                            ),
                          );
                        }
                        if (locationState.status.endDirection != null) {
                          endTripMarker = Marker(
                            markerId: const MarkerId("End Trip"),
                            position: LatLng(
                              locationState
                                      .status.endDirection?.location.latitude ??
                                  0,
                              locationState.status.endDirection?.location
                                      .longitude ??
                                  0,
                            ),
                            infoWindow: const InfoWindow(
                              title: "End Trip",
                            ),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueRed,
                            ),
                          );
                        }

                        setState(() {});

                        calculateDistance(locationState.status);

                        if (double.parse(locationState.status.longitude) == 0 ||
                            double.parse(locationState.status.latitude) == 0) {
                          mapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              const CameraPosition(
                                target: LatLng(
                                    9.570340603589216, 7.806149434951432),
                                zoom: 5,
                              ),
                            ),
                          );
                        } else {
                          mapController
                              .animateCamera(CameraUpdate.newLatLngZoom(
                                  LatLng(
                                    currentLocationMarker!.position.latitude,
                                    currentLocationMarker!.position.longitude,
                                  ),
                                  15));
                        }
                        setState(() {});
                      }
                    },
                    builder: (context, locationState) {
                      // print(locationState);
                      Set<Marker> markers = {};
                      if (currentLocationMarker != null && userId != getUser().id) {
                        markers.add(currentLocationMarker!);
                      }
                      if (gotTripMarker != null) {
                        markers.add(gotTripMarker!);
                      }
                      if (startTripMarker != null) {
                        markers.add(startTripMarker!);
                      }
                      if (endTripMarker != null) {
                        markers.add(endTripMarker!);
                      }
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
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: GoogleMap(
                                      myLocationEnabled: userId == getUser().id,
                                      compassEnabled: true,
                                      tiltGesturesEnabled: false,
                                      zoomControlsEnabled: false,
                                      mapType: MapType.normal,
                                      initialCameraPosition: locationState
                                              is DriverLocationStatusStateFetched
                                          ? CameraPosition(
                                              target: LatLng(
                                                double.parse(locationState
                                                    .status.latitude),
                                                double.parse(locationState
                                                    .status.longitude),
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
                                      polylines: {
                                        if (directions != null)
                                          Polyline(
                                            polylineId:
                                                const PolylineId("Directions"),
                                            color: locationState
                                                    is DriverLocationStatusStateFetched
                                                ? locationState.status
                                                            .rideStatus ==
                                                        RideStatus.pending
                                                    ? AppColors.blue
                                                    : locationState.status
                                                                .rideStatus ==
                                                            RideStatus.ended
                                                        ? AppColors.red
                                                        : AppColors.green
                                                : AppColors.green,
                                            width:
                                                (kDefaultSpacing * 0.6).toInt(),
                                            points: directions!.polyPoints
                                                .map((e) => LatLng(
                                                    e.latitude, e.longitude))
                                                .toList(),
                                          ),
                                      },
                                      markers: markers,
                                    ),
                                  ),
                                  Positioned(
                                      top: 10.h,
                                      left: 10.w,
                                      child: Container(
                                        padding: const EdgeInsets.all(
                                          kDefaultSpacing * 0.5,
                                        ),
                                        decoration: BoxDecoration(
                                            color: kWhiteColor,
                                            borderRadius: BorderRadius.circular(
                                                kDefaultSpacing * 0.75)),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 14.r,
                                              width: 14.r,
                                              decoration: BoxDecoration(
                                                  color: rideStatus ==
                                                          RideStatus.pending
                                                      ? AppColors.blue
                                                      : rideStatus ==
                                                              RideStatus.ended
                                                          ? AppColors.red
                                                          : AppColors.green,
                                                  shape: BoxShape.circle),
                                            ),
                                            kHorizontalSpaceSmall,
                                            TextWidget(rideStatus ==
                                                    RideStatus.pending
                                                ? "Got a trip"
                                                : rideStatus == RideStatus.ended
                                                    ? "Ended trip"
                                                    : "Start trip")
                                          ],
                                        ),
                                      )),
                                  BlocBuilder<LocationCubit, LocationState>(
                                    bloc: getIt<LocationCubit>(),
                                    builder: (context, locState) {
                                     if (locState is LocationStateOff) {

                                       return Positioned.fill(
                                          child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(
                                            0.5,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: IntrinsicHeight(
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 0.1.sw),
                                            padding: const EdgeInsets.all(
                                                kDefaultSpacing),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        kDefaultSpacing)),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const TextWidget(
                                                  "Location Services is Disabled",
                                                  color: AppColors.red,
                                                  fontSize: 27,
                                                  weight: FontWeight.bold,
                                                ),
                                                kVerticalSpaceRegular,
                                                const TextWidget(
                                                  "Google map needs access to your location. Please turn on you location in your device settings.",
                                                  weight: FontWeight.w500,
                                                  fontSize: 20,
                                                ),
                                                kVerticalSpaceRegular,
                                                const Divider(
                                                  color: AppColors.lightBlue,
                                                ),
                                                GestureDetector(
                                                  onTap: (){
                                                    Geolocator.openLocationSettings();

                                                  },
                                                  child: Column(

                                                    children: [
                                                      kVerticalSpaceSmall,
                                                      const TextWidget(
                                                        "Enable Location Access",
                                                        color: AppColors.blue,
                                                        weight: FontWeight.w600,
                                                      ),
                                                      kVerticalSpaceSmall,
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                       );
                                     }

                                     return Container();

                                    },
                                  )
                                ],
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
