part of product_event_page;

class _MobileView extends StatefulWidget {
  const _MobileView({Key? key, required this.event}) : super(key: key);
  final ProductEvent event;

  @override
  State<_MobileView> createState() => _MobileViewState();
}

class _MobileViewState extends State<_MobileView> {
  bool isBookingBtnLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                _EventImageWidget(event: widget.event),
                _EventContentWidget(event: widget.event),
              ],
            ),
          ),
        ),
        Container(
          height: 80.0,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Theme.of(context).disabledColor,
                width: 1.0,
              ),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 10.0),
              Expanded(
                child: Text('Price: \u20B9${widget.event.price}\n ${widget.event.eventTime}'),
              ),
              _BookButton(event: widget.event),
            ],
          ),
        )
      ],
    );
  }
}

class _EventImageWidget extends StatefulWidget {
  final ProductEvent event;

  const _EventImageWidget({Key? key, required this.event}) : super(key: key);

  @override
  State<_EventImageWidget> createState() => _EventImageWidgetState();
}

class _EventImageWidgetState extends State<_EventImageWidget> {
  bool isBookingBtnLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.2,
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              child: Padding(
                padding: isMobileView(context) ? EdgeInsets.zero : const EdgeInsets.all(8.0),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Container(
                      color: Theme.of(context).disabledColor,
                      child: widget.event.photoImageProvider != null
                          ? Image(
                              image: widget.event.photoImageProvider!,
                              fit: BoxFit.cover,
                            )
                          : const FlutterLogo(),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10.0,
              right: 10.0,
              child: FavouriteHeartIconWidget(
                event: widget.event,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        if (!isMobileView(context))
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: _BookButton(event: widget.event),
              ),
            ],
          )
      ],
    );
  }
}

class _BookButton extends StatefulWidget {
  const _BookButton({Key? key, required this.event}) : super(key: key);
  final ProductEvent event;

  @override
  State<_BookButton> createState() => _BookButtonState();
}

class _BookButtonState extends State<_BookButton> {
  bool isBookingBtnLoading = false;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isBookingBtnLoading,
      child: InkWell(
        onTap: widget.event.isBooked ? _cancelBooking : _bookEvent,
        child: Container(
          margin: const EdgeInsets.all(5.0),
          padding: isMobileView(context)
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 60.0,
                ),
          decoration: BoxDecoration(
              color: widget.event.isBooked ? Colors.red : Colors.orange, borderRadius: BorderRadius.circular(10.0)),
          height: 55.0,
          width: isMobileView(context) ? 150.0 : 200.0,
          child: Center(
            child: isBookingBtnLoading
                ? const AspectRatio(
                    aspectRatio: 1,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.0,
                    ),
                  )
                : Text(
                    widget.event.isBooked ? "CANCEL" : "BOOK NOW",
                    style: const TextStyle(color: Colors.white),
                  ),
          ),
        ),
      ),
    );
  }

  _bookEvent() async {
    if (FirebaseAuth.instance.currentUser == null) {
      setState(() {
        isBookingBtnLoading = true;
      });
      AdWiseUser? user = await SignInManager().showSignInDialog(context);
      if (user == null) {
        setState(() {
          isBookingBtnLoading = false;
        });
        return;
      }
    }
    setState(() {
      isBookingBtnLoading = true;
    });
    debugPrint("ProductEventPage build: booking implementation yet to be completed ");
    ProductEvent? bookedEvent = await FirestoreManager().bookEvent(widget.event);
    if (bookedEvent != null) {
      debugPrint("ProductEventPage build: booking success");
      if (mounted) {
        PageManager.of(context)
          ..popRoute(notify: false)
          ..navigateToBookedEventsPage();
      }
    }
    if (mounted) {
      setState(() {
        isBookingBtnLoading = false;
      });
    }
  }

  _cancelBooking() async {
    PrimaryDialog cancelDialog = PrimaryDialog(context, 'Do you really want to cancel event?',
        description: 'If you cancel this event, it will be available to all the users. Cancel now?',
        yesButton: const PrimaryDialogButton('Proceed'),
        noButton: const PrimaryDialogButton('Back'));

    bool? shouldProceed = await cancelDialog.show();

    if (shouldProceed ?? false) {
      setState(() {
        isBookingBtnLoading = true;
      });

      bool isCanceled = await FirestoreManager().cancelBookedEvent(widget.event);
      debugPrint("_EventImageWidgetState _cancelBooking: event canceled status $isCanceled");

      if (mounted) {
        setState(() {
          isBookingBtnLoading = false;
        });
        PageManager.of(context).navigateToBookedEventsPage();
      }
    }
  }
}

class _EventContentWidget extends StatelessWidget {
  final ProductEvent event;

  const _EventContentWidget({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.eventName,
            style: const TextStyle(
              fontSize: 25.0,
            ),
          ),
          const SizedBox(height: 30.0),
          if (!isMobileView(context))
            Text(
              '\u20B9${event.price}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
            ),
          const SizedBox(height: 20.0),
          Center(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  border: Border.all(width: 0.2, color: Colors.grey), color: Colors.lightBlueAccent.withOpacity(0.1)),
              constraints: const BoxConstraints(maxWidth: 500.0),
              child: Center(
                child: Column(
                  children: const [
                    Text('Contact details'),
                    Text("phone number : 9876543210"),
                    Text("email : testinguser@gmail.com")
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: 'Date of Event: ',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          fontSize: 18,
                        )),
                TextSpan(
                    text: ' ${DateFormat('dd/MM/yyyy').format(event.eventTime)}',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          fontSize: 15,
                        )),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          Container(
            constraints: const BoxConstraints(minHeight: 400.0),
            decoration: const BoxDecoration(),
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: 'Description: \n\n',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        fontSize: 18,
                      )),
              TextSpan(
                  //todo: description
                  //   text: event.description,
                  text: 'The Hindu ePaper is a Hindi language daily newspaper in India which is headquartered'
                      ' in Chennai, Tamil Nadu. In 1878, the Hindi editorial started as a weekly edition'
                      ' and became as a daily newspaper in the year 1989. TheHindu paper is one of the 2'
                      ' Indian newspaper of the record and also it is a 2nd most circulated English'
                      ' language newspaper in India. The most circulated newspaper is Times of India'
                      ' ePaper with the sales of 1.21 million copies as of January – June 2017.'
                      ' The EconomicTimes ePaper also one of the major compititor to the Hindu ePaper. The'
                      ' ePaper Hindu is the largest circulation in the South India region. The Hindu Group'
                      ' owned by a Kasturi and Sons Limited. In 2010, the Hindu paper hired 1600 employees'
                      ' and make the company’s annual turnover of almost 200 million dollars. Most of the'
                      ' Hindu Group revenue comes from the Subscription & Advertising. Hindu newspaper'
                      ' became as the first Indian news paper to offer an Online Edition Services.',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        fontSize: 17,
                        height: 2.0,
                      )),
            ])),
          ),
        ],
      ),
    );
  }
}
