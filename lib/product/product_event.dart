import 'package:ad/product/product_type.dart';

class ProductEvent {
  final String _eventId, _eventName, _description, _productId;
  final int _price;
  final DateTime _eventTime, _postedTime;
  final ProductType _type;
  final bool _isBooked;
  final String? _bookedUserId;

  ProductEvent({
    required String eventId,
    required String eventName,
    required String description,
    required int price,
    required DateTime eventTime,
    required DateTime postedTime,
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
        _eventTime = eventTime,
        _postedTime = postedTime,
        _type = type,
        _productId = productId,
        _isBooked = isBooked,
        _bookedUserId = bookedUserId;

  factory ProductEvent.fromFirestore(Map json) => ProductEvent(
        eventId: json['eventId'],
        eventName: json['eventName'],
        description: json['description'],
        price: json['price'],
        eventTime: DateTime.fromMillisecondsSinceEpoch(json['eventTime']),
        postedTime: DateTime.fromMillisecondsSinceEpoch(json['postedTime']),
        type: ProductType.values[json['type']],
        productId: json['productId'],
        isBooked: json['isBooked'],
        bookedUserId: json['bookedUserId'],
      );

  ProductEvent copyWith({
    String? eventId,
    String? eventName,
    String? description,
    int? price,
    DateTime? eventTime,
    DateTime? postedTime,
    ProductType? type,
    int? productId,
    bool? isBooked,
    String? bookedUserId,
  }) =>
      ProductEvent(
        eventId: eventId ?? this.eventId,
        eventName: eventName ?? this.eventName,
        description: description ?? this.description,
        price: price ?? this.price,
        eventTime: eventTime ?? this.eventTime,
        postedTime: postedTime ?? this.postedTime,
        type: type ?? this.type,
        productId: productId ?? this.productId,
        isBooked: isBooked ?? this.isBooked,
        bookedUserId: bookedUserId ?? this.bookedUserId,
      );

  String get eventId => _eventId;

  String get eventName => _eventName;

  String get description => _description;

  int get price => _price;

  DateTime get eventTime => _eventTime;

  DateTime get postedTime => _postedTime;

  ProductType get type => _type;

  String get productId => _productId;

  bool get isBooked => _isBooked;

  String? get bookedUserId => _bookedUserId;

  get map => {
        'eventId': eventId,
        'eventName': eventName,
        'description': description,
        'price': price,
        'eventTime': eventTime.millisecondsSinceEpoch,
        'postedTime': postedTime.millisecondsSinceEpoch,
        'type': type.index,
        'productId': productId,
        'isBooked': isBooked,
        'bookedUserId': bookedUserId,
      };
}
