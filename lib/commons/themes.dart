import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

final theme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: kWhiteColor,
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(),
    primaryColor: kPrimaryColor,
    appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(color: Colors.black)),
    snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        unselectedItemColor: Colors.black, selectedItemColor: kPrimaryColor),
    bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)))),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            textStyle: MaterialStateProperty.all(const TextStyle(
              color: kPrimaryColor,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            )),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14))),
            minimumSize:
                MaterialStateProperty.all(const Size(double.infinity, 74)))),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(kPrimaryColor),
            textStyle: MaterialStateProperty.all(const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w700,
            )),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14))),
            minimumSize:
                MaterialStateProperty.all(const Size(double.infinity, 74)))),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
          borderSide: const BorderSide(width: 1),
          borderRadius: BorderRadius.circular(6)),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kAccentColor));
