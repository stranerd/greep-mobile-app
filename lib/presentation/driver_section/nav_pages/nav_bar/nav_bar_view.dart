import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_styles.dart';
import '../../../../utils/constants/svg_icon.dart';
import '../../customer/customer_page.dart';
import '../../home_page.dart';
import '../../transaction/view_transactions.dart';
import '../settings/home_page.dart';
import 'nav_bar_viewmodel.dart';

///Home view is the holder for all the views
///!Do not edit this directly, edit pages instead
///
class NavBarView extends StatelessWidget {
  const NavBarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NavBarViewModel>.reactive(
      //this parameter allows us to reuse the view model to persist the state
      disposeViewModel: false,
      //initialise the view model only once
      initialiseSpecialViewModelsOnce: true,
      viewModelBuilder: () => NavBarViewModel(),
      onModelReady: (vModel) {
        // vModel.bottomNavList = getBottomIcons();
      },
      builder: (context, vModel, child) {
        return Scaffold(
          //passing in the current index from the view model
          // so it can return the right screen

          body: getViewForIndex(vModel.currentIndex),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: AppColors.white,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.black,
            unselectedItemColor: AppColors.black,
            selectedFontSize: 14,
            unselectedFontSize: 14,
            selectedLabelStyle: AppTextStyles.blackSize12,
            unselectedLabelStyle: AppTextStyles.blackSize12,
            currentIndex: vModel.currentIndex,
            onTap: vModel.setIndex,
            items: getBottomIcons(context),
          ),
        );
      },
    );
  }

  List<BottomNavigationBarItem> getBottomIcons(context) {
    List<SvgData> icons = [
      SvgAssets.home,
      SvgAssets.people,
      SvgAssets.history,
      SvgAssets.settings,
    ];

    List<SvgData> icon = [
      SvgAssets.homeActive,
      SvgAssets.peopleActive,
      SvgAssets.historyActive,
      SvgAssets.settingsActive,
    ];

    List<String> name = [
      'Home',
      'People',
      'History',
      'Settings',
    ];

    List<BottomNavigationBarItem> bottomNavList = List.generate(4, (i) {
      var item = BottomNavigationBarItem(
        label: '',
        icon: SvgIcon(
          svgIcon: icons[i],
        ),
        activeIcon: SvgIcon(
          svgIcon: icon[i],
          color: AppColors.black,
        ),
      );

      return item;
    });

    return bottomNavList;
  }

  ///Get all the pages and match them to the bottom nav icon
  ///that is clicked this would change the view to the current
  Widget getViewForIndex(int index) {
    switch (index) {
      case 0:
        return const DriverHomePage();
      case 1:
        return const CustomerView();
      case 2:
        return const TransactionView();
      case 3:
        return const SettingsHome();
      default:
        return const DriverHomePage();
    }
  }
}
