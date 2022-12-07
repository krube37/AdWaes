import 'dart:async';
import 'dart:typed_data';

import 'package:ad/adwise_user.dart';
import 'package:ad/product/product_data.dart';
import 'package:ad/product/product_event.dart';
import 'package:ad/provider/data_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import '../product/product_type.dart';

class FirestoreManager {
  final FirebaseFirestore _mInstance;
  final DataManager _dataManager;

  static const usersCollectionName = "users";
  static const eventsCollectionName = "events";
  static const bookedEventsCollectionName = "bookedEvents";
  static const favouriteEventsCollectionName = "favouriteEvents";
  static const productDataCollectionName = 'productData';

  FirestoreManager()
      : _mInstance = FirebaseFirestore.instance,
        _dataManager = DataManager();

  /// returns [AdWiseUser] for the corresponding firebase [User]
  Future<AdWiseUser?> getCurrentUserDetails(User user) async {
    if (FirebaseAuth.instance.currentUser == null) return null;
    DocumentReference<Map<String, dynamic>> ref =
        FirebaseFirestore.instance.collection(usersCollectionName).doc(user.uid);
    DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();
    if (snapshot.data() == null) {
      AdWiseUser newUser = AdWiseUser.newUser(user);
      await updateUserDetails(newUser);
      return newUser;
    }
    return AdWiseUser.fromFirestore(snapshot.data()!);
  }

  /// updates the user details to firestore database
  /// returns true if succeed else false will be returned
  Future<bool> updateUserDetails(AdWiseUser user) async {
    debugPrint("FirestoreDatabase updateUserDetails: ");
    DocumentReference<Map> ref = FirebaseFirestore.instance.collection(usersCollectionName).doc(user.userId);
    try {
      await ref.set(user.map);
      DataManager().user = user;
    } catch (e) {
      return false;
    }
    return true;
  }

  /// updates the user profile picture to firebase storage
  /// returns true if succeed, else false will be returned
  Future<bool> updateUserProfilePic(Uint8List image) async {
    debugPrint("FirestoreDatabase updateUserProfilePic: ");
    AdWiseUser user = DataManager().user!;
    bool isSuccess = false;
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child('userProfilePic/${user.userId}');
    UploadTask uploadTask = reference.putData(image, SettableMetadata(contentType: 'image/jpeg'));

    await uploadTask.whenComplete(() async {
      String url = await reference.getDownloadURL();
      debugPrint("FirestoreDatabase updateUserProfilePic: new photo url $url");
      user = user.copyWith(profilePhotoUrl: url);
      isSuccess = await updateUserDetails(user);
    }).catchError((error) {
      debugPrint("FirestoreDatabase updateUserProfilePic: error in updating profile picture $error");
      isSuccess = false;
    });
    return isSuccess;
  }

  /// deletes the user profile picture stored in firebase storage
  /// returns true if succeeds, else false will be returned
  Future<bool> deleteUserProfilePic() async {
    debugPrint("FirestoreDatabase deleteUserProfilePic: ");
    AdWiseUser user = DataManager().user!;
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child('userProfilePic/${user.userId}');
    try {
      await reference.delete();
      user = user.copyWith(deleteProfilePic: true);
      return await updateUserDetails(user);
    } catch (e) {
      debugPrint("FirestoreDatabase deleteUserProfilePic: exception in deleting profile pic ");
    }
    return false;
  }

  /// fetches and returns list of [ProductData] of the given [ProductType]
  /// returns empty list if not exists or error occurs
  Future<List<ProductData>> getProductsOfType({required ProductType type}) async {
    List<ProductData> products = [];
    try {
      final CollectionReference<Map> collectionRef = _mInstance.collection(productDataCollectionName);
      QuerySnapshot<Map> productCollectionData = await collectionRef.where('type', isEqualTo: type.index).get();
      for (QueryDocumentSnapshot<Map> value in productCollectionData.docs) {
        products.add(ProductData.fromFirestore(value.data()));
      }
    } catch (e) {
      debugPrint("FirestoreManager getProductsOfType: exception in getting list of product data $e");
    }
    return products;
  }

  Future<ProductData?> getProductDataById(String userName) async {
    try {
      final CollectionReference<Map> collectionRef = _mInstance.collection(productDataCollectionName);
      QuerySnapshot<Map> productCollectionData = await collectionRef.where('userName', isEqualTo: userName).get();
      for (QueryDocumentSnapshot<Map> value in productCollectionData.docs) {
        return ProductData.fromFirestore(value.data());
      }
    } catch (e) {
      debugPrint("FirestoreManager getProductById: exception in getting product data of id $userName, ERROR : $e");
    }
    return null;
  }

  StreamSubscription<QuerySnapshot>? productDataStream;

  /// listens to the change of [ProductData] in firestore
  /// if any changes occurs in firestore, returns [productDataStream] which contains new list of [ProductData]
  StreamSubscription<QuerySnapshot> listenToProductData(
    ProductType productType,
    Function(List<ProductData> productData)? onUpdate,
  ) {
    if (productDataStream != null) {
      productDataStream!.cancel();
      productDataStream = null;
    }
    productDataStream = _mInstance
        .collection(productDataCollectionName)
        .where('type', isEqualTo: productType.index)
        .snapshots()
        .listen((event) {
      List<ProductData> products = [];
      for (QueryDocumentSnapshot<Map> value in event.docs) {
        products.add(ProductData.fromFirestore(value.data()));
      }
      onUpdate?.call(products);
    });
    return productDataStream!;
  }

  StreamSubscription<QuerySnapshot>? eventsStream;

  /// listens to the change of [ProductEvent] in firestore
  /// if any changes occurs in firestore, returns [eventsStream] which contains new list of [ProductData]
  StreamSubscription<QuerySnapshot> listenToEvents(
    String companyUserName,
    Function(List<ProductEvent> productEvent)? onUpdate,
  ) {
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

  /// gets all [ProductEvent]s of product id [companyUserName]
  ///
  /// returns empty if no events or error in fetching the events
  Future<List<ProductEvent>> getEventsOfProduct(String companyUserName) async {
    List<ProductEvent> events = [];
    try {
      QuerySnapshot<Map> snapshot =
          await _mInstance.collection(eventsCollectionName).where('productId', isEqualTo: companyUserName).get();

      for (QueryDocumentSnapshot<Map> doc in snapshot.docs) {
        events.add(ProductEvent.fromFirestore(doc.data()));
      }
    } catch (e) {
      debugPrint(
          "FirestoreManager getEventsofProduct: exception in getting events of product id $companyUserName, ERROR : $e");
    }
    return events;
  }

  /// fetches the details of [eventId]
  /// Returns the event in the instance of [ProductEvent]
  /// returns null if there is no details for the given [eventId] in firestore
  Future<ProductEvent?> getEventById(String eventId) async {
    try {
      DocumentSnapshot<Map> data = await _mInstance.collection('events').doc(eventId).get();
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
  /// return new instance of booked [ProductEvent] is booking succeed, or else null will be returned
  Future<ProductEvent?> bookEvent(ProductEvent event) async {
    try {
      event = event.copyWith(
        isBooked: true,
        bookedUserId: FirebaseAuth.instance.currentUser!.uid,
        bookedTime: DateTime.now(),
      );
      // creating event
      await _mInstance
          .collection(usersCollectionName)
          .doc(_dataManager.user!.userId)
          .collection(bookedEventsCollectionName)
          .doc(event.eventId)
          .set(event.map);

      // updating event
      await _mInstance.collection(eventsCollectionName).doc(event.eventId).update(event.map);
      _dataManager.addBookedEvent(event);
      return event;
    } catch (e, stack) {
      debugPrint("FirestoreDatabase updateBookingDetails: error booking event $e\n$stack");
      return null;
    }
  }

  /// first removes the [event] in user bookedEvents location (users/userId/bookedEvents/eventsId)
  /// if success, then updates the [event] at (productName/productCompanyId/events/eventId)
  /// return true if booking cancelled, or else null will be returned
  Future<bool> cancelBookedEvent(ProductEvent event) async {
    try {
      event = event.canceledInstance();
      // removing event
      await _mInstance
          .collection(usersCollectionName)
          .doc(_dataManager.user!.userId)
          .collection(bookedEventsCollectionName)
          .doc(event.eventId)
          .delete();

      // updating event
      await _mInstance.collection(eventsCollectionName).doc(event.eventId).update(event.map);
      _dataManager.removeBookedEvents([event.eventId]);
      return true;
    } catch (e, stack) {
      debugPrint("FirestoreManager unBookEvent: error cancelling booked event $e\n$stack");
      return false;
    }
  }

  /// returns all the booked events of the current user
  /// returns empty list if user not exist or unable to fetch data from firestore
  Future<List<ProductEvent>> getAllBookedEvents() async {
    List<ProductEvent> bookedEvents = [];
    try {
      QuerySnapshot<Map> snapshot = await _mInstance
          .collection(usersCollectionName)
          .doc(_dataManager.user!.userId)
          .collection(bookedEventsCollectionName)
          .get();

      for (QueryDocumentSnapshot<Map> docSnapshot in snapshot.docs) {
        bookedEvents.add(ProductEvent.fromFirestore(docSnapshot.data()));
      }
    } catch (e, stack) {
      debugPrint("FirestoreManager getAllBookedEvents: error in getting booked event $e\n$stack");
    }
    List<ProductEvent> sortedEvents =
        List.from(bookedEvents..sort((e1, e2) => e2.bookedTime!.compareTo(e1.bookedTime!)));
    return sortedEvents;
  }

  /// adds the provided [event] in the current user's favourite events list in firestore
  /// returns true if success, or else false will be returned
  Future<bool> addToFavourite(ProductEvent event) async {
    try {
      // creating event
      await _mInstance
          .collection(usersCollectionName)
          .doc(_dataManager.user!.userId)
          .collection(favouriteEventsCollectionName)
          .doc(event.eventId)
          .set({
        'eventId': event.eventId,
        'addedTime': DateTime.now().millisecondsSinceEpoch,
      });

      _dataManager.addFavouriteEvent(event);
      return true;
    } catch (e, stack) {
      debugPrint("FirestoreDatabase addToFavourite: error in adding to favourite $e\n$stack");
      return false;
    }
  }

  /// removes the [ProductEvent] of [eventId] from the current user's favourite events list in firestore
  /// returns true if successfully removed, or else false will be returned
  Future<bool> removeFromFavourite(String eventId) async {
    try {
      // creating event
      await _mInstance
          .collection(usersCollectionName)
          .doc(_dataManager.user!.userId)
          .collection(favouriteEventsCollectionName)
          .doc(eventId)
          .delete();
      _dataManager.removeFavouriteEvents([eventId]);
      return true;
    } catch (e, stack) {
      debugPrint("FirestoreDatabase addToFavourite: error in adding to favourite $e\n$stack");
      return false;
    }
  }

  /// returns map of favourite eventIds of current user
  /// to the time the event has been added to the favourite list
  /// returns empty map if no events exist or error while fetching the events
  Future<Map<String, int>> _getAllFavouriteEventIds() async {
    Map<String, int> eventsToTimeMap = {};
    try {
      QuerySnapshot<Map> snapshot = await _mInstance
          .collection(usersCollectionName)
          .doc(_dataManager.user!.userId)
          .collection(favouriteEventsCollectionName)
          .get();

      for (QueryDocumentSnapshot<Map> docSnapshot in snapshot.docs) {
        eventsToTimeMap.update(docSnapshot['eventId'], (value) => docSnapshot['addedTime'],
            ifAbsent: () => docSnapshot['addedTime']);
      }
    } catch (e, stack) {
      debugPrint("FirestoreDatabase getAllFavouriteEventIds: Exception in fetching favourite Ids $e\n$stack");
    }
    return eventsToTimeMap;
  }

  /// returns the list of [ProductEvent] sorted by addedTime in descending order
  /// returns empty list if no events are there or error occurs while fetching the events in firestore
  Future<List<ProductEvent>> getAllFavouriteEvents() async {
    Map<ProductEvent, int> productEventsToTimeMap = {};
    Map<String, int> eventIdsToTimeMap = Map.from(await _getAllFavouriteEventIds());

    try {
      QuerySnapshot<Map> eventSnapshot = await _mInstance
          .collection(eventsCollectionName)
          .where('isBooked', isEqualTo: false)
          .where('eventId', whereIn: eventIdsToTimeMap.keys.toList())
          .get();
      for (QueryDocumentSnapshot<Map> doc in eventSnapshot.docs) {
        ProductEvent event = ProductEvent.fromFirestore(doc.data());
        if (eventIdsToTimeMap[event.eventId] != null) {
          productEventsToTimeMap.putIfAbsent(event, () => eventIdsToTimeMap[event.eventId]!);
        }
      }
    } catch (e, stack) {
      debugPrint("FirestoreDatabase getAllFavouriteEvents: error in getting the favourite events $e\n$stack");
    }
    List<ProductEvent> sortedEvents =
        Map.fromEntries(productEventsToTimeMap.entries.toList()..sort((e1, e2) => e2.value.compareTo(e1.value)))
            .keys
            .toList();
    return sortedEvents;
  }

  /// fetches and returns the events recently posted in all [ProductType] category
  /// returns List of MapEntry in which key will be [ProductType] and value will be [ProductData]
  /// returns empty if no recent events or any error while fetching from firestore
  Future<List<MapEntry<ProductEvent, ProductData>>> getRecentEvents() async {
    List<MapEntry<ProductEvent, ProductData>> recentEventsToDataEntryList = [];
    try {
      QuerySnapshot<Map> eventSnapshot = await _mInstance
          .collection(eventsCollectionName)
          .where('isBooked', isEqualTo: false)
          .orderBy('postedTime', descending: true)
          .limit(10)
          .get();
      List<ProductEvent> productEvents = [];
      for (QueryDocumentSnapshot<Map> doc in eventSnapshot.docs) {
        productEvents.add(ProductEvent.fromFirestore(doc.data()));
      }
      QuerySnapshot<Map> dataSnapshot = await _mInstance
          .collection(productDataCollectionName)
          .where('userName', whereIn: productEvents.map((e) => e.productId).toList())
          .get();
      List<ProductData> productDataList = [];
      for (QueryDocumentSnapshot<Map> doc in dataSnapshot.docs) {
        productDataList.add(ProductData.fromFirestore(doc.data()));
      }

      for (ProductEvent event in productEvents) {
        recentEventsToDataEntryList
            .add(MapEntry(event, productDataList.firstWhere((element) => element.userName == event.productId)));
      }
      _dataManager.refreshRecentEvents(recentEventsToDataEntryList.map((e) => e.key).toList());
    } catch (e, stack) {
      debugPrint("FirestoreDatabase getRecentEvents: error in getting recent events $e\n$stack");
    }
    return recentEventsToDataEntryList;
  }

  /// searchTag of [ProductData] (which is name of the productData) will be filtered with the string [value]
  /// returns the filtered list of [ProductData]
  Future<List<ProductData>> getProductDataSearchResults(String value) async {
    if (value.isEmpty) return [];
    value = value.toLowerCase().replaceAll(' ', '');
    List<ProductData> productData = [];
    try {
      QuerySnapshot<Map> snapshot = await _mInstance
          .collection(productDataCollectionName)
          .where('searchTag', isGreaterThanOrEqualTo: value)
          .where('searchTag', isLessThan: '$value\uF7FF')
          .limit(6)
          .get();

      for (QueryDocumentSnapshot<Map> doc in snapshot.docs) {
        productData.add(ProductData.fromFirestore(doc.data()));
      }
    } catch (e) {
      debugPrint("FirestoreManager getSearchResults: exception in getting search results $e");
    }
    return productData;
  }

  /// searchTag of [ProductEvent] (which is eventName of the ProductEvent) will be filtered with the string [value]
  /// returns the filtered list of [ProductEvent]
  Future<List<ProductEvent>> getProductEventSearchResults(String value) async {
    if (value.isEmpty) return [];
    value = value.toLowerCase().replaceAll(' ', '');
    List<ProductEvent> productEvent = [];
    try {
      QuerySnapshot<Map> snapshot = await _mInstance
          .collection(eventsCollectionName)
          .where('searchTag', isGreaterThanOrEqualTo: value)
          .where('searchTag', isLessThan: '$value\uF7FF')
          .limit(6)
          .get();

      for (QueryDocumentSnapshot<Map> doc in snapshot.docs) {
        productEvent.add(ProductEvent.fromFirestore(doc.data()));
      }
    } catch (e) {
      debugPrint("FirestoreManager getSearchResults: exception in getting search results $e");
    }
    return productEvent;
  }
}
