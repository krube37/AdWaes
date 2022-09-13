import 'dart:math';

import 'package:ad/helper/custom_icons.dart';
import 'package:flutter/material.dart';

/// firebase signIn/signUp errors and success enum
///

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
}
