import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

/// THEME DETAILS
/// ===========================================

const primaryColor = Colors.orange;

final ThemeData defaultTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: primaryColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
  ),
  iconTheme: const IconThemeData(
    color: Colors.black,
  ),
  primaryColorLight: Colors.grey.shade400,
  // circle avatar background color
  fontFamily: "Ubuntu",
  visualDensity: VisualDensity.adaptivePlatformDensity,
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
    textStyle: MaterialStateProperty.all<TextStyle>(
      const TextStyle(color: Colors.white),
    ),
  )),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(2.0),
      borderSide: const BorderSide(
        color: Colors.black54,
        width: 0.5,
      ),
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: primaryColor,
  fontFamily: "Ubuntu",
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF070707),
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  cardColor: const Color(0xFF282828),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(color: Colors.white),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(2.0),
      borderSide: const BorderSide(
        color: Colors.white54,
        width: 0.5,
      ),
    ),
  ),
);

bool isDesktopView(BuildContext context) {
  var screenSize = MediaQuery.of(context).size;
  DeviceScreenType screenType = getDeviceType(screenSize);
  return screenType == DeviceScreenType.desktop;
}

bool isMobileView(BuildContext context) {
  var screenSize = MediaQuery.of(context).size;
  DeviceScreenType screenType = getDeviceType(screenSize);
  return screenType == DeviceScreenType.mobile;
}

bool isTabletView(BuildContext context) {
  var screenSize = MediaQuery.of(context).size;
  DeviceScreenType screenType = getDeviceType(screenSize);
  return screenType == DeviceScreenType.tablet;
}
