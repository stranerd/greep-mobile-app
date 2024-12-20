import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/application/geocoder/geocoder_cubit.dart';
import 'package:greep/application/geocoder/geocoder_state.dart';
import 'package:greep/application/transactions/trip_direction_builder_cubit.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/user/model/ride_status.dart';
import 'package:greep/ioc.dart';
import 'package:greep/presentation/driver_section/records/record_trip.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class TripDirectionsScreen extends StatefulWidget {
  const TripDirectionsScreen({Key? key}) : super(key: key);

  @override
  _TripDirectionsScreenState createState() => _TripDirectionsScreenState();
}

class _TripDirectionsScreenState extends State<TripDirectionsScreen> {
  late TripDirectionBuilderCubit tripDirectionBuilderCubit;

  int currStep = 0;

  @override
  void initState() {
    tripDirectionBuilderCubit = getIt();
    if (tripDirectionBuilderCubit.state is TripDirectionBuilderStateEndTrip) {
      isGotTrip = true;
      isStartTrip = true;
      isEndTrip = true;
    }
    if (tripDirectionBuilderCubit.state is TripDirectionBuilderStateStartTrip) {
      {
        isGotTrip = true;
        isStartTrip = true;
      }
    }
    if (tripDirectionBuilderCubit.state is TripDirectionBuilderStateGotTrip) {
      {
        isGotTrip = true;
      }
    }
    super.initState();
  }

  bool isGotTrip = false;
  bool isStartTrip = false;
  bool isEndTrip = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripDirectionBuilderCubit, TripDirectionBuilderState>(
      listener: (context, state) {
        if (state is TripDirectionBuilderStateGotTrip) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            // success = "Got trip";
            setState(() {
              isGotTrip = true;
              isStartTrip = false;
              isEndTrip = false;
            });
          });
        }

        if (state is TripDirectionBuilderStateStartTrip) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            // success = "Started Trip!";
            setState(() {
              isStartTrip = true;
            });
          });
        }

        if (state is TripDirectionBuilderStateEndTrip) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            // success = "Ended Trip!";
            setState(() {
              isEndTrip = true;
            });
          });
        }
      },
      builder: (context, state) {
        return Container(
          height: 0.9.sh,
          margin: const EdgeInsets.symmetric(horizontal: kDefaultSpacing * 2),
          decoration: const BoxDecoration(),
          child: LayoutBuilder(builder: (context, constraints) {
            return Container(
              decoration: const BoxDecoration(),
              width: constraints.maxWidth,
              child: ListView(
                children: [
                  kVerticalSpaceMedium,
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (state is TripDirectionBuilderStateStartTrip)
                          Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                                color: AppColors.red, shape: BoxShape.circle),
                          ),
                        kHorizontalSpaceSmall,
                        if (state is TripDirectionBuilderStateStartTrip)
                          Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                                color: AppColors.red, shape: BoxShape.circle),
                          ),
                        kHorizontalSpaceSmall,
                        TextWidget(
                          state is TripDirectionBuilderStateStartTrip
                              ? "Recording ..."
                              : state is TripDirectionBuilderStateEndTrip
                                  ? "Trip Ended !"
                                  : "",
                          fontSize: 25,
                          weight: FontWeight.bold,
                          color: state is TripDirectionBuilderStateStartTrip
                              ? AppColors.red
                              : AppColors.green,
                        ),
                      ],
                    ),
                  ),
                  kVerticalSpaceMedium,
                  kVerticalSpaceMedium,
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: kDefaultSpacing, horizontal: kDefaultSpacing),
                    decoration: const BoxDecoration(
                      color: AppColors.lightBlue,
                    ),
                    height: 450,
                    width: 330,
                    child: Stack(
                      children: [
                        Positioned(
                            left: 75,
                            top: 0,
                            child: Container(
                              height: 450 / 1.5,
                              width: 1,
                              color: Colors.grey,
                            )),
                        Positioned(
                          width: 330,
                          top: 0,
                          child: Container(
                            height: 450 / 3,
                            alignment: Alignment.topCenter,
                            decoration: const BoxDecoration(),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(),
                                  width: 60,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (state
                                          is TripDirectionBuilderStateEndTrip)
                                        const TextWidget(
                                          "Now",
                                          weight: FontWeight.bold,
                                        ),
                                      kVerticalSpaceSmall,
                                      if (isEndTrip)
                                        Builder(builder: (context) {
                                          var directionProgress =
                                              tripDirectionBuilderCubit
                                                      .directions[
                                                  RideStatus.ended]!;
                                          return TextWidget(
                                            DateFormat(DateFormat.HOUR24_MINUTE)
                                                .format(directionProgress.date),
                                            color: AppColors.veryLightGray,
                                          );
                                        }),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 30,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(
                                    kDefaultSpacing * 0.2,
                                  ),
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color:
                                        state is TripDirectionBuilderStateEndTrip ||
                                                isEndTrip
                                            ? kErrorColor
                                            : AppColors.lightBlack,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    "assets/icons/map_navigator.png",
                                    color: kWhiteColor,
                                    scale: 3.5,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: kDefaultSpacing * 0.5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const TextWidget("End Trip"),
                                        kVerticalSpaceSmall,
                                        state
                                                is TripDirectionBuilderStateEndTrip
                                            ? Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                    Builder(builder: (context) {
                                                      String address = state
                                                                  .directionProgress
                                                                  .location
                                                                  .address !=
                                                              null
                                                          ? state
                                                                      .directionProgress
                                                                      .location
                                                                      .address
                                                                      ?.isNotEmpty ??
                                                                  false
                                                              ? state
                                                                  .directionProgress
                                                                  .location
                                                                  .address!
                                                              : ""
                                                          : "";
                                                      if (address.isNotEmpty) {
                                                        return TextWidget(
                                                          address,
                                                          softWrap: true,
                                                          maxLines: 2,
                                                          fontSize: 15,
                                                          color: AppColors
                                                              .veryLightGray,
                                                        );
                                                      }
                                                      return BlocProvider.value(
                                                        value: getIt<
                                                            GeoCoderCubit>()
                                                          ..fetchAddressFromLongAndLat(
                                                              longitude: state
                                                                  .directionProgress
                                                                  .location
                                                                  .longitude,
                                                              latitude: state
                                                                  .directionProgress
                                                                  .location
                                                                  .latitude),
                                                        child: BlocBuilder<
                                                            GeoCoderCubit,
                                                            GeoCoderState>(
                                                          builder: (context,
                                                              geoState) {
                                                            return TextWidget(
                                                              geoState
                                                                      is GeoCoderStateFetched
                                                                  ? geoState
                                                                          .address
                                                                          .isEmpty
                                                                      ? 'Loading address...'
                                                                      : geoState
                                                                          .address
                                                                  : 'Loading address...',
                                                              softWrap: true,
                                                              maxLines: 2,
                                                              fontSize: 15,
                                                              color: AppColors
                                                                  .veryLightGray,
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    }),
                                                    kVerticalSpaceRegular,
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        TextWidget(
                                                          "${state.directionProgress.speed.toStringAsFixed(2).toString()} km/h",
                                                          fontSize: 14,
                                                        ),
                                                        kHorizontalSpaceSmall,
                                                        Container(
                                                          height: 5.r,
                                                          width: 5.r,
                                                          decoration:
                                                              const BoxDecoration(
                                                                  color: Colors
                                                                      .black,
                                                                  shape: BoxShape
                                                                      .circle),
                                                        ),
                                                        kHorizontalSpaceSmall,
                                                        TextWidget(
                                                          "${state.directionProgress.distance.toStringAsFixed(3).toString()} km",
                                                          fontSize: 14,
                                                        ),
                                                        kHorizontalSpaceSmall,
                                                        Container(
                                                          height: 5.r,
                                                          width: 5.r,
                                                          decoration:
                                                              const BoxDecoration(
                                                                  color: Colors
                                                                      .black,
                                                                  shape: BoxShape
                                                                      .circle),
                                                        ),
                                                        kHorizontalSpaceSmall,
                                                        Builder(
                                                            builder: (context) {
                                                          print(
                                                              "duration ${state.directionProgress.duration.inSeconds}");
                                                          return TextWidget(
                                                            timeago.format(
                                                                state
                                                                    .directionProgress
                                                                    .date
                                                                    .add(state
                                                                        .directionProgress
                                                                        .duration),
                                                                clock: state
                                                                    .directionProgress
                                                                    .date,
                                                                allowFromNow:
                                                                    true,
                                                                locale:
                                                                    'en_short'),
                                                            fontSize: 14,
                                                          );
                                                        }),
                                                      ],
                                                    )
                                                  ])
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          width: 330,
                          top: 450 / 3,
                          child: Container(
                            height: 450 / 3,
                            alignment: Alignment.topCenter,
                            decoration: const BoxDecoration(),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 60,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (state
                                          is TripDirectionBuilderStateStartTrip)
                                        const TextWidget(
                                          "Now",
                                          weight: FontWeight.bold,
                                        ),
                                      kVerticalSpaceSmall,
                                      if (isStartTrip)
                                        Builder(builder: (context) {
                                          var directionProgress =
                                              tripDirectionBuilderCubit
                                                      .directions[
                                                  RideStatus.inProgress]!;
                                          return TextWidget(
                                            DateFormat(DateFormat.HOUR24_MINUTE)
                                                .format(directionProgress.date),
                                            color: AppColors.veryLightGray,
                                          );
                                        }),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 30,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(
                                      kDefaultSpacing * 0.2),
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color:
                                          state is TripDirectionBuilderStateStartTrip ||
                                                  isStartTrip
                                              ? AppColors.green
                                              : AppColors.lightBlack,
                                      shape: BoxShape.circle),
                                  child: Image.asset(
                                    "assets/icons/map_navigator.png",
                                    color: kWhiteColor,
                                    scale: 3.5,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: kDefaultSpacing * 0.5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const TextWidget("Start trip"),
                                        kVerticalSpaceSmall,
                                        state is TripDirectionBuilderStateStartTrip ||
                                                isStartTrip
                                            ? Builder(builder: (context) {
                                                DirectionProgress
                                                    directionProgress =
                                                    tripDirectionBuilderCubit
                                                            .directions[
                                                        RideStatus.inProgress]!;
                                                return Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Builder(builder: (context) {
                                                        String address = directionProgress
                                                            .location
                                                            .address !=
                                                            null
                                                            ? directionProgress
                                                            .location
                                                            .address
                                                            ?.isNotEmpty ??
                                                            false
                                                            ? directionProgress
                                                            .location
                                                            .address!
                                                            : ""
                                                            : "";
                                                        if (address.isNotEmpty) {
                                                          return TextWidget(
                                                            address,
                                                            softWrap: true,
                                                            maxLines: 2,
                                                            fontSize: 15,
                                                            color: AppColors
                                                                .veryLightGray,
                                                          );
                                                        }
                                                        return BlocProvider.value(
                                                          value: getIt<
                                                              GeoCoderCubit>()
                                                            ..fetchAddressFromLongAndLat(
                                                                longitude: directionProgress
                                                                    .location
                                                                    .longitude,
                                                                latitude: directionProgress
                                                                    .location
                                                                    .latitude),
                                                          child: BlocBuilder<
                                                              GeoCoderCubit,
                                                              GeoCoderState>(
                                                            builder: (context,
                                                                geoState) {
                                                              return TextWidget(
                                                                geoState
                                                                is GeoCoderStateFetched
                                                                    ? geoState
                                                                    .address
                                                                    .isEmpty
                                                                    ? 'Loading address...'
                                                                    : geoState
                                                                    .address
                                                                    : 'Loading address...',
                                                                softWrap: true,
                                                                maxLines: 2,
                                                                fontSize: 15,
                                                                color: AppColors
                                                                    .veryLightGray,
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      }),
                                                      kVerticalSpaceRegular,
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          TextWidget(
                                                            "${directionProgress.speed.toStringAsFixed(2).toString()} km/h",
                                                            fontSize: 14,
                                                          ),
                                                          kHorizontalSpaceSmall,
                                                          Container(
                                                            height: 5.r,
                                                            width: 5.r,
                                                            decoration:
                                                                const BoxDecoration(
                                                                    color: Colors
                                                                        .black,
                                                                    shape: BoxShape
                                                                        .circle),
                                                          ),
                                                          kHorizontalSpaceSmall,
                                                          TextWidget(
                                                            "${directionProgress.distance.toStringAsFixed(3).toString()} km",
                                                            fontSize: 14,
                                                          ),
                                                          kHorizontalSpaceSmall,
                                                          Container(
                                                            height: 5.r,
                                                            width: 5.r,
                                                            decoration:
                                                                const BoxDecoration(
                                                                    color: Colors
                                                                        .black,
                                                                    shape: BoxShape
                                                                        .circle),
                                                          ),
                                                          kHorizontalSpaceSmall,
                                                          TextWidget(
                                                            timeago.format(
                                                                directionProgress
                                                                    .date
                                                                    .add(directionProgress
                                                                    .duration),
                                                                clock: directionProgress
                                                                    .date,
                                                                allowFromNow:
                                                                true,
                                                                locale:
                                                                'en_short'),
                                                            fontSize: 14,
                                                          ),
                                                        ],
                                                      )
                                                    ]);
                                              })
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          width: 330,
                          top: 450 / 1.5,
                          child: Container(
                            height: 450 / 3,
                            alignment: Alignment.topCenter,
                            decoration: const BoxDecoration(),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 60,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (state
                                          is TripDirectionBuilderStateGotTrip)
                                        const TextWidget(
                                          "Now",
                                          weight: FontWeight.bold,
                                        ),
                                      kVerticalSpaceSmall,
                                      if (isGotTrip)
                                        Builder(builder: (context) {
                                          var directionProgress =
                                              tripDirectionBuilderCubit
                                                      .directions[
                                                  RideStatus.pending]!;
                                          return TextWidget(
                                            DateFormat(DateFormat.HOUR24_MINUTE)
                                                .format(directionProgress.date),
                                            color: AppColors.veryLightGray,
                                            fontSize: 14,
                                          );
                                        }),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 30,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(
                                      kDefaultSpacing * 0.2),
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color:
                                          state is TripDirectionBuilderStateGotTrip ||
                                                  isGotTrip
                                              ? AppColors.blue
                                              : AppColors.lightBlack,
                                      shape: BoxShape.circle),
                                  child: Image.asset(
                                    "assets/icons/map_navigator.png",
                                    color: kWhiteColor,
                                    scale: 3.5,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: kDefaultSpacing * 0.5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const TextWidget("Got a trip"),
                                        kVerticalSpaceSmall,
                                        state is TripDirectionBuilderStateGotTrip ||
                                                isGotTrip
                                            ? Builder(builder: (context) {
                                                DirectionProgress
                                                    directionProgress =
                                                    tripDirectionBuilderCubit
                                                            .directions[
                                                        RideStatus.pending]!;

                                                return Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Builder(builder: (context) {
                                                        String address = directionProgress
                                                            .location
                                                            .address !=
                                                            null
                                                            ? directionProgress
                                                            .location
                                                            .address
                                                            ?.isNotEmpty ??
                                                            false
                                                            ? directionProgress
                                                            .location
                                                            .address!
                                                            : ""
                                                            : "";
                                                        if (address.isNotEmpty) {
                                                          return TextWidget(
                                                            address,
                                                            softWrap: true,
                                                            maxLines: 2,
                                                            fontSize: 15,
                                                            color: AppColors
                                                                .veryLightGray,
                                                          );
                                                        }
                                                        return BlocProvider.value(
                                                          value: getIt<
                                                              GeoCoderCubit>()
                                                            ..fetchAddressFromLongAndLat(
                                                                longitude: directionProgress
                                                                    .location
                                                                    .longitude,
                                                                latitude: directionProgress
                                                                    .location
                                                                    .latitude),
                                                          child: BlocBuilder<
                                                              GeoCoderCubit,
                                                              GeoCoderState>(
                                                            builder: (context,
                                                                geoState) {
                                                              return TextWidget(
                                                                geoState
                                                                is GeoCoderStateFetched
                                                                    ? geoState
                                                                    .address
                                                                    .isEmpty
                                                                    ? 'Loading address...'
                                                                    : geoState
                                                                    .address
                                                                    : 'Loading address...',
                                                                softWrap: true,
                                                                maxLines: 2,
                                                                fontSize: 15,
                                                                color: AppColors
                                                                    .veryLightGray,
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      }),
                                                      kVerticalSpaceSmall,
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          TextWidget(
                                                            "${directionProgress.speed.toStringAsFixed(2).toString()} km/h",
                                                            fontSize: 14,
                                                          ),
                                                          kHorizontalSpaceSmall,
                                                          Container(
                                                            height: 5.r,
                                                            width: 5.r,
                                                            decoration:
                                                                const BoxDecoration(
                                                                    color: Colors
                                                                        .black,
                                                                    shape: BoxShape
                                                                        .circle),
                                                          ),
                                                          kHorizontalSpaceSmall,
                                                          TextWidget(
                                                            "${directionProgress.distance.toStringAsFixed(3).toString()} km",
                                                            fontSize: 14,
                                                          ),
                                                          kHorizontalSpaceSmall,
                                                          Container(
                                                            height: 5.r,
                                                            width: 5.r,
                                                            decoration:
                                                                const BoxDecoration(
                                                                    color: Colors
                                                                        .black,
                                                                    shape: BoxShape
                                                                        .circle),
                                                          ),
                                                          kHorizontalSpaceSmall,
                                                          const TextWidget(
                                                            "0m",
                                                            fontSize: 14,
                                                          ),
                                                        ],
                                                      )
                                                    ]);
                                              })
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  kVerticalSpaceMedium,
                  if (!isEndTrip)
                    LayoutBuilder(builder: (context, constraints) {
                      if (state is TripDirectionBuilderStateStartTrip) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SplashTap(
                              onTap: () {
                                tripDirectionBuilderCubit.endTrip();
                                setState(() {
                                  currStep = 2;
                                });
                              },
                              child: Container(
                                width: constraints.maxWidth,
                                padding: const EdgeInsets.all(kDefaultSpacing),
                                decoration: BoxDecoration(
                                    color: AppColors.red,
                                    borderRadius: BorderRadius.circular(
                                        kDefaultSpacing * 0.5)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/icons/map_navigator.png",
                                      scale: 3,
                                    ),
                                    kHorizontalSpaceTiny,
                                    const TextWidget(
                                      "End Trip",
                                      weight: FontWeight.bold,
                                      color: kWhiteColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (isGotTrip || isStartTrip) {
                                tripDirectionBuilderCubit.cancelProgress(
                                    isCompleted: false);
                                isGotTrip = false;
                                isStartTrip = false;
                                isEndTrip = false;
                                setState(() {});
                              } else {
                                Get.back();
                              }
                            },
                            child: Container(
                              width: constraints.maxWidth * 0.45,
                              padding: const EdgeInsets.all(kDefaultSpacing),
                              decoration: BoxDecoration(
                                  color: AppColors.red,
                                  borderRadius: BorderRadius.circular(
                                      kDefaultSpacing * 0.5)),
                              child: Row(
                                children: [
                                  Icon(
                                    isGotTrip
                                        ? Icons.close_outlined
                                        : Icons.arrow_back_ios,
                                    color: kWhiteColor,
                                    size: 25.r,
                                  ),
                                  kHorizontalSpaceTiny,
                                  TextWidget(
                                    isGotTrip ? "Cancel" : "Back",
                                    weight: FontWeight.bold,
                                    color: kWhiteColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (state is TripDirectionBuilderStateEndTrip ||
                              state is TripDirectionBuilderStateInitial ||
                              state is TripDirectionBuilderStateCompleted)
                            SplashTap(
                              onTap: () {
                                tripDirectionBuilderCubit.gotTrip();
                                setState(() {
                                  currStep = 0;
                                });
                              },
                              child: Container(
                                width: constraints.maxWidth * 0.45,
                                padding: const EdgeInsets.all(kDefaultSpacing),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      kDefaultSpacing * 0.5),
                                  color: AppColors.blue,
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/icons/map_navigator.png",
                                      scale: 3,
                                    ),
                                    kHorizontalSpaceTiny,
                                    const TextWidget(
                                      "Got a trip",
                                      weight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (state is TripDirectionBuilderStateGotTrip)
                            SplashTap(
                              onTap: () {
                                tripDirectionBuilderCubit.startTrip();
                                setState(() {
                                  currStep = 1;
                                });
                              },
                              child: Container(
                                width: constraints.maxWidth * 0.45,
                                padding: const EdgeInsets.all(kDefaultSpacing),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      kDefaultSpacing * 0.5),
                                  color: AppColors.green,
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/icons/map_navigator.png",
                                      scale: 3,
                                    ),
                                    kHorizontalSpaceTiny,
                                    const TextWidget(
                                      "Start a trip",
                                      weight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            )
                        ],
                      );
                    }),
                  if (isEndTrip)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            tripDirectionBuilderCubit.cancelProgress(
                                isCompleted: false);
                            isGotTrip = false;
                            isStartTrip = false;
                            isEndTrip = false;
                            setState(() {});
                          },
                          child: Container(
                            width: constraints.maxWidth * 0.46,
                            padding: const EdgeInsets.all(kDefaultSpacing),
                            decoration: BoxDecoration(
                                color: AppColors.red,
                                borderRadius: BorderRadius.circular(
                                    kDefaultSpacing * 0.5)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.close_outlined,
                                  color: kWhiteColor,
                                  size: 25.r,
                                ),
                                kHorizontalSpaceTiny,
                                const TextWidget(
                                  "Cancel",
                                  weight: FontWeight.bold,
                                  color: kWhiteColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SplashTap(
                          onTap: () {
                            Get.back();
                            Get.to(() => const RecordTrip());
                          },
                          child: Container(
                            width: constraints.maxWidth * 0.47,
                            padding: const EdgeInsets.all(kDefaultSpacing),
                            decoration: BoxDecoration(
                                color: AppColors.green,
                                borderRadius: BorderRadius.circular(
                                    kDefaultSpacing * 0.5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/icons/map_navigator.png",
                                  scale: 3,
                                ),
                                kHorizontalSpaceTiny,
                                const TextWidget(
                                  "Record Trip",
                                  weight: FontWeight.bold,
                                  color: kWhiteColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  kVerticalSpaceRegular
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
