import '../constants.dart';

class ProductEvent {
  final String _eventName;
  final int _price;
  final DateTime _dateTime;
  final ProductType _type;

  ProductEvent({required String eventName, required int price, required DateTime dateTime, required ProductType type})
      : _eventName = eventName,
        _price = price,
        _dateTime = dateTime,
        _type = type;

  factory ProductEvent.fromFirestore(Map json) => ProductEvent(
      eventName: json['eventName'],
      price: json['price'],
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dateTime']),
      type: ProductType.values[json['type']]);

  String get eventName => _eventName;

  int get price => _price;

  DateTime get dateTime => _dateTime;

  ProductType get type => _type;

  get map => {
        'eventName': eventName,
        'price': price,
        'dateTime': dateTime.millisecondsSinceEpoch,
        'type': type.index,
      };
}
