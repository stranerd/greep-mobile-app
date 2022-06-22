import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/driver/manager_drivers_cubit.dart';
import 'package:grip/application/user/user_cubit.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/domain/user/model/User.dart';
import 'package:grip/presentation/driver_section/add_driver_screen.dart';
import 'package:grip/presentation/driver_section/widgets/empty_result_widget.dart';
import 'package:grip/utils/constants/app_colors.dart';
import 'package:grip/utils/constants/app_styles.dart';

class DriversScreen extends StatefulWidget {
  const DriversScreen({Key? key}) : super(key: key);

  @override
  State<DriversScreen> createState() => _DriversScreenState();
}

class _DriversScreenState extends State<DriversScreen> {
  late ManagerDriversCubit _driversCubit;

  @override
  void initState() {
   _driversCubit = GetIt.I<ManagerDriversCubit>();
   _driversCubit.fetchDrivers();
    super.initState();
  }
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 16,
            ),
            color: AppColors.black),
        title: Text(
          'Drivers',
          style: AppTextStyles.blackSizeBold14,
        ),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Get.to(() => const AddDriverScreen());
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
              child: BlocBuilder<ManagerDriversCubit, ManagerDriversState>(
                builder: (context, state) {
                  if (state is ManagerDriversStateFetched) {
                    state.drivers.add(GetIt.I<UserCubit>().user);
                    if (state.drivers.isEmpty) {
                      return const EmptyResultWidget(text: "No Drivers");
                    }

                    return ListView.builder(
                      itemCount:state.drivers.length,
                      itemBuilder: (c, i) {
                        User driver = state.drivers[i];
                        return ListTile(
                          title: Text(
                            driver.firstName,
                            style: kBoldTextStyle,
                          ),
                          contentPadding: EdgeInsets.zero,
                          trailing: GestureDetector(
                            onTap: () => deleteDriver(driver),
                            child: const Icon(Icons.delete, color: AppColors.red),
                          ),
                          subtitle: Text("30% commission",style: kDefaultTextStyle.copyWith(
                            fontSize: 13
                          ),),
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                CachedNetworkImageProvider(driver.photoUrl),
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
            )
          ],
        ),
      ),
    );
  }

  void deleteDriver(User user) async {
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
                          backgroundImage: CachedNetworkImageProvider(
                            user.photoUrl
                          ),
                        ),
                        kVerticalSpaceSmall,
                        Text(user.firstName,style: kDefaultTextStyle,)
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
                                  minimumSize: Size(
                                    150,50
                                  )
                                ),
                                onPressed: () {
                                  Get.back(result: false);
                                },
                                child: Text(
                                  "Cancel",
                                  style: kBoldTextStyle.copyWith(color: kWhiteColor),

                                )),
                          ),
                          kHorizontalSpaceSmall,
                          Flexible(
                            child: TextButton(
                              style: TextButton.styleFrom(padding: EdgeInsets.zero, backgroundColor: AppColors.red,

                                  minimumSize: Size(
                                      150,50
                                  )
                              ),
                              child: Text(
                                "Yes",
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
  }
}
