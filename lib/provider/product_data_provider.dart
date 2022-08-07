import 'dart:async';


import 'package:ad/constants.dart';
import 'package:ad/product/product_data.dart';
import 'package:ad/product/product_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'data_manager.dart';

class ProductDataProvider extends ChangeNotifier {
  final List<ProductData> _products;
  final List<ProductEvent> _productEvents = [];
  late DataManager dataManager;

  ProductDataProvider._internal()
      : dataManager = DataManager(),
        _products = DataManager().products;

  factory ProductDataProvider() => ProductDataProvider._internal();

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

  List<ProductEvent> get productEvents => _productEvents;

  StreamSubscription<QuerySnapshot>? productDataStream;

  listenToProductData(ProductType productType) {
    if (productDataStream != null) {
      productDataStream!.cancel();
      productDataStream = null;
    }
    productDataStream = FirebaseFirestore.instance.collection(productType.name).snapshots().listen((event) {
      _products.clear();
      for (QueryDocumentSnapshot<Map> value in event.docs) {
        _products.add(ProductData.fromFirestore(value.data()));
      }
      dataManager.products = _products;
      notifyListeners();
    });
  }

  CollectionReference<Map> getEventRef(ProductType type, String productDataName) =>
      FirebaseFirestore.instance.collection(type.name).doc(productDataName).collection('events');

  StreamSubscription<QuerySnapshot>? eventsStream;

  listenToEvents(ProductType type, String productDataName) {
    if (eventsStream != null) {
      eventsStream!.cancel();
      eventsStream = null;
    }
    _productEvents.clear();
    eventsStream = getEventRef(type, productDataName).snapshots().listen((QuerySnapshot<Map> event) {
      _productEvents.clear();
      for (QueryDocumentSnapshot<Map> value in event.docs) {
        _productEvents.add(ProductEvent.fromFirestore(value.data()));
      }
      notifyListeners();
    });
  }











  // todo remove test code.
  static addProductData(ProductData product, List<ProductEvent> events, ProductType type) async {
    DocumentReference ref = FirebaseFirestore.instance.collection(type.name).doc(product.name);
    await ref.set(product.map);
    CollectionReference eventsRef = ref.collection('events');
    for (ProductEvent event in events) {
      await eventsRef.add(event.map);
    }
  }

  static removeProductData(String productName, ProductType type) async =>
      await FirebaseFirestore.instance.collection(type.name).doc(productName).delete();

  static addProductEvent(String productName, ProductEvent event) async {
    DocumentReference ref = FirebaseFirestore.instance.collection(event.type.name).doc(productName);
    await ref.collection('events').add(event.map);
  }

  static deleteLastProductEvent(String productName, ProductType type) async {
    CollectionReference ref = FirebaseFirestore.instance.collection(type.name).doc(productName).collection('events');
    QuerySnapshot events = await ref.get();

    if (events.docs.isNotEmpty) {
      events.docs.last.reference.delete();
    }
  }
}
