part of home_page;


class _DesktopHomeItem extends StatelessWidget {
  const _DesktopHomeItem({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1400.0),
        padding: const EdgeInsets.symmetric(
          horizontal: 81.0,
        ),
        child: child,
      ),
    );
  }
}

class _CategoriesText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Header(
      color: Theme.of(context).colorScheme.primaryContainer,
      text: 'Categories',
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key, required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: EdgeInsets.only(
          top: isDesktopView(context) ? 63 : 15,
          bottom: isDesktopView(context) ? 21 : 11,
        ),
        child: SelectableText(
          text,
          style: Theme.of(context).textTheme.headlineMedium!.apply(
            color: color,
            fontSizeDelta:
            isDesktopView(context) ? 16.0 : 0,
          ),
        ),
      ),
    );
  }
}

/// This creates a horizontally scrolling [ListView] of items.
///
/// This class uses a [ListView] with a custom [ScrollPhysics] to enable
/// snapping behavior. A [PageView] was considered but does not allow for
/// multiple pages visible without centering the first page.
class _DesktopCarousel extends StatefulWidget {
  const _DesktopCarousel({required this.height, required this.children});

  final double height;
  final List<Widget> children;

  @override
  _DesktopCarouselState createState() => _DesktopCarouselState();
}

class _DesktopCarouselState extends State<_DesktopCarousel> {
  static const cardPadding = 15.0;
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _builder(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: cardPadding,
      ),
      child: widget.children[index],
    );
  }

  @override
  Widget build(BuildContext context) {
    var showPreviousButton = false;
    var showNextButton = true;
    // Only check this after the _controller has been attached to the ListView.
    if (_controller.hasClients) {
      showPreviousButton = _controller.offset > 0;
      showNextButton =
          _controller.offset < _controller.position.maxScrollExtent;
    }
    final totalWidth = MediaQuery.of(context).size.width -
        (81.0 - cardPadding) * 2;
    final itemWidth = totalWidth / 4;

    return Align(
      alignment: Alignment.center,
      child: Container(
        height: widget.height,
        constraints: const BoxConstraints(maxWidth: 1400.0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 81.0 - cardPadding,
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                primary: false,
                physics: const _SnappingScrollPhysics(),
                controller: _controller,
                itemExtent: itemWidth,
                itemCount: widget.children.length,
                itemBuilder: (context, index) => _builder(index),
              ),
            ),
            if (showPreviousButton)
              _DesktopPageButton(
                onTap: () {
                  _controller.animateTo(
                    _controller.offset - itemWidth,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            if (showNextButton)
              _DesktopPageButton(
                isEnd: true,
                onTap: () {
                  _controller.animateTo(
                    _controller.offset + itemWidth,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _DesktopPageButton extends StatelessWidget {
  const _DesktopPageButton({
    this.isEnd = false,
    this.onTap,
  });

  final bool isEnd;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const buttonSize = 58.0;
    const padding = 81.0  - buttonSize / 2;
    return ExcludeSemantics(
      child: Align(
        alignment: isEnd
            ? AlignmentDirectional.centerEnd
            : AlignmentDirectional.centerStart,
        child: Container(
          width: buttonSize,
          height: buttonSize,
          margin: EdgeInsetsDirectional.only(
            start: isEnd ? 0 : padding,
            end: isEnd ? padding : 0,
          ),
          child: Tooltip(
            message: isEnd
                ? MaterialLocalizations.of(context).nextPageTooltip
                : MaterialLocalizations.of(context).previousPageTooltip,
            child: Material(
              color: Colors.black.withOpacity(0.5),
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onTap,
                child: Icon(
                  isEnd ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Scrolling physics that snaps to the new item in the [_DesktopCarousel].
class _SnappingScrollPhysics extends ScrollPhysics {
  const _SnappingScrollPhysics({super.parent});

  @override
  _SnappingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _SnappingScrollPhysics(parent: buildParent(ancestor));
  }

  double _getTargetPixels(
      ScrollMetrics position,
      Tolerance tolerance,
      double velocity,
      ) {
    final itemWidth = position.viewportDimension / 4;
    var item = position.pixels / itemWidth;
    if (velocity < -tolerance.velocity) {
      item -= 0.5;
    } else if (velocity > tolerance.velocity) {
      item += 0.5;
    }
    return min(
      item.roundToDouble() * itemWidth,
      position.maxScrollExtent,
    );
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position,
      double velocity,
      ) {
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final tolerance = this.tolerance;
    final target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels) {
      return ScrollSpringSimulation(
        spring,
        position.pixels,
        target,
        velocity,
        tolerance: tolerance,
      );
    }
    return null;
  }

  @override
  bool get allowImplicitScrolling => true;
}

class _CarouselCard extends StatelessWidget {
  const _CarouselCard({
    required this.productType,
    this.asset,
    this.assetColor,
    this.textColor,
  });

  final ProductType productType;
  final ImageProvider? asset;
  final Color? assetColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white.withOpacity(0.87) : this.textColor;

    return Container(
      // Makes integration tests possible.
      key: ValueKey(productType.name),
      margin:
      EdgeInsets.all(isDesktopView(context) ? 0 : 8.0),
      child: Material(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {},
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (asset != null)
                FadeInImagePlaceholder(
                  image: asset!,
                  placeholder: Container(
                    color: assetColor,
                  ),
                  child: Ink.image(
                    image: asset!,
                    fit: BoxFit.cover,
                  ),
                ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'demo!.title',
                      style: textTheme.bodySmall!.apply(color: textColor),
                      maxLines: 3,
                      overflow: TextOverflow.visible,
                    ),
                    Text(
                      'demo!.subtitle',
                      style: textTheme.labelSmall!.apply(color: textColor),
                      maxLines: 5,
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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

class _Carousel extends StatefulWidget {
  const _Carousel({
    this.restorationId,
    required this.children,
  });
  final String? restorationId;
  final List<Widget> children;

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<_Carousel>
    with RestorationMixin, SingleTickerProviderStateMixin {
  PageController? _controller;

  final RestorableInt _currentPage = RestorableInt(0);

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_currentPage, 'carousel_page');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller == null) {
      // The viewPortFraction is calculated as the width of the device minus the
      // padding.
      final width = MediaQuery.of(context).size.width;
      const padding = (32.0 * 2) - (8.0 * 2);
      _controller = PageController(
        initialPage: _currentPage.value,
        viewportFraction: (width - padding) / width,
      );
    }
  }

  @override
  void dispose() {
    _controller!.dispose();
    _currentPage.dispose();
    super.dispose();
  }

  Widget builder(int index) {
    final carouselCard = AnimatedBuilder(
      animation: _controller!,
      builder: (context, child) {
        double value;
        if (_controller!.position.haveDimensions) {
          value = _controller!.page! - index;
        } else {
          // If haveDimensions is false, use _currentPage to calculate value.
          value = (_currentPage.value - index).toDouble();
        }
        // We want the peeking cards to be 160 in height and 0.38 helps
        // achieve that.
        value = (1 - (value.abs() * .38)).clamp(0, 1).toDouble();
        value = Curves.easeOut.transform(value);

        return Center(
          child: Transform(
            transform: Matrix4.diagonal3Values(1.0, value, 1.0),
            alignment: Alignment.center,
            child: child,
          ),
        );
      },
      child: widget.children[index],
    );

    // We only want the second card to be animated.
    if (index == 1) {
      return carouselCard;
    } else {
      return carouselCard;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      // Makes integration tests possible.
      key: const ValueKey('studyDemoList'),
      onPageChanged: (value) {
        setState(() {
          _currentPage.value = value;
        });
      },
      controller: _controller,
      itemCount: widget.children.length,
      itemBuilder: (context, index) => builder(index),
      allowImplicitScrolling: true,
    );
  }
}

/// Animates the carousel to come in from the right.
class _AnimatedCarousel extends StatelessWidget {
  _AnimatedCarousel({
    required this.child,
    required this.controller,
  }) : startPositionAnimation = Tween(
    begin: 1.0,
    end: 0.0,
  ).animate(
    CurvedAnimation(
      parent: controller,
      curve: const Interval(
        0.200,
        0.800,
        curve: Curves.ease,
      ),
    ),
  );

  final Widget child;
  final AnimationController controller;
  final Animation<double> startPositionAnimation;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          SizedBox(height: _carouselHeight(.4, context)),
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return PositionedDirectional(
                start: constraints.maxWidth * startPositionAnimation.value,
                child: child!,
              );
            },
            child: SizedBox(
              height: _carouselHeight(.4, context),
              width: constraints.maxWidth,
              child: child,
            ),
          ),
        ],
      );
    });
  }
}

/// Animates a carousel card to come in from the right.
class _AnimatedCarouselCard extends StatelessWidget {
  _AnimatedCarouselCard({
    required this.child,
    required this.controller,
  }) : startPaddingAnimation = Tween(
    begin: 32.0,
    end: 0.0,
  ).animate(
    CurvedAnimation(
      parent: controller,
      curve: const Interval(
        0.900,
        1.000,
        curve: Curves.ease,
      ),
    ),
  );

  final Widget child;
  final AnimationController controller;
  final Animation<double> startPaddingAnimation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Padding(
          padding: EdgeInsetsDirectional.only(
            start: startPaddingAnimation.value,
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}
