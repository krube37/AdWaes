import 'package:ad/globals.dart';
import 'package:ad/product/product_event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductEventPage extends StatelessWidget {
  final ProductEvent _event;

  const ProductEventPage({Key? key, required ProductEvent event})
      : _event = event,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: getAppBar(screenSize),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: Container(
            constraints: BoxConstraints(
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
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      _event.eventName,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 800,
                        maxHeight: 700,
                      ),
                      decoration: BoxDecoration(
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
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Text(
                            '\u20B9${_event.price}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          margin: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Text('Date of Event : ${DateFormat('dd/MM/YYYY').format(_event.dateTime)}'),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          margin: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Text('Contact details'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    margin: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: 'Description: \n\n', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

class _CustomCard extends StatelessWidget {
  const _CustomCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
