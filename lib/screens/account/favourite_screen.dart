part of account_library;

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ProductEvent> favouriteEvents = DataManager().favouriteEvents;
    return Scaffold(
      appBar: const MyAppBar(showSearchBar: false),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: maxScreenWidth,
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Favourite Events',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: favouriteEvents.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: _FavouriteEventTile(
                          event: favouriteEvents[index],
                          onRemove: () {
                            setState(() => favouriteEvents = DataManager().favouriteEvents);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FavouriteEventTile extends StatefulWidget {
  final ProductEvent event;
  final Function? onRemove;

  const _FavouriteEventTile({
    Key? key,
    required this.event,
    this.onRemove,
  }) : super(key: key);

  @override
  State<_FavouriteEventTile> createState() => _FavouriteEventTileState();
}

class _FavouriteEventTileState extends State<_FavouriteEventTile> {
  bool isHovering = false, isRemoving = false, isRemoveBtnHovering = false;
  Widget image = getRandomTestImage();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => PageManager.of(context).navigateToProductEventPage(widget.event.eventId),
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovering = true),
        onExit: (_) => setState(() => isHovering = false),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(
              color: Colors.grey.shade400,
              width: 0.2,
            ),
          ),
          elevation: isHovering ? 5 : 0,
          child: Container(
            margin: const EdgeInsets.all(8.0),
            height: 130.0,
            child: Row(
              children: [
                SizedBox(
                  height: 114.0,
                  width: 150.0,
                  child: image,
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.event.type.getDisplayName(),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(widget.event.eventName)
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      '\u20B9${widget.event.price}',
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _getTimeWidget(
                    'Posted Time',
                    widget.event.postedTime.toString(),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _getTimeWidget(
                    'Event time',
                    widget.event.eventTime.toString(),
                  ),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: _removeFromFavourite,
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return MouseRegion(
                        onEnter: (_) => setState(() => isRemoveBtnHovering = true),
                        onExit: (_) => setState(() => isRemoveBtnHovering = false),
                        child: SizedBox(
                          height: 15.0,
                          width: 60.0,
                          child: Center(
                            child: isRemoving
                                ? const AspectRatio(
                                    aspectRatio: 1,
                                    child: CircularProgressIndicator(
                                      color: Colors.red,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    'Remove',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: isRemoveBtnHovering ? 15 : 14,
                                    ),
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getTimeWidget(String title, String time) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18.0),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(time)
        ],
      );

  _removeFromFavourite() async {
    setState(() => isRemoving = true);
    bool isSuccess = await FirestoreManager().removeFromFavourite(widget.event.eventId);
    if (isSuccess) {
      isRemoving = false;
      widget.onRemove?.call();
    } else {
      // todo: show toast
    }
  }
}
