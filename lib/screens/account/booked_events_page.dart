import 'package:ad/product/product_type.dart';
import 'package:flutter/material.dart';

import '../../product/product_event.dart';
import '../../provider/data_manager.dart';
import '../../routes/route_page_manager.dart';
import '../../utils/constants.dart';
import '../../utils/globals.dart';
import '../home/my_app_bar.dart';

class BookedEventsPage extends StatelessWidget {
  const BookedEventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ProductEvent> bookedEvents = DataManager().bookedEvents;
    debugPrint("BookedEventsPage build: booked events ${bookedEvents.map((e) => e.eventId)}");
    return Scaffold(
      appBar: isMobileView(context) ? const MobileAppBar(text: "Booked Events") : const MyAppBar(showSearchBar: false),
      body: isMobileView(context)
          ? ListView.builder(
              itemCount: bookedEvents.length,
              itemBuilder: (context, index) => _MobileEventTile(
                event: bookedEvents[index],
              ),
            )
          : _DesktopView(events: bookedEvents),
    );
  }
}

class _DesktopView extends StatelessWidget {
  const _DesktopView({Key? key, required this.events}) : super(key: key);
  final List<ProductEvent> events;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: maxScreenWidth,
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Booked Events',
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
                    itemCount: events.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: _DesktopEventTile(
                        event: events[index],
                        onRemove: () {
                          setState(() => events.removeAt(index));
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
    );
  }
}

class _MobileEventTile extends StatefulWidget {
  const _MobileEventTile({Key? key, required this.event}) : super(key: key);

  final ProductEvent event;

  @override
  State<_MobileEventTile> createState() => _MobileEventTileState();
}

class _MobileEventTileState extends State<_MobileEventTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => PageManager.of(context).navigateToProductEventPage(
        widget.event.eventId,
        event: widget.event,
      ),
      splashColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
            color: Theme.of(context).disabledColor,
            width: 1.0,
          )),
        ),
        height: 150.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.event.getCachedImage(context),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Event on dd/MM/YYYY'),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(widget.event.eventName),
                    ],
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 15.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _DesktopEventTile extends StatefulWidget {
  final ProductEvent event;
  final Function? onRemove;

  const _DesktopEventTile({
    Key? key,
    required this.event,
    this.onRemove,
  }) : super(key: key);

  @override
  State<_DesktopEventTile> createState() => _DesktopEventTileState();
}

class _DesktopEventTileState extends State<_DesktopEventTile> {
  bool isHovering = false, isRemoving = false, isRemoveBtnHovering = false;
  Widget image = getRandomTestImage();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => PageManager.of(context).navigateToProductEventPage(
        widget.event.eventId,
        event: widget.event,
      ),
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
                    'Booked Time',
                    widget.event.bookedTime.toString(),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: _getTimeWidget(
                    'Event time',
                    widget.event.eventTime.toString(),
                  ),
                ),
                const Text(
                  'Booked',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 14,
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
}
