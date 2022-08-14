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

  ProductDataProvider._internal()
      : dataManager = DataManager(),
        _products = DataManager().products;

  factory ProductDataProvider() => ProductDataProvider._internal();

  List<ProductData> get products => _products;

  List<ProductEvent> get productEvents => _productEvents;

  listenToProductData(ProductType productType) => FirestoreDatabase().listenToProductData(productType, (products) {
        _products
          ..clear()
          ..addAll(products);
        notifyListeners();
      });

  listenToEvents(ProductType type, String productDataName) =>
      FirestoreDatabase().listenToEvents(type, productDataName, (productEvents) {
        _productEvents
          ..clear()
          ..addAll(productEvents);
        notifyListeners();
      });

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
