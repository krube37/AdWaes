import 'dart:async';

import 'package:ad/adwise_user.dart';
import 'package:ad/product/product_data.dart';
import 'package:ad/product/product_event.dart';
import 'package:ad/provider/data_manager.dart';
import 'package:ad/provider/product_data_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../constants.dart';

class FirestoreDatabase {
  StreamSubscription<QuerySnapshot>? productDataStream;
  StreamSubscription<QuerySnapshot>? eventsStream;
  final FirebaseFirestore _mInstance;
  final DataManager _dataManager;

  static const usersCollectionName = "users";
  static const eventsCollectionName = "events";
  static const bookedEventsCollectionName = "bookedEvents";
  static const favouriteEventsCollectionName = "favouriteEvents";

  FirestoreDatabase()
      : _mInstance = FirebaseFirestore.instance,
        _dataManager = DataManager();

  Future<AdWiseUser> getCurrentUserDetails(User user) async {
    DocumentReference<Map<String, dynamic>> ref =
        FirebaseFirestore.instance.collection(usersCollectionName).doc(user.uid);
    DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();
    if (snapshot.data() == null) {
      AdWiseUser newUser = AdWiseUser.newUser(user);
      await updateUserDetails(newUser);
      return newUser;
    }
    return AdWiseUser.fromFirestoreDB(snapshot.data()!);
  }

  Future<bool> updateUserDetails(AdWiseUser user) async {
    DocumentReference<Map> ref = FirebaseFirestore.instance.collection(usersCollectionName).doc(user.userId);
    try {
      await ref.set(user.map);
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> updateNewUserDetails(AdWiseUser user) async => await updateUserDetails(user);

  Future<List<ProductData>> getProductsOfType({required ProductType type}) async {
    final CollectionReference<Map> collectionRef = _mInstance.collection(type.name);
    QuerySnapshot<Map> productCollectionData = await collectionRef.get();
    List<ProductData> products = [];
    for (QueryDocumentSnapshot<Map> value in productCollectionData.docs) {
      products.add(ProductData.fromFirestore(value.data()));
    }
    return products;
  }

  StreamSubscription<QuerySnapshot> listenToProductData(
      ProductType productType, Function(List<ProductData> productData)? onUpdate) {
    if (productDataStream != null) {
      productDataStream!.cancel();
      productDataStream = null;
    }
    productDataStream = _mInstance.collection(productType.name).snapshots().listen((event) {
      List<ProductData> products = [];
      for (QueryDocumentSnapshot<Map> value in event.docs) {
        products.add(ProductData.fromFirestore(value.data()));
      }
      onUpdate?.call(products);
    });
    return productDataStream!;
  }

  StreamSubscription<QuerySnapshot> listenToEvents(
      ProductType type, String companyUserName, Function(List<ProductEvent> productEvent)? onUpdate) {
    if (eventsStream != null) {
      eventsStream!.cancel();
      eventsStream = null;
    }
    eventsStream = _mInstance
        .collection(eventsCollectionName)
        .where('isBooked', isEqualTo: false)
        .where('productId', isEqualTo: companyUserName)
        .snapshots()
        .listen((QuerySnapshot<Map> event) {
      List<ProductEvent> productEvents = [];
      for (QueryDocumentSnapshot<Map> value in event.docs) {
        productEvents.add(ProductEvent.fromFirestore(value.data()));
      }
      onUpdate?.call(productEvents);
    });
    return eventsStream!;
  }

  Future<ProductEvent?> getEventById(ProductType type, String companyUserName, String eventId) async {
    try {
      DocumentSnapshot<Map> data = await _mInstance.collection(type.name).doc(eventId).get();
      if (data.data() != null) {
        ProductEvent event = ProductEvent.fromFirestore(data.data()!);
        if (!event.isBooked) return event;
      }
    } catch (e) {
      debugPrint("FirestoreDatabase getEventById: error fetching event $eventId, error $e");
      return null;
    }
    return null;
  }

  /// first creates same [event] in user bookedEvents location (users/userId/bookedEvents/eventsId)
  /// if success, then updates the [event] at (productName/productCompanyId/events/eventId)
  Future<bool> bookEvent(ProductEvent event) async {
    try {
      ProductEvent newEvent = event.copyWith(isBooked: true, bookedUserId: FirebaseAuth.instance.currentUser!.uid);
      // creating event
      await _mInstance
          .collection(usersCollectionName)
          .doc(_dataManager.user!.userId)
          .collection(bookedEventsCollectionName)
          .doc(event.eventId)
          .set(newEvent.map);

      // updating event
      await _mInstance.collection(eventsCollectionName).doc(event.eventId).update(newEvent.map);
      return true;
    } catch (e, stack) {
      debugPrint("FirestoreDatabase updateBookingDetails: error booking event $e\n$stack");
      return false;
    }
  }

  Future<bool> addToFavourite(String eventId) async {
    try {
      // creating event
      await _mInstance
          .collection(usersCollectionName)
          .doc(_dataManager.user!.userId)
          .collection(favouriteEventsCollectionName)
          .doc(eventId)
          .set({'eventId': eventId});

      _dataManager.addFavouriteEventIds([eventId]);
      return true;
    } catch (e, stack) {
      debugPrint("FirestoreDatabase addToFavourite: error in adding to favourite $e\n$stack");
      return false;
    }
  }

  Future<bool> removeFromFavourite(String eventId) async {
    try {
      // creating event
      await _mInstance
          .collection(usersCollectionName)
          .doc(_dataManager.user!.userId)
          .collection(favouriteEventsCollectionName)
          .doc(eventId)
          .delete();
      _dataManager.removeFavouriteIds([eventId]);
      return true;
    } catch (e, stack) {
      debugPrint("FirestoreDatabase addToFavourite: error in adding to favourite $e\n$stack");
      return false;
    }
  }

  Future<Iterable<String>> getAllFavouriteEventIds() async {
    try {
      QuerySnapshot snapshot = await _mInstance
          .collection(usersCollectionName)
          .doc(_dataManager.user!.userId)
          .collection(favouriteEventsCollectionName)
          .get();

      return snapshot.docs.map((e) => e.id);
    } catch (e) {
      debugPrint("FirestoreDatabase getAllFavouriteEventIds: Exception in fetching favourite Ids $e");
    }
    return [];
  }

  Future<List<ProductEvent>> getAllFavouriteEvents() async {
    List<ProductEvent> productEvents = [];
    List<String> eventIds = List.from(await getAllFavouriteEventIds());

    try {
      QuerySnapshot<Map> eventSnapshot =
          await _mInstance.collection(eventsCollectionName).where('eventId', whereIn: eventIds).get();
      for (QueryDocumentSnapshot<Map> doc in eventSnapshot.docs) {
        productEvents.add(ProductEvent.fromFirestore(doc.data()));
      }
    } catch (e, stack) {
      debugPrint("FirestoreDatabase getAllFavouriteEvents: error in getting the favourite events $e\n$stack");
    }
    return productEvents;
  }
}
