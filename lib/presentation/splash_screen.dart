import 'package:flutter/material.dart';
import 'package:grip/presentation/driver_section/nav_pages/nav_bar/nav_bar_view.dart';
import 'package:grip/presentation/manager_section/nav_pages/nav_bar/nav_bar_view.dart';
import 'package:grip/utils/constants/app_colors.dart';
import 'package:grip/utils/constants/app_styles.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            children: [
              Text("Greep", style: AppTextStyles.blackSizeBold16),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NavBarView()));
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.blue,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "Driver's Section",
                        style: AppTextStyles.blackSizeBold14,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NavBarViews()));
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.blue,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "Manager's Section",
                        style: AppTextStyles.blackSizeBold14,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
