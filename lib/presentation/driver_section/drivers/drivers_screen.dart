import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as g;
import 'package:get_it/get_it.dart';
import 'package:greep/application/driver/manager_drivers_cubit.dart';
import 'package:greep/application/user/user_cubit.dart';
import 'package:greep/commons/colors.dart';
import 'package:greep/commons/scaffold_messenger_service.dart';
import 'package:greep/commons/ui_helpers.dart';
import 'package:greep/domain/user/model/User.dart';
import 'package:greep/domain/user/model/driver_commission.dart';
import 'package:greep/presentation/driver_section/add_driver_screen.dart';
import 'package:greep/presentation/driver_section/widgets/empty_result_widget.dart';
import 'package:greep/presentation/widgets/back_icon.dart';
import 'package:greep/presentation/widgets/splash_tap.dart';
import 'package:greep/utils/constants/app_colors.dart';
import 'package:greep/utils/constants/app_styles.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DriversScreen extends StatefulWidget {
  const DriversScreen({Key? key}) : super(key: key);

  @override
  State<DriversScreen> createState() => _DriversScreenState();
}

class _DriversScreenState extends State<DriversScreen>
    with ScaffoldMessengerService {
  late ManagerDriversCubit _driversCubit;
  late RefreshController _refreshController;

  @override
  void initState() {
    _driversCubit = GetIt.I<ManagerDriversCubit>()
      ..fetchDrivers(softUpdate: true);
    _driversCubit.fetchDrivers();
    _refreshController = RefreshController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManagerDriversCubit, ManagerDriversState>(
      listener: (context, state) {
        if (state is ManagerDriversStateFetched) {
          if (state.isError) {
            error = state.errorMessage;
          }
          if (state.isDelete) {
            success = "Driver removed successfully";
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: BackIcon(isArrow: true,),
            title: Text(
              'Drivers',
              style: AppTextStyles.blackSizeBold14,
            ),
            centerTitle: false,
            elevation: 0.0,
          ),
          body: BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              if (state is UserStateFetched && state.user.hasManager) {
                return Container(
                  decoration: const BoxDecoration(
                    color: kLightGrayColor
                  ),
                  padding: const EdgeInsets.all(kDefaultSpacing),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/last_onboarding.png"),
                      kVerticalSpaceMedium,
                      Text(
                        "You can not add or manager a driver because you already have a manager",
                        style: kSubtitleTextStyle.copyWith(
                          fontSize: 20
                        ),
                        textAlign: TextAlign.center,

                      ),
                      kVerticalSpaceLarge,
                      kVerticalSpaceLarge,
                      kVerticalSpaceLarge
                    ],
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(kDefaultSpacing),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        g.Get.to(() => const AddDriverScreen(),
                            transition: g.Transition.fadeIn);
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.add,
                            size: 25,
                            color: kBlackColor,
                          ),
                          kHorizontalSpaceMedium,
                          Text(
                            "Add a driver",
                            style: kDefaultTextStyle,
                          )
                        ],
                      ),
                    ),
                    kVerticalSpaceRegular,
                    Expanded(
                      child: SmartRefresher(
                        controller: _refreshController,
                        onRefresh: _onRefresh,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            BlocBuilder<ManagerDriversCubit,
                                ManagerDriversState>(
                              builder: (context, state) {
                                if (state is ManagerDriversStateFetched) {
                                  if (state.drivers.isEmpty) {
                                    return const EmptyResultWidget(
                                        text: "No Drivers");
                                  }

                                  return ListView.builder(
                                    itemCount: state.drivers.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (c, i) {
                                      DriverCommission driver =
                                          state.drivers[i];

                                      return ListTile(
                                        title: Text(
                                          driver.driverName,
                                          style: kBoldTextStyle,
                                        ),
                                        contentPadding: EdgeInsets.zero,
                                        trailing: state.isLoading &&
                                                state.loadingId ==
                                                    driver.driverId
                                            ? const SizedBox(
                                                width: 25,
                                                height: 25,
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : SplashTap(
                                                onTap: () =>
                                                    _deleteDriver(driver),
                                                child:  Container(
                                                  padding: const EdgeInsets.all(kDefaultSpacing),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(kDefaultSpacing)
                                                    ),
                                                    child: SizedBox(
                                                        height: 25,
                                                        width: 25,
                                                        child: SvgPicture.asset("assets/icons/driver_delete.svg", width: 25,height: 25,))),
                                              ),
                                        subtitle: Text(
                                          "${(driver.commission * 100).toStringAsFixed(1)}% commission",
                                          style: kDefaultTextStyle.copyWith(
                                              fontSize: 13),
                                        ),
                                        leading: CircleAvatar(
                                          radius: 20,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  driver.driverPhoto),
                                        ),
                                      );
                                    },
                                  );
                                }

                                if (state is ManagerDriversStateError) {
                                  return Text(
                                    "An error occurred fetching drivers",
                                    style: kErrorColorTextStyle,
                                  );
                                }
                                return const Center(
                                    child: SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: CircularProgressIndicator()));
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _deleteDriver(DriverCommission driver) async {
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
                      "Are you sure you want to stop managing this driver?",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: kDefaultTextStyle.copyWith(height: 1.35),
                    ),
                    kVerticalSpaceRegular,
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              CachedNetworkImageProvider(driver.driverPhoto),
                        ),
                        kVerticalSpaceSmall,
                        Text(
                          driver.driverName,
                          style: kDefaultTextStyle,
                        )
                      ],
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
                                  g.Get.back(result: false);
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
                                "Yes",
                                style: kWhiteTextStyle,
                              ),
                              onPressed: () {
                                g.Get.back(result: true);
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
      _driversCubit.removeDriver(driver: driver);
    }
  }

  void _onRefresh() {
    _driversCubit.fetchDrivers(fullRefresh: true);
    _refreshController.refreshCompleted();
  }
}
