import 'package:flutter/material.dart';

class Palette {
  // Colors
  static const blackColor = Color.fromRGBO(1, 1, 1, 1); // primary color
  static const darkGreyColor = Color.fromRGBO(26, 39, 45, 1); // secondary color
  static const drawerColor = Color.fromRGBO(18, 18, 18, 1);
  static const whiteColor = Colors.white;
  static var primary = Color(0xffff6f00);
  static var secondary = Color(0xffff9a00);
  static var tertiary = Color(0xFFF10034);
  static var lightGreyColor = Color(0xFFF1F4F8);
  static var accent1 = Color(0xfffc000d);
  static var accent2 = Color(0xff0157bf);
  static var accent3 = Color(0xffbf3e00);
  static var accent4 = Color(0xffccffffff);
  static var primaryText = Color(0xff14181B);
  static var secondaryText = Color(0xff57636C);
  static var success = Color(0xff00c086);
  static var error = Color(0xffff5963);
  static var warning = Color(0xffffa700);
  

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
