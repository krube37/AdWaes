part of product_page;

class _ProductEventTile extends StatefulWidget {
  final int index;
  final ProductEvent event;
  final ProductData productData;

  const _ProductEventTile({Key? key, required this.index, required this.event, required this.productData})
      : super(key: key);

  @override
  State<_ProductEventTile> createState() => _ProductEventTileState();
}

class _ProductEventTileState extends State<_ProductEventTile> {
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
                                    'date posted: ${widget.event.dateTime}',
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
                const Positioned(
                  right: 10,
                  top: 10,
                  child: _HeartIcon(),
                ),
              ],
            )),
      ),
    );
  }
}

class _HeartIcon extends StatefulWidget {
  const _HeartIcon({Key? key}) : super(key: key);

  @override
  State<_HeartIcon> createState() => _HeartIconState();
}

class _HeartIconState extends State<_HeartIcon> {
  double iconSize = 25.0;
  bool isFavourite = false, isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => iconSize = 27.0),
      onExit: (_) => setState(() => iconSize = 25.0),
      child: InkWell(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          setState(() {
            isFavourite = !isFavourite;
          });
        },
        child: Container(
          width: 50,
          height: 50,
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Icon(
              isFavourite ? CustomIcons.heart : CustomIcons.heart_svgrepo_com,
              color: isFavourite ? Colors.red : Colors.grey,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
