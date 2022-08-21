import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

/// THEME DETAILS
/// ===========================================

const primaryColor = Color(0xFF0449D1);



final ThemeData defaultTheme = ThemeData(
  fontFamily: "Ubuntu",
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

bool isDesktopView(Size screenSize) {
  DeviceScreenType screenType = getDeviceType(screenSize);
  return screenType == DeviceScreenType.desktop;
}

bool isMobileView(Size screenSize) {
  DeviceScreenType screenType = getDeviceType(screenSize);
  return screenType == DeviceScreenType.mobile;
}

bool isTabletView(Size screenSize) {
  DeviceScreenType screenType = getDeviceType(screenSize);
  return screenType == DeviceScreenType.tablet;
}
