import '../constants.dart';

class ProductEvent {
  final String _eventId;
  final String _eventName;
  final int _price;
  final DateTime _dateTime;
  final ProductType _type;
  final String _productId;

  ProductEvent(
      {required String eventId,
      required String eventName,
      required int price,
      required DateTime dateTime,
      required ProductType type,
      required productId})
      : _eventId = eventId,
        _eventName = eventName,
        _price = price,
        _dateTime = dateTime,
        _type = type,
        _productId = productId;

  factory ProductEvent.fromFirestore(Map json) => ProductEvent(
      eventId: json['eventId'],
      eventName: json['eventName'],
      price: json['price'],
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dateTime']),
      type: ProductType.values[json['type']],
      productId: json['productId']);

  String get eventId => _eventId;

  String get eventName => _eventName;

  int get price => _price;

  DateTime get dateTime => _dateTime;

  ProductType get type => _type;

  String get productId => _productId;

  get map => {
        'eventId': eventId,
        'eventName': eventName,
        'price': price,
        'dateTime': dateTime.millisecondsSinceEpoch,
        'type': type.index,
        'productId': productId
      };
}
