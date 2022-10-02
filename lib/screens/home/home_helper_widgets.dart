part of home_page;

class _ProductsMenu extends StatefulWidget {
  const _ProductsMenu({Key? key}) : super(key: key);

  @override
  State<_ProductsMenu> createState() => _ProductsMenuState();
}

class _ProductsMenuState extends State<_ProductsMenu> {
  bool disableBackScroll = true, disableForwardScroll = false;
  late Function setForwardState, setBackwardState;
  double initialScrollOffset = 0.0;
  late ScrollController _controller;

  @override
  Widget build(BuildContext context) {
    _controller = ScrollController(initialScrollOffset: initialScrollOffset);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setForwardState(() {
        disableForwardScroll = (_controller.position.extentAfter == 0);
      });
      setBackwardState(() {
        disableBackScroll = (_controller.position.extentBefore == 0);
      });
    });
    Size screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StatefulBuilder(
            builder: (context, setState) {
              setBackwardState = setState;
              return disableBackScroll
                  ? const SizedBox(
                      width: 50.0,
                      height: 50.0,
                    )
                  : InkWell(
                      borderRadius: BorderRadius.circular(25.0),
                      onTap: _moveBackward,
                      child: Container(
                        width: 50.0,
                        height: 50.0,
                        // color: Colors.blue,
                        padding: const EdgeInsets.all(8.0),
                        child: const Icon(Icons.navigate_before),
                      ),
                    );
            },
          ),
          SizedBox(
            width: screenSize.width / 1.5,
            height: 100.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                itemCount: ProductType.values.length,
                itemBuilder: (context, index) => _ProductListViewTile(type: ProductType.values[index]),
              ),
            ),
          ),
          StatefulBuilder(
            builder: (context, setState) {
              setForwardState = setState;
              return disableForwardScroll
                  ? const SizedBox(
                      width: 50.0,
                      height: 50.0,
                    )
                  : InkWell(
                      borderRadius: BorderRadius.circular(25.0),
                      onTap: _moveForward,
                      child: Container(
                        width: 50.0,
                        height: 50.0,
                        // color: Colors.blue,
                        padding: const EdgeInsets.all(8.0),
                        child: const Icon(Icons.navigate_next),
                      ),
                    );
            },
          )
        ],
      ),
    );
  }

  _moveForward() {
    debugPrint(
        "_MyHomePageState _moveForward: max scroll ${_controller.position.extentBefore} ${_controller.position.extentAfter}");
    _controller
        .animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 700),
      curve: Curves.fastOutSlowIn,
    )
        .then((value) {
      debugPrint(
          "_ScrollButtonState _moveForward: forward ${_controller.position.extentAfter}  ${_controller.position.maxScrollExtent} ");
      if (_controller.position.extentAfter == 0) {
        setState(() {
          disableForwardScroll = true;
          disableBackScroll = false;
          initialScrollOffset = _controller.offset;
        });
      }
    });
  }

  _moveBackward() {
    _controller
        .animateTo(
      _controller.position.minScrollExtent,
      duration: const Duration(milliseconds: 700),
      curve: Curves.fastOutSlowIn,
    )
        .then((value) {
      if (_controller.position.extentBefore == 0) {
        setState(() {
          disableForwardScroll = false;
          disableBackScroll = true;
          initialScrollOffset = _controller.offset;
        });
      }
    });
  }
}

class _ProductListViewTile extends StatefulWidget {
  final ProductType type;

  const _ProductListViewTile({Key? key, required this.type}) : super(key: key);

  @override
  State<_ProductListViewTile> createState() => _ProductListViewTileState();
}

class _ProductListViewTileState extends State<_ProductListViewTile> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
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
                  color: isHovering ? primaryColor : Colors.black,
                ),
                Text(
                  widget.type.getDisplayName(),
                  style: TextStyle(color: isHovering ? primaryColor : Colors.black),
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
                              color: isHovering ? primaryColor : Colors.black,
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

  _onItemClicked() async {
    List<ProductData> products = await FirestoreDatabase().getProductsOfType(type: widget.type);
    if (mounted) {
      MyRouteDelegate.of(context)
          .navigateToCompany(widget.type, products, products.isNotEmpty ? products.first.userName : '');
    }
  }
}
