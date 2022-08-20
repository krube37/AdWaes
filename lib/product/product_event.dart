import '../constants.dart';

class ProductEvent {
  final String _eventId, _eventName, _description, _productId;
  final int _price;
  final DateTime _dateTime;
  final ProductType _type;
  final bool _isBooked;
  final String? _bookedUserId;

  ProductEvent({
    required String eventId,
    required String eventName,
    required String description,
    required int price,
    required DateTime dateTime,
    required ProductType type,
    required productId,
    isBooked = false,
    String? bookedUserId,
  })  : assert((!isBooked || bookedUserId != null),
            'if the event is booked, then should provide the [bookedUserId] who booked this event'),
        _eventId = eventId,
        _eventName = eventName,
        _description = description,
        _price = price,
        _dateTime = dateTime,
        _type = type,
        _productId = productId,
        _isBooked = isBooked,
        _bookedUserId = bookedUserId;

  factory ProductEvent.fromFirestore(Map json) => ProductEvent(
        eventId: json['eventId'],
        eventName: json['eventName'],
        description: json['description'],
        price: json['price'],
        dateTime: DateTime.fromMillisecondsSinceEpoch(json['dateTime']),
        type: ProductType.values[json['type']],
        productId: json['productId'],
        isBooked: json['isBooked'],
        bookedUserId: json['bookedUserId'],
      );

  String get eventId => _eventId;

  String get eventName => _eventName;

  String get description => _description;

  int get price => _price;

  DateTime get dateTime => _dateTime;

  ProductType get type => _type;

  String get productId => _productId;

  bool get isBooked => _isBooked;

  String? get bookedUserId => _bookedUserId;

  get map => {
        'eventId': eventId,
        'eventName': eventName,
        'description': description,
        'price': price,
        'dateTime': dateTime.millisecondsSinceEpoch,
        'type': type.index,
        'productId': productId,
        'isBooked': isBooked,
        'bookedUserId': bookedUserId,
      };
}
