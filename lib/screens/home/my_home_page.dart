library home_page;

import 'dart:math';

import 'package:ad/constants.dart';
import 'package:ad/globals.dart';
import 'package:ad/screens/home/my_app_bar.dart';
import 'package:ad/screens/product_widgets/bottombar.dart';
import 'package:flutter/material.dart';

import '../../firebase/firestore_database.dart';
import '../../product/product_data.dart';
import '../../routes/my_route_delegate.dart';

part 'home_helper_widgets.dart';

part 'categories.dart';

const _carouselHeightMin = 200.0 + 2 * 8.0;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var carouselHeight = _carouselHeight(.7, context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MyAppBar(),
      body: ListView(
        children: [
          _DesktopHomeItem(child: _CategoriesText()),
          if (isDesktopView(context))
            _DesktopCarousel(
              height: carouselHeight,
              children: _getProducts(),
            ),
          if (!isDesktopView(context))
            _Carousel(
              restorationId: 'home_carousel',
              children: _getProducts(),
            ),
          const SizedBox(
            height: 400.0,
          ),
          const BottomBar(),
        ],
      ),
    );
  }

  List<Widget> _getProducts() {
    List<Widget> productCarouselCards = [];

    for (ProductType type in ProductType.values) {
      debugPrint("_MyHomePageState _getProducts: checkzzz color ${type.getBgColor().value}");
      productCarouselCards.add(
        _CarouselCard(
          productType: type,
          asset: type.getImage().image,
          assetColor: type.getBgColor(),
          textColor: Colors.white,
        ),
      );
    }

    return productCarouselCards;
  }
}

double _carouselHeight(double scaleFactor, BuildContext context) =>
    max(_carouselHeightMin * MediaQuery.of(context).textScaleFactor * scaleFactor, _carouselHeightMin);
