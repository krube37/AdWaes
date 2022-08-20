import 'dart:async';

import 'package:ad/AdWiseUser.dart';
import 'package:ad/product/product_data.dart';
import 'package:ad/product/product_event.dart';
import 'package:ad/provider/data_manager.dart';
import 'package:ad/provider/product_data_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants.dart';

class FirestoreDatabase {
  StreamSubscription<QuerySnapshot>? productDataStream;
  StreamSubscription<QuerySnapshot>? eventsStream;
  final FirebaseFirestore _mInstance;
  final DataManager _dataManager;

  static const usersCollectionName = "users";
  static const eventsCollectionName = "events";
  static const bookedEventsCollectionName = "bookedEvents";

  FirestoreDatabase()
      : _mInstance = FirebaseFirestore.instance,
        _dataManager = DataManager();

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
    final CollectionReference<Map> collectionRef = _mInstance.collection(type.name);
    final DataManager dataManager = DataManager();
    QuerySnapshot<Map> productCollectionData = await collectionRef.get();
    List<ProductData> products = [];
    for (QueryDocumentSnapshot<Map> value in productCollectionData.docs) {
      products.add(ProductData.fromFirestore(value.data()));
    }
    for (var element in products) {
      dataManager.products.update(element.userName, (value) => element, ifAbsent: ()=> element);
    }
    return products;
  }

  StreamSubscription<QuerySnapshot> listenToProductData(
      ProductType productType, Function(List<ProductData> productData)? onUpdate) {
    DataManager dataManager = DataManager();
    if (productDataStream != null) {
      productDataStream!.cancel();
      productDataStream = null;
    }
    productDataStream = _mInstance.collection(productType.name).snapshots().listen((event) {
      List<ProductData> products = [];
      for (QueryDocumentSnapshot<Map> value in event.docs) {
        products.add(ProductData.fromFirestore(value.data()));
      }
      for (var element in products) {
        dataManager.products.update(element.userName, (value) => element, ifAbsent: ()=> element);
      }
      onUpdate?.call(products);
    });
    return productDataStream!;
  }

  CollectionReference<Map> getEventCollectionRef(ProductType type, String productDataId) =>
      _mInstance.collection(type.name).doc(productDataId).collection(eventsCollectionName);

  StreamSubscription<QuerySnapshot> listenToEvents(
      ProductType type, String productDataId, Function(List<ProductEvent> productEvent)? onUpdate) {
    if (eventsStream != null) {
      eventsStream!.cancel();
      eventsStream = null;
    }
    eventsStream = getEventCollectionRef(type, productDataId).snapshots().listen((QuerySnapshot<Map> event) {
      List<ProductEvent> productEvents = [];
      for (QueryDocumentSnapshot<Map> value in event.docs) {
        productEvents.add(ProductEvent.fromFirestore(value.data()));
      }
      onUpdate?.call(productEvents);
    });
    return eventsStream!;
  }

  Future<ProductEvent?> getEventById(ProductType type, String eventId) async {
    try {
      // getEventCollectionRef(type, productDataId)
    } catch (e) {
      print("FirestoreDatabase getEventById: error fetching event $eventId, erro $e");
      return null;
    }
  }

  /// first creates same [event] in user bookedEvents location (users/userId/bookedEvents/eventsId)
  /// if success, then deleted the [event] from (productName/productCompanyId/events/eventId)
  Future<bool> bookEvent(ProductEvent event) async {
    try {
      // creating event
      await _mInstance
          .collection(usersCollectionName)
          .doc(_dataManager.user!.userId)
          .collection(bookedEventsCollectionName)
          .doc(event.eventId)
          .set(event.map);

      // deleting event
      await _mInstance
          .collection(event.type.name)
          .doc(event.productId)
          .collection(eventsCollectionName)
          .doc(event.eventId)
          .delete();
      // ProductDataProvider.notify();
      return true;
    } catch (e, stack) {
      print("FirestoreDatabase updateBookingDetails: error booking event $e\n$stack");
      return false;
    }
  }
}
