

import 'package:flutter/material.dart';

import '../helper/custom_icons.dart';

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