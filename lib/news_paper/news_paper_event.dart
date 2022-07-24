
class NewsPaperEvent {
  final String _eventName;
  final String _eventSpot;
  final int _price;
  final int _pageNumber;
  final DateTime _dateTime;

  NewsPaperEvent(String eventName, String eventSpot, int price, int pageNumber, DateTime dateTime)
      : _eventName = eventName,
        _eventSpot = eventSpot,
        _price = price,
        _pageNumber = pageNumber,
        _dateTime = dateTime;

  factory NewsPaperEvent.fromFirestore(Map json) => NewsPaperEvent(json['eventName'], json['eventSpot'], json['price'],
      json['pageNumber'], DateTime.fromMillisecondsSinceEpoch(json['dateTime']));

  get eventName => _eventName;

  get eventSpot => _eventSpot;

  get price => _price;

  get pageNumber => _pageNumber;

  get dateTime => _dateTime;

  get map => {
        'dateTime': dateTime.millisecondsSinceEpoch,
        'eventName': eventName,
        'eventSpot': eventSpot,
        'price': price,
        'pageNumber': pageNumber
      };
}
