import 'package:ad/event.dart';

class NewsPaperEvent extends Event {

  final String _eventName;
  final String _eventSpot;
  final int _price;
  final int _pageNumber;

  NewsPaperEvent(String eventName, String eventSpot, int price, int pageNumber, {required super.dateTime})
      : _eventName = eventName,
        _eventSpot = eventSpot,
        _price = price,
        _pageNumber = pageNumber;

  factory NewsPaperEvent.fromFirestore(Map json) =>
      NewsPaperEvent(json['eventName'], json['eventSpot'], json['price'], json['pageNumber'],
          dateTime: DateTime.fromMillisecondsSinceEpoch(json['dateTime']));

  get eventName => _eventName;

  get eventSpot => _eventSpot;

  get price => _price;

  get pageNumber => _pageNumber;

  get map => {
        'dateTime': dateTime.millisecondsSinceEpoch,
        'eventName': eventName,
        'eventSpot': eventSpot,
        'price': price,
        'pageNumber': pageNumber
      };
}
