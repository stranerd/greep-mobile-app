import 'package:flutter/material.dart';
import 'package:grip/commons/colors.dart';
import 'package:stacked/stacked.dart';

import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_styles.dart';
import '../../../../utils/constants/svg_icon.dart';
import '../../customer/customer_page.dart';
import '../../home_page.dart';
import '../../transaction/view_transactions.dart';
import '../settings/home_page.dart';
import 'nav_bar_viewmodel.dart';

class NavBarView extends StatefulWidget {
  const NavBarView({Key? key}) : super(key: key);

  @override
  State<NavBarView> createState() => _NavBarViewState();
}

class _NavBarViewState extends State<NavBarView> {
  int _currNavIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currNavIndex,
        onTap: setCurrNav,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: getBottomIcons(),
        selectedItemColor: kPrimaryColor,
        selectedIconTheme: const IconThemeData(color: kPrimaryColor),
      ),
      body: SafeArea(
        child: IndexedStack(children: _children, index: _currNavIndex,)),

    );
  }

  final List<Widget> _children = const [
  DriverHomePage(),
  CustomerView(),
  TransactionView(),
  SettingsHome(),
  ];

  List<BottomNavigationBarItem> getBottomIcons() {
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


  void setCurrNav(int index) {
    setState(() {
      _currNavIndex = index;
    });

  }

}
