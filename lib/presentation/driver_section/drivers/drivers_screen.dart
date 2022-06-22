import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grip/commons/colors.dart';
import 'package:grip/commons/ui_helpers.dart';
import 'package:grip/presentation/driver_section/add_driver_screen.dart';
import 'package:grip/utils/constants/app_colors.dart';
import 'package:grip/utils/constants/app_styles.dart';

class DriversScreen extends StatefulWidget {
  const DriversScreen({Key? key}) : super(key: key);

  @override
  State<DriversScreen> createState() => _DriversScreenState();
}

class _DriversScreenState extends State<DriversScreen> {


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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          kVerticalSpaceRegular,
          GestureDetector(
            onTap: (){
              Get.to(() => const AddDriverScreen());
            },
            child: Row(
              children: [
                Icon(Icons.add,size: 25,color: kBlackColor,),
                kHorizontalSpaceMedium,
                Text("Add a driver",style: kDefaultTextStyle,)
              ],
            ),
          ),
          kVerticalSpaceRegular,
          Expanded(
            child: ListView(

            ),
          )
        ],
      ),

    );
  }
}
