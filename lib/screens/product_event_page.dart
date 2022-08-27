import 'package:ad/AdWiseUser.dart';
import 'package:ad/firebase/firestore_database.dart';
import 'package:ad/globals.dart';
import 'package:ad/product/product_event.dart';
import 'package:ad/screens/home/my_app_bar.dart';
import 'package:ad/screens/sign_in/sign_in_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductEventPage extends StatelessWidget {
  final ProductEvent _event;

  const ProductEventPage({Key? key, required ProductEvent event})
      : _event = event,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isBookingBtnLoading = false;
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const MyAppBar(),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 800,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      _event.eventName,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: 800,
                        maxHeight: 700,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset('../assets/images/sample3.jpg'),
                      ),
                    ),
                  ),
                  Center(
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          margin: const EdgeInsets.all(20.0),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Text(
                            '\u20B9${_event.price}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          margin: const EdgeInsets.all(20.0),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Text('Date of Event : ${DateFormat('dd/MM/YYYY').format(_event.dateTime)}'),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          margin: const EdgeInsets.all(20.0),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: const Text('Contact details'),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          margin: const EdgeInsets.all(20.0),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: _BookButton(
                            event: _event,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    margin: const EdgeInsets.all(20.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: RichText(
                        text: const TextSpan(children: [
                      TextSpan(text: 'Description: \n\n', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                              '     The Hindu ePaper is a Hindi language daily newspaper in India which is headquartered'
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BookButton extends StatefulWidget {
  final ProductEvent event;

  const _BookButton({Key? key, required this.event}) : super(key: key);

  @override
  State<_BookButton> createState() => _BookButtonState();
}

class _BookButtonState extends State<_BookButton> {
  bool isBookingBtnLoading = false;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isBookingBtnLoading,
      child: ElevatedButton(
        onPressed: _onPressed,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: isBookingBtnLoading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : const Text('Book'),
        ),
      ),
    );
  }

  _onPressed() async {
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
    SnackBar snackBar = const SnackBar(
      content: Text('Successfully logged in'),
      behavior: SnackBarBehavior.floating,
      width: 500.0,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    debugPrint("ProductEventPage build: booking success $isBookingSuccess");
    setState(() {
      isBookingBtnLoading = false;
    });
  }
}
