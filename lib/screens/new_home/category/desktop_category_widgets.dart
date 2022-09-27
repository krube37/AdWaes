part of new_home_page;

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
      showNextButton = _controller.offset < _controller.position.maxScrollExtent;
    }
    final totalWidth = MediaQuery.of(context).size.width - (_horizontalDesktopPadding - cardPadding) * 2;
    final itemWidth = totalWidth / _desktopCardsPerPage;

    return Align(
      alignment: Alignment.center,
      child: Container(
        height: widget.height,
        constraints: const BoxConstraints(maxWidth: maxHomeItemWidth),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: _horizontalDesktopPadding - cardPadding,
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
    const padding = _horizontalDesktopPadding - buttonSize / 2;
    return ExcludeSemantics(
      child: Align(
        alignment: isEnd ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
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

class _CarouselCard extends StatefulWidget {
  const _CarouselCard({
    required this.productType,
    this.asset,
    this.assetColor,
  });

  final ProductType productType;
  final ImageProvider? asset;
  final Color? assetColor;

  @override
  State<_CarouselCard> createState() => _CarouselCardState();
}

class _CarouselCardState extends State<_CarouselCard> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      // Makes integration tests possible.
      //key: ValueKey(demo!.describe),
      margin: EdgeInsets.all(isDesktopView(context) ? 0 : _carouselItemMargin),
      child: Material(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _onCardClicked,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (widget.asset != null)
                FadeInImagePlaceholder(
                  image: widget.asset!,
                  placeholder: Container(
                    color: widget.assetColor,
                  ),
                  child: Ink.image(
                    image: widget.asset!,
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
                      widget.productType.getDisplayName(),
                      style: textTheme.bodySmall!.apply(color: Colors.white),
                      maxLines: 3,
                      overflow: TextOverflow.visible,
                    ),
                    Text(
                      'have to provide some description...',
                      style: textTheme.labelSmall!.apply(color: Colors.white),
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

  _onCardClicked() async {
    List<ProductData> products = await FirestoreDatabase().getProductsOfType(type: widget.productType);
    if (mounted) {
      MyRouteDelegate.of(context)
          .navigateToCompany(widget.productType, products, products.isNotEmpty ? products.first.userName : '');
    }
  }
}

double _carouselHeight(double scaleFactor, BuildContext context) =>
    math.max(_carouselHeightMin * MediaQuery.of(context).textScaleFactor * scaleFactor, _carouselHeightMin);
