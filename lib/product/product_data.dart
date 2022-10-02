import 'package:ad/product/product_type.dart';

import '../constants.dart';

class ProductData {
  final String _userName, _name, _description;
  final int _totalEvents;
  final ProductType _type;

  ProductData({
    required String userName,
    required String name,
    required String description,
    int totalEvents = 0,
    required type,
  })  : _userName = userName,
        _name = name,
        _description = description,
        _totalEvents = totalEvents,
        _type = type;

  factory ProductData.fromFirestore(Map json) => ProductData(
        userName: json['userName'],
        name: json['name'],
        description: json['description'],
        totalEvents: json['totalEvents'],
        type: ProductType.values[json['type']],
      );

  String get userName => _userName;

  String get name => _name;

  String get description => _description;

  int get totalEvents => _totalEvents;

  ProductType get type => _type;

  Map<String, dynamic> get map => {
        'userName': _userName,
        'name': _name,
        'description': _description,
        'totalEvents': _totalEvents,
        'type': _type.index,
      };
}
