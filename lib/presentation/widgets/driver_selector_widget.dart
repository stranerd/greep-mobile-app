import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:grip/application/user/drivers_cubit.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/domain/user/model/User.dart';
import 'package:grip/presentation/splash_screen.dart';
import 'package:grip/presentation/widgets/driver_item_widget.dart';
import 'package:grip/presentation/widgets/splash_tap.dart';
import 'package:grip/utils/constants/app_styles.dart';

class DriverSelectorRow extends StatefulWidget {
  const DriverSelectorRow({Key? key}) : super(key: key);

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

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriversCubit, DriversState>(
      builder: (context, state) {
        if (state is DriversStateManager){
        return SizedBox(
          height: 90,
          child: ListView.separated(
            itemCount: state.drivers.length + 1,
            separatorBuilder: (_,__) => kHorizontalSpaceSmall ,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (c,i){
              if (i == state.drivers.length){
                return SplashTap(
                  onTap: (){},
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 2,color: kBlackColor)
                        ),
                        child: const Icon(Icons.add,size: 30,color: kBlackColor,),
                      ),
                      Spacer()
                    ],
                  ),
                );
              }
              User user = state.drivers[i];
              return SplashTap(
                  onTap: (){
                    setState(() {
                      selectedIndex = i;
                    });
                  },
                  child: DriverItemWidget(name: i==0?"You": user.firstName, isSelected: selectedIndex == i, asset: user.photoUrl));
            },
          )
        );
        }

        return Container();
      },
    );
  }
}
