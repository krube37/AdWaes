import 'dart:async';

import 'package:ad/AdWiseUser.dart';
import 'package:ad/product/product_data.dart';
import 'package:ad/product/product_event.dart';
import 'package:ad/provider/data_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants.dart';

class FirestoreDatabase {
  StreamSubscription<QuerySnapshot>? productDataStream;
  final FirebaseFirestore mInstance;

  static const usersCollectionName = "users";
  static const eventsCollectionName = "events";

  FirestoreDatabase() : mInstance = FirebaseFirestore.instance;

  Future<AdWiseUser> getCurrentUserDetails(String userId) async {
    DocumentReference<Map<String, dynamic>> ref =
        FirebaseFirestore.instance.collection(usersCollectionName).doc(userId);
    DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();
    return AdWiseUser.fromFirestoreDB(snapshot.data()!);
  }

  Future<bool> updateUserDetails(AdWiseUser user) async {
    DocumentReference<Map> ref = FirebaseFirestore.instance.collection(usersCollectionName).doc(user.userId);
    await ref.set(user.map);
    return true;
  }

  Future<bool> updateNewUserDetails(AdWiseUser user) async => await updateUserDetails(user);


  Future<List<ProductData>> getProductData({required ProductType type}) async {
    final CollectionReference<Map> collectionRef = mInstance.collection(type.name);
    final DataManager dataManager = DataManager();
    QuerySnapshot<Map> productCollectionData = await collectionRef.get();
    List<ProductData> products = [];
    for (QueryDocumentSnapshot<Map> value in productCollectionData.docs) {
      products.add(ProductData.fromFirestore(value.data()));
    }
    dataManager.products = products;
    return products;
  }

  listenToProductData(ProductType productType, Function(List<ProductData> productData)? onUpdate) {
    DataManager dataManager = DataManager();
    if (productDataStream != null) {
      productDataStream!.cancel();
      productDataStream = null;
    }
    productDataStream = mInstance.collection(productType.name).snapshots().listen((event) {
      List<ProductData> products = [];
      for (QueryDocumentSnapshot<Map> value in event.docs) {
        products.add(ProductData.fromFirestore(value.data()));
      }
      dataManager.products = products;
      onUpdate?.call(products);
    });
  }

  CollectionReference<Map> getEventCollectionRef(ProductType type, String productDataName) =>
      mInstance.collection(type.name).doc(productDataName).collection(eventsCollectionName);

  StreamSubscription<QuerySnapshot>? eventsStream;

  listenToEvents(ProductType type, String productDataName, Function(List<ProductEvent> productEvent)? onUpdate) {
    if (eventsStream != null) {
      eventsStream!.cancel();
      eventsStream = null;
    }
    eventsStream = getEventCollectionRef(type, productDataName).snapshots().listen((QuerySnapshot<Map> event) {
      List<ProductEvent> productEvents = [];
      for (QueryDocumentSnapshot<Map> value in event.docs) {
        productEvents.add(ProductEvent.fromFirestore(value.data()));
      }
      onUpdate?.call(productEvents);
    });
  }
}
