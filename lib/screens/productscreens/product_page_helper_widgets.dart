part of product_page;

class EventTile extends StatefulWidget {
  final ProductEvent? event;
  final ProductData? productData;
  final double? tileWidth;
  final bool isLoading, showProductHeader;

  const EventTile({
    Key? key,
    required this.event,
    this.tileWidth,
    this.isLoading = false,
    required this.productData,
    this.showProductHeader = true,
  })  : assert(
          isLoading || (event != null && productData != null),
          'if isLoading is false, then productData and event should not be null',
        ),
        super(key: key);

  @override
  State<EventTile> createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  bool isHovering = false;
  Widget image = getRandomTestImage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IgnorePointer(
        ignoring: widget.isLoading,
        child: MouseRegion(
          onEnter: (_) => setState(() => isHovering = true),
          onExit: (_) => setState(() => isHovering = false),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(
                  color: Colors.grey.shade400,
                  width: 0.2,
                )),
            elevation: isHovering ? 10 : 0,
            child: InkWell(
                borderRadius: BorderRadius.circular(10),
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () =>
                    widget.isLoading ? null : PageManager.of(context).navigateToProductEventPage(widget.event!.eventId),
                child: SizedBox(
                  width: widget.tileWidth,
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return SizedBox(
                        width: constraints.maxWidth,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.showProductHeader)
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20.0,
                                      backgroundImage:
                                          widget.isLoading ? null : widget.productData!.profilePhotoImageProvider,
                                      backgroundColor: Theme.of(context).disabledColor,
                                      child: widget.productData?.profilePhotoImageProvider == null && !widget.isLoading
                                          ? const Icon(
                                              Icons.person_sharp,
                                              size: 30.0,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 10.0),
                                    Expanded(
                                      child: widget.isLoading
                                          ? _getLoadingContainer(height: 35.0)
                                          : Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                UnderLinedTextClicker(
                                                  text: widget.productData!.name,
                                                  style: const TextStyle(
                                                    //fontSize: 18.0,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  onTap: () => PageManager.of(context)
                                                      .navigateToProductProfilePage(widget.productData!.userName),
                                                ),
                                                const SizedBox(height: 5),
                                                UnderLinedTextClicker(
                                                  text: ProductType.values[widget.event!.type.index].getDisplayName(),
                                                  style: const TextStyle(
                                                    fontSize: 12.0,
                                                  ),
                                                  onTap: () =>
                                                      PageManager.of(context).navigateToProduct(widget.event!.type),
                                                ),
                                              ],
                                            ),
                                    ),
                                    if (!widget.isLoading)
                                      FavouriteHeartIconWidget(event: widget.event!),
                                  ],
                                ),
                              if (widget.showProductHeader)
                                const SizedBox(
                                  height: 10.0,
                                ),
                              Expanded(
                                flex: 5,
                                child: Center(
                                  child: AnimatedContainer(
                                    padding: isHovering ? null : const EdgeInsets.all(2.0),
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.easeOut,
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5.0),
                                        child: Container(
                                          color: Theme.of(context).disabledColor,
                                          child: widget.event?.photoImageProvider != null
                                              ? Image(
                                                  image: widget.event!.photoImageProvider!,
                                                  fit: BoxFit.cover,
                                                )
                                              : !widget.isLoading
                                                  ? const FlutterLogo()
                                                  : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    widget.isLoading
                                        ? _getLoadingContainer(height: 20.0)
                                        : Text(
                                            widget.event!.eventName,
                                            style: const TextStyle(fontSize: 20.0, overflow: TextOverflow.ellipsis),
                                          ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    widget.isLoading
                                        ? Row(
                                            children: [
                                              Expanded(child: _getLoadingContainer(height: 20.0)),
                                              const Expanded(child: SizedBox()),
                                            ],
                                          )
                                        : Text("\u20B9${widget.event!.price}"),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    widget.isLoading
                                        ? _getLoadingContainer(height: 20.0)
                                        : Text(
                                            'date posted: ${widget.event!.eventTime}',
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
                )),
          ),
        ),
      ),
    );
  }

  _getLoadingContainer({required double height}) => Container(
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).disabledColor,
          borderRadius: BorderRadius.circular(height * 0.4),
        ),
      );
}

class MobileSearchEventTile extends StatelessWidget {
  final ProductEvent event;

  const MobileSearchEventTile({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => PageManager.of(context).navigateToProductEventPage(event.eventId),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.grey.shade400,
                width: 0.4,
              )),
          height: 100.0,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CircleAvatar(
                  backgroundImage: event.photoImageProvider,
                  backgroundColor: Colors.grey.shade400,
                  child: event.photoUrl == null
                      ? const Icon(
                          Icons.person_sharp,
                          //size: 150.0,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
              Expanded(
                child: Text(event.eventName),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final ProductData productData;
  final Function()? onClick;
  final bool isTileSelected;

  const _ProductTile({
    Key? key,
    required this.productData,
    this.onClick,
    this.isTileSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          onClick?.call();
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: (isTileSelected) ? Colors.purple.shade200 : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade400,
                  backgroundImage: productData.profilePhotoImageProvider,
                  child: productData.profilePhotoImageProvider == null
                      ? const Icon(
                          Icons.person_sharp,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Text(
                    productData.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FavouriteHeartIconWidget extends StatefulWidget {
  final ProductEvent event;

  const FavouriteHeartIconWidget({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  State<FavouriteHeartIconWidget> createState() => _FavouriteHeartIconWidgetState();
}

class _FavouriteHeartIconWidgetState extends State<FavouriteHeartIconWidget> {
  double iconSize = 25.0;
  bool isHovering = false;
  bool isLoading = false;
  late DataManager dataManager;
  bool isFavourite = false;

  @override
  Widget build(BuildContext context) {
    dataManager = Provider.of<DataManager>(context);
    isFavourite = dataManager.isFavouriteEvent(widget.event.eventId);
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
      if (user == null) return;
    }

    setState(() {
      isLoading = true;
    });
    if (isFavourite) {
      if (await FirestoreManager().removeFromFavourite(widget.event.eventId)) isFavourite = !isFavourite;
    } else {
      if (await FirestoreManager().addToFavourite(widget.event)) isFavourite = !isFavourite;
    }
    debugPrint("_HeartIconState build: isFavourite now $isFavourite");
    setState(() {
      isLoading = false;
    });
  }
}
