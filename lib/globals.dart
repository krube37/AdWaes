import 'package:ad/firebase/news_paper_event_provider.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'news_paper/news_paper_data.dart';
import 'news_paper/news_paper_event.dart';

/// THEME DETAILS
/// ===========================================

const primaryColor = Color(0xFF0449D1);

PreferredSizeWidget getAppBar(Size screenSize) {
  DeviceScreenType screenType = getDeviceType(screenSize);
  bool isDesktopView = screenType == DeviceScreenType.desktop;

  return isDesktopView
      ? PreferredSize(
          preferredSize: Size(screenSize.width, 100),
          child: Container(
            padding: const EdgeInsets.all(15),
            color: const Color.fromARGB(255, 0, 0, 0),
            child: const Text(
              'Adwisor',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 48,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
                //letterSpacing: 3,
              ),
            ),
          ),
        )
      : AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(1),
          title: const Text(
            'Adwisor',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 24,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              //letterSpacing: 3,
            ),
          ),
        );
}

bool isDesktopView(Size screenSize){
  DeviceScreenType screenType = getDeviceType(screenSize);
  return screenType == DeviceScreenType.desktop;
}

bool isMobileView(Size screenSize){
  DeviceScreenType screenType = getDeviceType(screenSize);
  return screenType == DeviceScreenType.mobile;
}

bool isTabletView(Size screenSize){
  DeviceScreenType screenType = getDeviceType(screenSize);
  return screenType == DeviceScreenType.tablet;
}