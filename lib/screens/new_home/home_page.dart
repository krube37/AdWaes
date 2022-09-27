// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library new_home_page;

import 'dart:async';
import 'dart:math' as math;

import 'package:ad/screens/home/my_app_bar.dart';
import 'package:ad/screens/product_widgets/bottombar.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../firebase/firestore_database.dart';
import '../../globals.dart';
import '../../product/product_data.dart';
import '../../routes/my_route_delegate.dart';

part 'helper_widgets.dart';
part 'category/desktop_category_widgets.dart';
part 'category/mobile_category_widgets.dart';
part 'recent/desktop_recent_widgets.dart';
part 'recent/mobile_recent_widgets.dart';

const _horizontalPadding = 32.0;
const _carouselItemMargin = 8.0;
const _horizontalDesktopPadding = 81.0;
const _carouselHeightMin = 200.0 + 2 * _carouselItemMargin;
const _desktopCardsPerPage = 4;

class ToggleSplashNotification extends Notification {}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var carouselHeight = _carouselHeight(.7, context);
    final isDesktop = isDesktopView(context);

    if (isDesktop) {
      final desktopRecentItems = <_DesktopRecentItem>[
        _DesktopRecentItem(
          asset: Image.asset('../assets/images/tv_channel.jpg').image,
        ),
      ];

      return Scaffold(
        appBar: const MyAppBar(),
        body: ListView(
          // Makes integration tests possible.
          key: const ValueKey('HomeListView'),
          primary: true,
          padding: const EdgeInsetsDirectional.only(
            top: firstHeaderDesktopTopPadding,
          ),
          children: [
            const SizedBox(height: 30.0),
            _DesktopCarousel(height: carouselHeight, children: _getProducts()),
            const SizedBox(height: 30.0),
            SizedBox(
              height: 585,
              child: _DesktopHomeItem(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: spaceBetween(28, desktopRecentItems),
                ),
              ),
            ),
            const SizedBox(height: 81),
            const BottomBar(),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: const MyAppBar(),
        body: _AnimatedHomePage(
          restorationId: 'animated_page',
          carouselCards: _getProducts(),
        ),
      );
    }
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
        ),
      );
    }

    return productCarouselCards;
  }

  List<Widget> spaceBetween(double paddingBetween, List<Widget> children) {
    return [
      for (int index = 0; index < children.length; index++) ...[
        Flexible(
          child: children[index],
        ),
        if (index < children.length - 1) SizedBox(width: paddingBetween),
      ],
    ];
  }
}

class _AnimatedHomePage extends StatefulWidget {
  const _AnimatedHomePage({
    required this.restorationId,
    required this.carouselCards,
  });

  final String restorationId;
  final List<Widget> carouselCards;

  @override
  _AnimatedHomePageState createState() => _AnimatedHomePageState();
}

class _AnimatedHomePageState extends State<_AnimatedHomePage> with RestorationMixin, SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Timer? _launchTimer;
  final RestorableBool _isMaterialListExpanded = RestorableBool(false);

  @override
  String get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_isMaterialListExpanded, 'material_list');
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animationController.value = 1.0;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _launchTimer?.cancel();
    _launchTimer = null;
    _isMaterialListExpanded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          // Makes integration tests possible.
          key: const ValueKey('HomeListView'),
          primary: true,
          restorationId: 'home_list_view',
          children: [
            const SizedBox(height: 8),
            _Carousel(
              animationController: _animationController,
              restorationId: 'home_carousel',
              children: widget.carouselCards,
            ),
            _AnimatedRecentItem(
              startDelayFraction: 0.00,
              controller: _animationController,
              child: RecentListItem(
                  imageString: '../assets/images/tv_channel.jpg',
                  initiallyExpanded: _isMaterialListExpanded.value,
                  onTap: (shouldOpenList) {
                    _isMaterialListExpanded.value = shouldOpenList;
                  }),
            ),
          ],
        ),
        Align(
          alignment: Alignment.topCenter,
          child: GestureDetector(
            onVerticalDragEnd: (details) {
              if (details.velocity.pixelsPerSecond.dy > 200) {
                ToggleSplashNotification().dispatch(context);
              }
            },
            child: SafeArea(
              child: Container(
                height: 40,
                // If we don't set the color, gestures are not detected.
                color: Colors.transparent,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// An image that shows a [placeholder] widget while the target [image] is
/// loading, then fades in the new image when it loads.
///
/// This is similar to [FadeInImage] but the difference is that it allows you
/// to specify a widget as a [placeholder], instead of just an [ImageProvider].
/// It also lets you override the [child] argument, in case you want to wrap
/// the image with another widget, for example an [Ink.image].
class FadeInImagePlaceholder extends StatelessWidget {
  const FadeInImagePlaceholder({
    super.key,
    required this.image,
    required this.placeholder,
    this.child,
    this.duration = const Duration(milliseconds: 500),
    this.excludeFromSemantics = false,
    this.width,
    this.height,
    this.fit,
  });

  /// The target image that we are loading into memory.
  final ImageProvider image;

  /// Widget displayed while the target [image] is loading.
  final Widget placeholder;

  /// What widget you want to display instead of [placeholder] after [image] is
  /// loaded.
  ///
  /// Defaults to display the [image].
  final Widget? child;

  /// The duration for how long the fade out of the placeholder and
  /// fade in of [child] should take.
  final Duration duration;

  /// See [Image.excludeFromSemantics].
  final bool excludeFromSemantics;

  /// See [Image.width].
  final double? width;

  /// See [Image.height].
  final double? height;

  /// See [Image.fit].
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: image,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      fit: fit,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return this.child ?? child;
        } else {
          return AnimatedSwitcher(
            duration: duration,
            child: frame != null ? this.child ?? child : placeholder,
          );
        }
      },
    );
  }
}
