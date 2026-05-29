import 'package:flutter/material.dart';

class Palette {
  // Colors
  static const blackColor = Color.fromRGBO(1, 1, 1, 1); // primary color
  static const darkGreyColor = Color.fromRGBO(26, 39, 45, 1); // secondary color
  static const drawerColor = Color.fromRGBO(18, 18, 18, 1);
  static const whiteColor = Colors.white;
  static const primary = Color(0xffff6f00);
  static const secondary = Color(0xffff9a00);
  static const tertiary = Color(0xFFF10034);
  static const blu = Color(0xff0674F6);
  static var lightGreyColor = Color(0xFFF1F4F8);
  static const accent1 = Color(0xfffc000d);
  static const accent2 = Color(0xff0157bf);
  static const accent3 = Color(0xffbf3e00);
  static const accent4 = Color(0xffccffffff);
  static const accent6 = Color(0xff013a8a);
  static const primaryText = Color(0xff14181B);
  static const secondaryText = Color(0xff57636C);
  static const success = Color(0xff00c086);
  static const error = Color(0xffff5963);
  static const accent5 = Color(0xffffa700);
  

  // Themes
  static var darkModeAppTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: blackColor,
    cardColor: darkGreyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: drawerColor,
      iconTheme: IconThemeData(
        color: whiteColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: drawerColor,
    ),
    primaryColor: tertiary,
    //backgroundColor: drawerColor, // will be used as alternative background color
  );

  static var lightModeAppTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: whiteColor,
    cardColor: darkGreyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: whiteColor,
      elevation: 0,
      iconTheme: IconThemeData(
        color: blackColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: whiteColor,
    ),
    primaryColor: tertiary,
    //backgroundColor: whiteColor,
  );
}
