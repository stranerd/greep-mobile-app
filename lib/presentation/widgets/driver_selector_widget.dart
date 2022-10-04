import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' as g;
import 'package:get_it/get_it.dart';
import 'package:grip/application/driver/drivers_cubit.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/domain/user/model/User.dart';
import 'package:grip/presentation/driver_section/add_driver_screen.dart';
import 'package:grip/presentation/widgets/driver_item_widget.dart';
import 'package:grip/presentation/widgets/splash_tap.dart';
import 'package:grip/utils/constants/app_styles.dart';

class DriverSelectorRow extends StatefulWidget {
  final bool withWhiteText;

  const DriverSelectorRow({Key? key, this.withWhiteText = false})
      : super(key: key);

  @override
  State<DriverSelectorRow> createState() => _DriverSelectorRowState();
}

class _DriverSelectorRowState extends State<DriverSelectorRow> {
  late DriversCubit _driversCubit;

  @override
  void initState() {
    _driversCubit = GetIt.I<DriversCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriversCubit, DriversState>(
      builder: (context, state) {
        if (state is DriversStateManager) {
          return SizedBox(
              height: 90.h,
              child: ListView.separated(
                itemCount: state.drivers.length + 1,
                separatorBuilder: (_, __) => kHorizontalSpaceSmall,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (c, i) {
                  if (i == state.drivers.length) {
                    return SplashTap(
                      onTap: () {
                        g.Get.to(() => const AddDriverScreen(),
                            transition: g.Transition.fadeIn);
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 60.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 2.w,
                                    color: widget.withWhiteText
                                        ? kWhiteColor
                                        : kBlackColor)),
                            child: Icon(
                              Icons.add,
                              size: 30.r,
                              color: widget.withWhiteText
                                  ? kWhiteColor
                                  : kBlackColor,
                            ),
                          ),
                          Spacer()
                        ],
                      ),
                    );
                  }
                  User user = state.drivers[i];
                  return SplashTap(
                      onTap: () {
                        setState(() {
                          _driversCubit.setSelectedUser(user);
                        });
                      },
                      child: DriverItemWidget(
                        textColor: widget.withWhiteText ? kWhiteColor: kBlackColor,
                          name: i == 0 ? "You" : user.firstName,
                          isSelected: _driversCubit.selectedUser == user,
                          asset: user.photoUrl));
                },
              ));
        }

        return Container();
      },
    );
  }
}
