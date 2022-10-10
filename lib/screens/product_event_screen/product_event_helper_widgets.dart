part of product_event_page;

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
    Size screenSize = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
        margin: const EdgeInsets.only(bottom: 20.0),
        width: (min(screenSize.width, maxScreenWidth)) * 0.40,
        child: Column(
          children: [
            Container(
              height: 450.0,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.2,
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              // todo : put event image here
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  '../assets/images/photography.jpeg',
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: InkWell(
                    onTap: _onPressed,
                    child: Container(
                      margin: const EdgeInsets.all(5.0),
                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
                      height: 55.0,
                      width: 200.0,
                      color: Colors.orange,
                      child: Center(
                          child: isBookingBtnLoading
                              ? const AspectRatio(
                                  aspectRatio: 1,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.0,
                                  ),
                                )
                              : const Text(
                                  "BOOK NOW",
                                  style: TextStyle(color: Colors.white),
                                )),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _onPressed() async {
    if (isBookingBtnLoading) return;
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
    // todo: book event
    debugPrint("ProductEventPage build: booking implementation yet to be completed ");
    bool isBookingSuccess = await FirestoreDatabase().bookEvent(widget.event);
    debugPrint("ProductEventPage build: booking success $isBookingSuccess");
    setState(() {
      isBookingBtnLoading = false;
    });
  }
}

class _EventContentWidget extends StatelessWidget {
  final ProductEvent event;

  const _EventContentWidget({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      color: Colors.white,
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
            padding: const EdgeInsets.all(30.0),
            width: (min(screenSize.width, maxScreenWidth)) * 0.60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  // todo: place eventName here
                  //_event.eventName,
                  "The Product Event Name",
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                ),
                const SizedBox(height: 30.0),
                Text(
                  '\u20B9${event.price}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
                ),
                const SizedBox(height: 20.0),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.2, color: Colors.grey),
                        color: Colors.lightBlueAccent.withOpacity(0.1)),
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
                      const TextSpan(
                        text: 'Date of Event: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      TextSpan(text: ' ${DateFormat('dd/MM/yyyy').format(event.dateTime)}'),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                //todo : put event description here
                Container(
                  decoration: const BoxDecoration(),
                  child: RichText(
                      text: const TextSpan(children: [
                    TextSpan(
                        text: 'Description: \n\n',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54)),
                    TextSpan(
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
                        style: TextStyle(height: 2.0, fontSize: 17)),
                  ])),
                ),
              ],
            )),
      ),
    );
  }
}
