import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    fontFamily: GoogleFonts.inter().fontFamily,
    brightness: Brightness.light,
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: kWhiteColor,
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: kWhiteColor,
      foregroundColor: kBlackColor,
      centerTitle: true,
      titleTextStyle: headline2.copyWith(fontWeight: FontWeight.bold),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: InputBorder.none,
      labelStyle: text1.copyWith(color: kWhiteColor4),
      hintStyle: text1.copyWith(color: kWhiteColor4),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        alignment: Alignment.center,
        elevation: 0,
        backgroundColor: kPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
        textStyle: headline2,
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: headline3,
        foregroundColor: Colors.black,
      ),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.black,
    ),
  );
}
