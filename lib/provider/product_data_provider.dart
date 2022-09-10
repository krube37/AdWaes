import 'dart:async';

import 'package:ad/constants.dart';
import 'package:ad/firebase/firestore_database.dart';
import 'package:ad/product/product_data.dart';
import 'package:ad/product/product_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'data_manager.dart';

class ProductDataProvider extends ChangeNotifier {
  final List<ProductData> _products;
  final List<ProductEvent> _productEvents = [];
  late DataManager dataManager;
  late FirestoreDatabase firestoreDatabase;
  static ProductDataProvider? _mInstance;

  ProductDataProvider._internal()
      : dataManager = DataManager(),
        firestoreDatabase = FirestoreDatabase(),
        _products = DataManager().products.values.toList();

  factory ProductDataProvider() {
    if (_mInstance != null) {
      _mInstance!._products.addAll(DataManager().products.values);
      return _mInstance!;
    }
    return ProductDataProvider._internal();
  }

  List<ProductData> get products => _products;

  List<ProductEvent> get productEvents => _productEvents;

  listenToProductData(ProductType productType) => firestoreDatabase.listenToProductData(productType, (products) {
        _products
          ..clear()
          ..addAll(products);
        notifyListeners();
      });

  Stream<List<ProductEvent>> listenToEvents(ProductType type, String productDataId) {
    StreamController<List<ProductEvent>> controller = StreamController();
    controller = StreamController();
    firestoreDatabase.listenToEvents(type, productDataId, (productEvents) {
      controller.add(productEvents);
      _productEvents
        ..clear()
        ..addAll(productEvents);
    });
    return controller.stream;
  }

  // todo remove test code.
  static addProductData(ProductData product, List<ProductEvent> events, ProductType type) async {
    DocumentReference ref = FirebaseFirestore.instance.collection(type.name).doc(product.userName);
    await ref.set(product.map);
    CollectionReference eventsRef = FirebaseFirestore.instance.collection('events');
    for (ProductEvent event in events) {
      await eventsRef.doc(event.eventId).set(event.map);
    }
  }

  static removeProductData(String productId, ProductType type) async {
    await FirebaseFirestore.instance.collection(type.name).doc(productId).delete();
    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection('events').where('productId', isEqualTo: productId);
    QuerySnapshot snapshot = await query.get();
    for(QueryDocumentSnapshot ref in snapshot.docs){
      ref.reference.delete();
    }
  }

  static addProductEvent(String productId, ProductEvent event) async {
    DocumentReference ref = FirebaseFirestore.instance.collection('events').doc(event.eventId);
    await ref.set(event.map);
  }

  static deleteLastProductEvent(String productId, ProductType type) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('events');
    QuerySnapshot events = await ref.where(productId, isEqualTo: productId).get();

    if (events.docs.isNotEmpty) {
      events.docs.last.reference.delete();
    }
  }

  static notify() => _mInstance?.notifyListeners();
}
