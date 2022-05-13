import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  static const double _size10 = 10.0;
  static const double _size12 = 12.0;
  static const double _size14 = 14.0;
  static const double _size16 = 16.0;

  static const FontWeight _regularWeight = FontWeight.w400;
  static const FontWeight _boldWeight = FontWeight.w700;

  //Text Styles go below
  //colorSizeFontWeight
  ///Note: This is the normal text used in the app

  ///Dark Gray
  static TextStyle darkGraySize10 =
      _base(_size10, _regularWeight, AppColors.darkGray, 1.5);

  static TextStyle darkGraySize12 =
      _base(_size12, _regularWeight, AppColors.darkGray, 1.5);

  static TextStyle darkGraySize14 =
      _base(_size14, _regularWeight, AppColors.darkGray, 1.5);

  static TextStyle darkGreySize16 =
      _base(_size16, _regularWeight, AppColors.darkGray, 1.5);

  ///white
  static TextStyle whiteSize10 =
      _base(_size10, _regularWeight, AppColors.white, 1.5);

  static TextStyle whiteSize12 =
      _base(_size12, _regularWeight, AppColors.white, 1.5);

  static TextStyle whiteSize14 =
      _base(_size14, _regularWeight, AppColors.white, 1.5);

  static TextStyle whiteSize16 =
      _base(_size16, _regularWeight, AppColors.white, 1.5);

  ///Light Gray
  static TextStyle lightGraySize10 =
      _base(_size10, _regularWeight, AppColors.lightGray, 1.5);

  static TextStyle lightGraySize12 =
      _base(_size12, _regularWeight, AppColors.lightGray, 1.5);

  static TextStyle lightGraySize14 =
      _base(_size14, _regularWeight, AppColors.lightGray, 1.5);

  static TextStyle lightGraySize16 =
      _base(_size16, _regularWeight, AppColors.lightGray, 1.5);

  ///Blue
  static TextStyle blueSize10 =
      _base(_size10, _regularWeight, AppColors.blue, 1.5);

  static TextStyle blueSize12 =
      _base(_size12, _regularWeight, AppColors.blue, 1.5);

  static TextStyle blueSize14 =
      _base(_size14, _regularWeight, AppColors.blue, 1.5);

  static TextStyle blueSize16 =
      _base(_size16, _regularWeight, AppColors.blue, 1.5);

  ///Green
  static TextStyle greenSize10 =
      _base(_size10, _regularWeight, AppColors.green, 1.5);

  static TextStyle greenSize12 =
      _base(_size12, _regularWeight, AppColors.green, 1.5);

  static TextStyle greenSize14 =
      _base(_size14, _regularWeight, AppColors.green, 1.5);

  static TextStyle greenSize16 =
      _base(_size16, _regularWeight, AppColors.green, 1.5);

  ///Red
  static TextStyle redSize10 =
      _base(_size10, _regularWeight, AppColors.red, 1.5);

  static TextStyle redSize12 =
      _base(_size12, _regularWeight, AppColors.red, 1.5);

  static TextStyle redSize14 =
      _base(_size14, _regularWeight, AppColors.red, 1.5);

  static TextStyle redSize16 =
      _base(_size16, _regularWeight, AppColors.red, 1.5);

  ///Black
  static TextStyle blackSize10 =
      _base(_size10, _regularWeight, AppColors.black, 1.5);

  static TextStyle blackSize12 =
      _base(_size12, _regularWeight, AppColors.black, 1.5);

  static TextStyle blackSize14 =
      _base(_size14, _regularWeight, AppColors.black, 1.5);

  static TextStyle blackSize16 =
      _base(_size16, _regularWeight, AppColors.black, 1.5);

  //Bold font

  ///Dark Gray

  static TextStyle darkGraySizeBold12 =
      _base(_size12, _boldWeight, AppColors.darkGray, 1.5);

  static TextStyle darkGraySizeBold14 =
      _base(_size14, _boldWeight, AppColors.darkGray, 1.5);

  static TextStyle darkGreySizeBold16 =
      _base(_size16, _boldWeight, AppColors.darkGray, 1.5);

  ///Light Gray

  static TextStyle lightGraySizeBold12 =
      _base(_size12, _boldWeight, AppColors.lightGray, 1.5);

  static TextStyle lightGraySizeBold14 =
      _base(_size14, _boldWeight, AppColors.lightGray, 1.5);

  static TextStyle lightGraySizeBold16 =
      _base(_size16, _boldWeight, AppColors.lightGray, 1.5);

  ///Blue

  static TextStyle blueSizeBold12 =
      _base(_size12, _boldWeight, AppColors.blue, 1.5);

  static TextStyle blueSizeBold14 =
      _base(_size14, _boldWeight, AppColors.blue, 1.5);

  static TextStyle blueSizeBold16 =
      _base(_size16, _boldWeight, AppColors.blue, 1.5);

  ///Green

  static TextStyle greenSizeBold12 =
      _base(_size12, _boldWeight, AppColors.green, 1.5);

  static TextStyle greenSizeBold14 =
      _base(_size14, _boldWeight, AppColors.green, 1.5);

  static TextStyle greenSizeBold16 =
      _base(_size16, _boldWeight, AppColors.green, 1.5);

  ///Red

  static TextStyle redSizeBold12 =
      _base(_size12, _boldWeight, AppColors.red, 1.5);

  static TextStyle redSizeBold14 =
      _base(_size14, _boldWeight, AppColors.red, 1.5);

  static TextStyle redSizeBold16 =
      _base(_size16, _boldWeight, AppColors.red, 1.5);

  ///Black

  static TextStyle blackSizeBold12 =
      _base(_size12, _boldWeight, AppColors.black, 1.5);

  static TextStyle blackSizeBold14 =
      _base(_size14, _boldWeight, AppColors.black, 1.5);

  static TextStyle blackSizeBold16 = _base(
    _size16,
    _boldWeight,
    AppColors.black,
    1.5,
  );

  //#base style
  static TextStyle _base(
    double size,
    FontWeight? fontWeight,
    Color? color,
    double height,
  ) {
    return baseStyle(
        fontSize: size, fontWeight: fontWeight, color: color, height: height);
  }

  static TextStyle baseStyle({
    double fontSize = 13,
    FontWeight? fontWeight,
    Color? color,
    double height = 1.5,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color ?? Colors.grey[600],
      height: height,
    );
  }
}
