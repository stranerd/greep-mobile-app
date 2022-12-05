import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greep/Commons/colors.dart';
import 'package:greep/application/geocoder/geocoder_cubit.dart';
import 'package:greep/application/geocoder/geocoder_state.dart';
import 'package:greep/application/transactions/trip_direction_builder_cubit.dart';
import 'package:greep/commons/scaffold_messenger_service.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/ioc.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/presentation/widgets/text_widget.dart';
import 'package:greep/utils/constants/app_colors.dart';
import 'package:timeago/timeago.dart' as timeago;


class TripDirectionsScreen extends StatefulWidget {
  const TripDirectionsScreen({Key? key}) : super(key: key);

  @override
  _TripDirectionsScreenState createState() => _TripDirectionsScreenState();
}

class _TripDirectionsScreenState extends State<TripDirectionsScreen>
    with ScaffoldMessengerService {
  late TripDirectionBuilderCubit tripDirectionBuilderCubit;

  int currStep = 0;

  @override
  void initState() {
    tripDirectionBuilderCubit = getIt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripDirectionBuilderCubit, TripDirectionBuilderState>(
      listener: (context, state) {
        if (state is TripDirectionBuilderStateGotTrip) {
          success = "Got trip";
        }

        if (state is TripDirectionBuilderStateStartTrip) {
          success = "Started Trip!";
        }

        if (state is TripDirectionBuilderStateEndTrip) {
          success = "Ended Trip!";
        }
      },
      builder: (context, state) {
        return Container(

          height: 0.7.sh,
          margin: const EdgeInsets.symmetric(horizontal: kDefaultSpacing * 2),
          decoration: const BoxDecoration(),
          child: Column(
            children: [
              kVerticalSpaceMedium,
              TextWidget(
                state is TripDirectionBuilderStateStartTrip
                    ? "Recording ..."
                    : state is TripDirectionBuilderStateEndTrip
                        ? "Trip Ended !"
                        : "",
                fontSize: 30,
                weight: FontWeight.bold,
                color: state is TripDirectionBuilderStateStartTrip
                    ? AppColors.red
                    : AppColors.green,
              ),
              kVerticalSpaceMedium,
              kVerticalSpaceMedium,
              Container(
                padding: const EdgeInsets.all(kDefaultSpacing),
                decoration: const BoxDecoration(
                  color: AppColors.lightBlue,
                ),
                child: Stepper(
                  physics: const ScrollPhysics(),
                  currentStep: currStep,
                  onStepTapped: (int intt){
                    setState(() {
                      currStep = intt;
                    });
                  },
                  onStepContinue: () {},
                  steps: [
                    Step(
                      title: Text(
                        "Got a trip",
                        style: kBoldTextStyle,
                      ),
                      isActive: state is TripDirectionBuilderStateGotTrip,
                      content: state is TripDirectionBuilderStateGotTrip
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  BlocProvider.value(
                                    value: getIt<GeoCoderCubit>()
                                      ..fetchAddressFromLongAndLat(
                                          longitude: state.directionProgress
                                              .location.longitude,
                                          latitude: state.directionProgress
                                              .location.latitude),
                                    child: BlocBuilder<GeoCoderCubit,
                                        GeoCoderState>(
                                      builder: (context, geoState) {
                                        return TextWidget(
                                          geoState is GeoCoderStateFetched
                                              ? geoState.address.isEmpty
                                                  ? 'Loading address...'
                                                  : geoState.address
                                              : 'Loading address...',
                                          softWrap: true,
                                          maxLines: 2,
                                          fontSize: 13,
                                          color: AppColors.black,
                                        );
                                      },
                                    ),
                                  ),
                                  kVerticalSpaceRegular,
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      TextWidget(
                                          "${state.directionProgress.speed.toString()} km/h",fontSize: 12,),
                                      kHorizontalSpaceSmall,
                                      Container(
                                        height: 5.r,
                                        width: 5.r,
                                        decoration: const BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle),
                                      ),
                                      kHorizontalSpaceSmall,
                                      TextWidget(
                                          "${state.directionProgress.distance.toString()} km",fontSize: 12, ),
                                      kHorizontalSpaceSmall,
                                      Container(
                                        height: 5.r,
                                        width: 5.r,
                                        decoration: const BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle),
                                      ),
                                      kHorizontalSpaceSmall,
                                      TextWidget(
                                          "${state.directionProgress.duration.inMinutes} m", fontSize: 12,),
                                    ],
                                  )
                                ])
                          : Container(),
                      state: StepState.indexed,
                    ),
                    Step(
                      title: Text(
                        "Start a trip",
                        style: kBoldTextStyle,
                      ),
                      isActive: state is TripDirectionBuilderStateStartTrip,
                      content: state is TripDirectionBuilderStateStartTrip
                          ? Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BlocProvider.value(
                              value: getIt<GeoCoderCubit>()
                                ..fetchAddressFromLongAndLat(
                                    longitude: state.directionProgress
                                        .location.longitude,
                                    latitude: state.directionProgress
                                        .location.latitude),
                              child: BlocBuilder<GeoCoderCubit,
                                  GeoCoderState>(
                                builder: (context, geoState) {
                                  print("Getting geo locate for start trip ${state.directionProgress}");
                                  return TextWidget(
                                    geoState is GeoCoderStateFetched
                                        ? geoState.address.isEmpty
                                        ? 'Loading address...'
                                        : geoState.address
                                        : 'Loading address...',
                                    softWrap: true,
                                    maxLines: 2,
                                    fontSize: 13,
                                    color: AppColors.black,
                                  );
                                },
                              ),
                            ),
                            kVerticalSpaceRegular,
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextWidget(
                                  "${state.directionProgress.speed.toString()} km/h",fontSize: 12,),
                                kHorizontalSpaceSmall,
                                Container(
                                  height: 5.r,
                                  width: 5.r,
                                  decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle),
                                ),
                                kHorizontalSpaceSmall,
                                TextWidget(
                                  "${state.directionProgress.distance.toString()} km",fontSize: 12, ),
                                kHorizontalSpaceSmall,
                                Container(
                                  height: 5.r,
                                  width: 5.r,
                                  decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle),
                                ),
                                kHorizontalSpaceSmall,
                                TextWidget(
                                  "${state.directionProgress.duration.inMinutes} m", fontSize: 12,),
                              ],
                            )
                          ])
                          : Container(),
                      state: StepState.indexed,
                    ),
                    Step(
                      title: Text(
                        "End trip",
                        style: kBoldTextStyle,
                      ),
                      isActive: state is TripDirectionBuilderStateEndTrip,
                      content: state is TripDirectionBuilderStateEndTrip
                          ? Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BlocProvider.value(
                              value: getIt<GeoCoderCubit>()
                                ..fetchAddressFromLongAndLat(
                                    longitude: state.directionProgress
                                        .location.longitude,
                                    latitude: state.directionProgress
                                        .location.latitude),
                              child: BlocBuilder<GeoCoderCubit,
                                  GeoCoderState>(
                                builder: (context, geoState) {
                                  print("Getting geo locate for end trip ${state.directionProgress}");

                                  return TextWidget(
                                    geoState is GeoCoderStateFetched
                                        ? geoState.address.isEmpty
                                        ? 'Loading address...'
                                        : geoState.address
                                        : 'Loading address...',
                                    softWrap: true,
                                    maxLines: 2,
                                    fontSize: 13,

                                    color: AppColors.black,
                                  );
                                },
                              ),
                            ),
                            kVerticalSpaceRegular,
                            Wrap(
                              // mainAxisSize: MainAxisSize.min,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextWidget(
                                  "${state.directionProgress.speed.toString()} km/h",fontSize: 12,),
                                kHorizontalSpaceSmall,
                                Container(
                                  height: 5.r,
                                  width: 5.r,
                                  decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle),
                                ),
                                kHorizontalSpaceSmall,
                                TextWidget(
                                  "${state.directionProgress.distance.toString()} km",fontSize: 12, ),
                                kHorizontalSpaceSmall,
                                Container(
                                  height: 5.r,
                                  width: 5.r,
                                  decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle),
                                ),
                                kHorizontalSpaceSmall,
                                TextWidget(
                                  timeago.format(DateTime.now().add(Duration(seconds: 10)).subtract(state.directionProgress.duration),allowFromNow: true, locale: 'en_short'), fontSize: 12,),
                              ],
                            )
                          ])
                          : Container(),
                      state: StepState.indexed,
                    ),

                  ],
                  controlsBuilder:
                      (BuildContext context, ControlsDetails? controlsDetails) {
                    return Container();
                  },
                ),
              ),
              kVerticalSpaceMedium,
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
                              borderRadius:
                                  BorderRadius.circular(kDefaultSpacing * 0.5)),
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
                    Container(
                      padding: const EdgeInsets.all(kDefaultSpacing),
                      decoration: BoxDecoration(
                          color: AppColors.red,
                          borderRadius:
                              BorderRadius.circular(kDefaultSpacing * 0.5)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            color: kWhiteColor,
                            size: 18.r,
                          ),
                          kHorizontalSpaceTiny,
                          const TextWidget(
                            "Back",
                            weight: FontWeight.bold,
                            color: kWhiteColor,
                          ),
                        ],
                      ),
                    ),
                    if (state is TripDirectionBuilderStateEndTrip ||
                        state is TripDirectionBuilderStateInitial)
                      SplashTap(
                        onTap: () {
                          tripDirectionBuilderCubit.gotTrip();
                          setState(() {
                            currStep = 0;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(kDefaultSpacing),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(kDefaultSpacing * 0.5),
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
                          padding: const EdgeInsets.all(kDefaultSpacing),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(kDefaultSpacing * 0.5),
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
            ],
          ),
        );
      },
    );
  }
}
