library news_paper;

import 'dart:async';


import 'package:ad/constants.dart';
import 'package:ad/product/product_data.dart';
import 'package:ad/product/product_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'data_manager.dart';

part 'product_event_provider.dart';

class ProductDataProvider extends ChangeNotifier {
  final CollectionReference<Map> productCollectionRef = FirebaseFirestore.instance.collection('newsPaper');
  final List<ProductData> _products;
  late DataManager dataManager;

  /// sigleton class
  static ProductDataProvider? mInstance;

  ProductDataProvider._internal()
      : dataManager = DataManager(),
        _products = DataManager().products;

  factory ProductDataProvider() => mInstance ?? (mInstance = ProductDataProvider._internal());

  Future<List<ProductData>> getProductData({required ProductType type}) async {
    final CollectionReference<Map> collectionRef = FirebaseFirestore.instance.collection(type.name);
    QuerySnapshot<Map> papers = await collectionRef.get();
    _products.clear();
    for (QueryDocumentSnapshot<Map> value in papers.docs) {
      _products.add(ProductData.fromFirestore(value.data()));
    }
    dataManager.products = _products;
    return _products;
  }

  List<ProductData> get products => _products;

  StreamSubscription<QuerySnapshot>? newsPapersStream;

  listenToNewsPapers() {
    if (newsPapersStream != null) {
      newsPapersStream!.cancel();
      newsPapersStream = null;
    }
    newsPapersStream = productCollectionRef.snapshots().listen((event) {
      _products.clear();
      for (QueryDocumentSnapshot<Map> value in event.docs) {
        _products.add(ProductData.fromFirestore(value.data()));
      }
      dataManager.products = _products;
      notifyListeners();
    });
  }

  static disposeProvider() {
    mInstance?.dispose();
    mInstance = null;
  }
}
