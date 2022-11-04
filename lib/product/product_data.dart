import 'package:ad/product/product_type.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class ProductData {
  final String _userName, _name, _description;
  final int _totalEvents;
  final ProductType _type;
  final String? _profilePhotoUrl;
  final ImageProvider? profilePhotoImageProvider;

  ProductData({
    required String userName,
    required String name,
    required String description,
    int totalEvents = 0,
    required type,
    String? profilePhotoUrl,
  })  : _userName = userName,
        _name = name,
        _description = description,
        _totalEvents = totalEvents,
        _type = type,
        _profilePhotoUrl = profilePhotoUrl,
        profilePhotoImageProvider = (profilePhotoUrl != null) ? CachedNetworkImageProvider(profilePhotoUrl) : null;

  factory ProductData.fromFirestore(Map json) => ProductData(
        userName: json['userName'],
        name: json['name'],
        description: json['description'],
        totalEvents: json['totalEvents'],
        type: ProductType.values[json['type']],
        profilePhotoUrl: json['profilePhotoUrl'],
      );

  String get userName => _userName;

  String get name => _name;

  String get description => _description;

  int get totalEvents => _totalEvents;

  ProductType get type => _type;

  String? get profilePhotoUrl => _profilePhotoUrl;

  Map<String, dynamic> get map => {
        'userName': userName,
        'name': name,
        'description': description,
        'totalEvents': totalEvents,
        'type': type.index,
        'profilePhotoUrl': profilePhotoUrl,
      };
}
