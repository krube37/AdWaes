import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

/// THEME DETAILS
/// ===========================================

const primaryColor = Colors.orange;



final ThemeData defaultTheme = ThemeData(
  fontFamily: "Ubuntu",
  visualDensity: VisualDensity.adaptivePlatformDensity,
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
