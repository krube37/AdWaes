import '../constants.dart';

class ProductData {
  final String _productId, _name, _description;
  final int _totalEvents;
  final ProductType _type;

  ProductData({
    required String productId,
    required String name,
    required String description,
    int totalEvents = 0,
    required type,
  })  : _productId = productId,
        _name = name,
        _description = description,
        _totalEvents = totalEvents,
        _type = type;

  factory ProductData.fromFirestore(Map json) => ProductData(
        productId: json['productId'],
        name: json['name'],
        description: json['description'],
        totalEvents: json['totalEvents'],
        type: ProductType.values[json['type']],
      );

  String get productId => _productId;

  String get name => _name;

  String get description => _description;

  int get totalEvents => _totalEvents;

  ProductType get type => _type;

  Map<String, dynamic> get map => {
        'productId': _productId,
        'name': _name,
        'description': _description,
        'totalEvents': _totalEvents,
        'type': _type.index,
      };
}
