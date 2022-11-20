part of home_page;

class _CustomHorizontalScroller extends StatefulWidget {
  final Function(int index) itemBuilder;
  final int itemLength;
  final double height, scrollingArrowSize;
  final double? scrollPixelsPerClick;
  final Alignment alignItemBuilder;

  const _CustomHorizontalScroller({
    Key? key,
    required this.itemLength,
    required this.itemBuilder,
    required this.height,
    required this.scrollingArrowSize,
    this.scrollPixelsPerClick,
    this.alignItemBuilder = Alignment.center,
  }) : super(key: key);

  @override
  State<_CustomHorizontalScroller> createState() => _CustomHorizontalScrollerState();
}

class _CustomHorizontalScrollerState extends State<_CustomHorizontalScroller> {
  bool disableBackScroll = true, disableForwardScroll = false, forwardArrowFocus = false, backArrowFocus = false;
  late Function setForwardState, setBackwardState;
  late ScrollController _controller;

  @override
  Widget build(BuildContext context) {
    _controller = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if ((!disableForwardScroll && _controller.position.extentAfter == 0) ||
          (disableForwardScroll && _controller.position.extentAfter != 0) ||
          (!disableBackScroll && _controller.position.extentBefore == 0) ||
          (disableBackScroll && _controller.position.extentBefore != 0)) {
        setState(() {
          disableForwardScroll = (_controller.position.extentAfter == 0);
          disableBackScroll = (_controller.position.extentBefore == 0);
        });
      }
    });

    return Center(
      child: SizedBox(
        height: widget.height,
        child: Stack(
          children: [
            Align(
              alignment: widget.alignItemBuilder,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: widget.scrollingArrowSize / 2),
                child: ListView.builder(
                  shrinkWrap: true,
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.itemLength,
                  itemBuilder: (context, index) => widget.itemBuilder.call(index),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: _ScrollingArrow.left(
                isDisabled: disableBackScroll,
                size: widget.scrollingArrowSize,
                onPressed: _moveBackward,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: _ScrollingArrow.right(
                isDisabled: disableForwardScroll,
                size: widget.scrollingArrowSize,
                onPressed: _moveForward,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _moveForward() {
    double newPixel;
    bool isInInitialState = _controller.position.extentBefore == 0;
    if (widget.scrollPixelsPerClick != null) {
      newPixel = min(_controller.position.maxScrollExtent, _controller.offset + widget.scrollPixelsPerClick!);
    } else {
      newPixel = _controller.position.maxScrollExtent;
    }

    _controller
        .animateTo(newPixel, duration: const Duration(milliseconds: 700), curve: Curves.fastOutSlowIn)
        .then((value) {
      if (mounted && (isInInitialState || _controller.position.extentAfter == 0)) {
        setState(() {
          if (isInInitialState) disableBackScroll = false;
          if (_controller.position.extentAfter == 0) disableForwardScroll = true;
        });
      }
    });
  }

  _moveBackward() {
    double newPixel;
    bool isInFinalState = _controller.position.extentAfter == 0;
    if (widget.scrollPixelsPerClick != null) {
      newPixel = max(_controller.position.minScrollExtent, _controller.offset - widget.scrollPixelsPerClick!);
    } else {
      newPixel = _controller.position.minScrollExtent;
    }

    _controller
        .animateTo(newPixel, duration: const Duration(milliseconds: 700), curve: Curves.fastOutSlowIn)
        .then((value) {
      if (mounted && (isInFinalState || _controller.position.extentBefore == 0)) {
        setState(() {
          if (isInFinalState) disableForwardScroll = false;
          if (_controller.position.extentBefore == 0) disableBackScroll = true;
        });
      }
    });
  }
}

class _ScrollingArrow extends StatefulWidget {
  final bool isLeft, isDisabled;
  final Function? onPressed;
  final double size;

  const _ScrollingArrow._({
    Key? key,
    required this.isLeft,
    required this.isDisabled,
    this.onPressed,
    required this.size,
  }) : super(key: key);

  factory _ScrollingArrow.left({
    required bool isDisabled,
    Function? onPressed,
    required double size,
  }) =>
      _ScrollingArrow._(
        isLeft: true,
        isDisabled: isDisabled,
        onPressed: onPressed,
        size: size,
      );

  factory _ScrollingArrow.right({
    required bool isDisabled,
    Function? onPressed,
    required double size,
  }) =>
      _ScrollingArrow._(
        isLeft: false,
        isDisabled: isDisabled,
        onPressed: onPressed,
        size: size,
      );

  @override
  State<_ScrollingArrow> createState() => _ScrollingArrowState();
}

class _ScrollingArrowState extends State<_ScrollingArrow> {
  bool forwardArrowFocus = false;

  @override
  Widget build(BuildContext context) {
    return widget.isDisabled
        ? const SizedBox()
        : MouseRegion(
            onEnter: (_) => setState(() => forwardArrowFocus = true),
            onExit: (_) => setState(() => forwardArrowFocus = false),
            child: InkWell(
              borderRadius: BorderRadius.circular(25.0),
              onTap: () => widget.onPressed?.call(),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.all(2.0),
                width: forwardArrowFocus ? widget.size + 2 : widget.size,
                height: forwardArrowFocus ? widget.size + 2 : widget.size,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: ThemeManager().isDarkTheme ? Colors.black54 : Colors.white24,
                  border: Border.all(color: Colors.grey),
                ),
                child: Icon(widget.isLeft ? Icons.navigate_before : Icons.navigate_next),
              ),
            ),
          );
  }
}

class _ProductListIconTile extends StatefulWidget {
  final ProductType type;

  const _ProductListIconTile({Key? key, required this.type}) : super(key: key);

  @override
  State<_ProductListIconTile> createState() => _ProductListIconTileState();
}

class _ProductListIconTileState extends State<_ProductListIconTile> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovering = true),
        onExit: (_) => setState(() => isHovering = false),
        child: SizedBox(
          width: 100.0,
          child: InkWell(
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: _onItemClicked,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.type.getIcon(),
                  color: isHovering ? primaryColor : null,
                ),
                Text(
                  widget.type.getDisplayName(),
                  style: theme.textTheme.headline5?.copyWith(
                    color: isHovering ? primaryColor : null,
                    fontSize: 15.0,
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                isHovering
                    ? Container(
                        width: 30.0,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1.5,
                              color: isHovering ? primaryColor : Colors.transparent,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onItemClicked() {
    PageManager.of(context).navigateToProduct(widget.type);
  }
}
