import 'package:ad/product/product_type.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class ProductEvent {
  final String _eventId, _eventName, _description, _productId;
  final int _price;
  final DateTime _eventTime, _postedTime;
  final DateTime? _bookedTime;
  final ProductType _type;
  final bool _isBooked;
  final String? _bookedUserId, _photoUrl;
  final ImageProvider? photoImageProvider;

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
    DateTime? bookedTime,
    String? photoUrl,
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
        _bookedUserId = bookedUserId,
        _bookedTime = bookedTime,
        _photoUrl = photoUrl,
        photoImageProvider = (photoUrl != null) ? CachedNetworkImageProvider(photoUrl) : null;

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
        bookedTime: json['bookedTime'] != null ? DateTime.fromMillisecondsSinceEpoch(json['bookedTime']) : null,
        photoUrl: json['photoUrl'],
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
    DateTime? bookedTime,
    String? photoUrl,
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
        bookedTime: bookedTime ?? this.bookedTime,
        photoUrl: photoUrl ?? this.photoUrl,
      );

  ProductEvent canceledInstance() => ProductEvent(
        eventId: eventId,
        eventName: eventName,
        description: description,
        price: price,
        eventTime: eventTime,
        postedTime: postedTime,
        type: type,
        productId: productId,
        isBooked: false,
        bookedUserId: null,
        bookedTime: null,
        photoUrl: photoUrl,
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

  DateTime? get bookedTime => _bookedTime;

  String? get photoUrl => _photoUrl;

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
        'bookedTime': bookedTime?.millisecondsSinceEpoch,
        'photoUrl': photoUrl,
      };
}
