import 'dart:math';

import 'package:ad/helper/custom_icons.dart';
import 'package:flutter/material.dart';

/// firebase signIn/signUp errors and success enum
///
///
// height of the 'Gallery' header
const double galleryHeaderHeight = 64;

// The font size delta for headline4 font.
const double desktopDisplay1FontDelta = 16;

// The width of the settingsDesktop.
const double desktopSettingsWidth = 520;

// Sentinel value for the system text scale factor option.
const double systemTextScaleFactorOption = -1;

// The splash page animation duration.
const splashPageAnimationDurationInMilliseconds = 300;

// The desktop top padding for a page's first header (e.g. Gallery, Settings)
const firstHeaderDesktopTopPadding = 5.0;

enum FirebaseResult { success, somethingWentWrong, invalidCredentials, passwordWrong, userNotFound, userAlreadyExist }

enum ProductType {
  tvChannel,
  newsPaper,
  billBoard,
  onlineGame,
  webpage,
  youtube,
  instagram,
  fmRadio,
  sponsorship,
}

// todo: remove test code
getRandomTestImage() {
  Random random = Random();
  List<String> images = [
    '../assets/images/africa.jpg',
    '../assets/images/animals.jpg',
    '../assets/images/asia.jpg',
    '../assets/images/australia.jpg',
    '../assets/images/europe.jpg',
    '../assets/images/cover.jpg',
    '../assets/images/test3.jpeg',
    '../assets/images/event.jpg',
    '../assets/images/newspaper.jpg',
    '../assets/images/photography.jpeg',
    '../assets/images/north_america.jpg',
    '../assets/images/sample1.jpg',
    '../assets/images/search.png',
    '../assets/images/test1.jpeg',
    '../assets/images/test2.jpeg',
  ];
  return Image.asset(
    images[random.nextInt(images.length - 1)],
    fit: BoxFit.fill,
  );
}

extension ProductTypeExtention on ProductType {
  String getDisplayName() {
    switch (this) {
      case ProductType.tvChannel:
        return 'Tv Channel';
      case ProductType.newsPaper:
        return 'Newspaper';
      case ProductType.billBoard:
        return 'Billboard';
      case ProductType.onlineGame:
        return 'Online Game';
      case ProductType.webpage:
        return 'Webpage';
      case ProductType.youtube:
        return 'Youtube';
      case ProductType.instagram:
        return 'Instagram';
      case ProductType.fmRadio:
        return 'FM Radio';
      case ProductType.sponsorship:
        return 'Sponsorship';
    }
  }

  static ProductType? getTypeByName(String name) {
    try {
      return ProductType.values.firstWhere((element) => element.name == name);
    } catch (e) {
      return null;
    }
  }

  getIcon() {
    switch (this) {
      case ProductType.tvChannel:
        return Icons.tv;
      case ProductType.newsPaper:
        return CustomIcons.newspaper_2;
      case ProductType.billBoard:
        return Icons.post_add;
      case ProductType.onlineGame:
        return Icons.gamepad;
      case ProductType.webpage:
        return Icons.pageview;
      case ProductType.youtube:
        return CustomIcons.youtube_1;
      case ProductType.instagram:
        return CustomIcons.instagram;
      case ProductType.fmRadio:
        return CustomIcons.radio_tower;
      case ProductType.sponsorship:
        return Icons.grain;
    }
  }

  Image getImage() {
    switch (this) {
      case ProductType.tvChannel:
        return Image.asset('../assets/images/tv_channel.jpg');
      case ProductType.newsPaper:
        return Image.asset('../assets/images/newspaper.jpg');
      case ProductType.billBoard:
        return Image.asset('../assets/images/billboard.jpg');
      case ProductType.onlineGame:
        return Image.asset('../assets/images/online_game.jpg');
      case ProductType.webpage:
        return Image.asset('../assets/images/webpage.jpg');
      case ProductType.youtube:
        return Image.asset('../assets/images/youtube.jpg');
      case ProductType.instagram:
        return Image.asset('../assets/images/instagram.jpg');
      case ProductType.fmRadio:
        return Image.asset('../assets/images/radio.jpg');
      case ProductType.sponsorship:
        return Image.asset('../assets/images/sponsorship.jpg');
    }
  }

  Color getBgColor() {
    switch (this) {
      case ProductType.tvChannel:
        return const Color(0xFF021a3e);
      case ProductType.newsPaper:
        return const Color(0xFFA76432);
      case ProductType.billBoard:
        return const Color(0xFF6B94C0);
      case ProductType.onlineGame:
        return const Color(0xFFA7A8AC);
      case ProductType.webpage:
        return const Color(0xFFC8C9CE);
      case ProductType.youtube:
        return const Color(0xFF121D3D);
      case ProductType.instagram:
        return const Color(0xFFFF6B54);
      case ProductType.fmRadio:
        return const Color(0xFF9530B9);
      case ProductType.sponsorship:
        return const Color(0xFF292929);
    }
  }
}
