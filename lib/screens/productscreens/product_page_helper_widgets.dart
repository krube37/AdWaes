part of product_page;

class ProductEventTile extends StatefulWidget {
  final int index;
  final ProductEvent event;
  final ProductData productData;
  final double? tileWidth;

  const ProductEventTile({
    Key? key,
    required this.index,
    required this.event,
    required this.productData,
    this.tileWidth,
  }) : super(key: key);

  @override
  State<ProductEventTile> createState() => _ProductEventTileState();
}

class _ProductEventTileState extends State<ProductEventTile> {
  int cursorIndex = -1;
  Widget image = getRandomTestImage();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => cursorIndex = widget.index),
      onExit: (_) => setState(() => cursorIndex = -1),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(
              color: Colors.grey.shade400,
              width: 0.2,
            )),
        elevation: cursorIndex == widget.index ? 10 : 0,
        child: InkWell(
            borderRadius: BorderRadius.circular(10),
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () => MyRouteDelegate.of(context)
                .navigateToProductEventPage(widget.event.type, widget.productData.userName, widget.event),
            child: SizedBox(
              width: widget.tileWidth,
              child: Stack(
                children: [
                  Center(child: Text(widget.event.eventName)),
                  LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return SizedBox(
                        width: constraints.maxWidth,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Center(child: image),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.event.eventName,
                                      style: const TextStyle(fontSize: 20.0, overflow: TextOverflow.ellipsis),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text("\u20B9${widget.event.price}"),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'date posted: ${widget.event.eventTime}',
                                      style: const TextStyle(overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: _HeartIcon(eventId: widget.event.eventId),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class _HeartIcon extends StatefulWidget {
  final String eventId;

  const _HeartIcon({Key? key, required this.eventId}) : super(key: key);

  @override
  State<_HeartIcon> createState() => _HeartIconState();
}

class _HeartIconState extends State<_HeartIcon> {
  double iconSize = 25.0;
  bool isHovering = false;
  bool isLoading = false;
  late DataManager dataManager;
  bool isFavourite = false;

  @override
  Widget build(BuildContext context) {
    dataManager = Provider.of<DataManager>(context);
    isFavourite = dataManager.isFavouriteId(widget.eventId);
    return IgnorePointer(
      ignoring: isLoading,
      child: MouseRegion(
        onEnter: (_) => setState(() => iconSize = 27.0),
        onExit: (_) => setState(() => iconSize = 25.0),
        child: InkWell(
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          onTap: _toggleFavourite,
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: Colors.grey,
                      ),
                    )
                  : Icon(
                      isFavourite ? CustomIcons.heart : CustomIcons.heart_svgrepo_com,
                      color: isFavourite ? Colors.red : Colors.grey,
                      size: iconSize,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  _toggleFavourite() async {
    if (dataManager.user == null) {
      AdWiseUser? user = await SignInManager().showSignInDialog(context, showToast: (snackBar) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    }

    setState(() {
      isLoading = true;
    });
    if (isFavourite) {
      if (await FirestoreDatabase().removeFromFavourite(widget.eventId)) isFavourite = !isFavourite;
    } else {
      if (await FirestoreDatabase().addToFavourite(widget.eventId)) isFavourite = !isFavourite;
    }
    debugPrint("_HeartIconState build: isFavourite now $isFavourite");
    setState(() {
      isLoading = false;
    });
  }
}
