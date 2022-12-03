import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:greep/Commons/colors.dart';
import 'package:greep/application/location/driver_location_status_cubit.dart';
import 'package:greep/domain/user/model/ride_status.dart';
import 'package:greep/utils/constants/app_colors.dart';

class DriverLocationStatusWidget extends StatefulWidget {
  final String userId;

  // specify if online status should
  // show a text of chat indicators
  final bool textOnly;
  final Color? textColor;
  final bool showLastSeen;
  final double? fontSize;
  final TextStyle? textStyle;

  const DriverLocationStatusWidget(
      {Key? key,
      required this.userId,
      this.fontSize,
      this.textColor,
      this.textOnly = false,
      this.showLastSeen = true,
      this.textStyle})
      : super(key: key);

  @override
  _DriverLocationStatusWidgetState createState() => _DriverLocationStatusWidgetState();
}

class _DriverLocationStatusWidgetState extends State<DriverLocationStatusWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return GetIt.I<DriverLocationStatusCubit>()
          ..checkOnlineStatus(widget.userId);
      },
      child: Builder(
        builder: (c) {
          return BlocBuilder<DriverLocationStatusCubit,
              DriverLocationStatusState>(
            builder: (c, oS) {
              if (oS is DriverLocationStatusStateFetched) {
                return CircleAvatar(
                  radius: 7.r,
                  backgroundColor: kWhiteColor,
                  child: CircleAvatar(
                    radius: 5.r,
                    backgroundColor: oS.status.rideStatus == RideStatus.pending
                        ? AppColors.blue
                        : oS.status.rideStatus == RideStatus.ended
                            ? AppColors.red
                            : AppColors.green,
                  ),
                );
              }

              return Container(
                height: 17,
                width: 17,
                decoration: const BoxDecoration(
                    color: AppColors.red, shape: BoxShape.circle),
              );
            },
          );
        },
      ),
    );
  }
}
