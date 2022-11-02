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

  Future<bool> deleteUserProfilePic() async {
    debugPrint("FirestoreDatabase deleteUserProfilePic: ");
    AdWiseUser user = DataManager().user!;
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child('userProfilePic/${user.userId}');
    try{
      await reference.delete();
      user = user.copyWith(deleteProfilePic: true);
      return await updateUserDetails(user);
    }catch(e){
      debugPrint("FirestoreDatabase deleteUserProfilePic: exception in deleting profile pic ");
    }
    return false;
  }

  // Future downloadUserProfilePic(String url) async{
  //   FirebaseStorage storage = FirebaseStorage.instance;
  //   Reference reference = storage.ref().child('userProfilePic/${user.userId}');
  // }

  Future<bool> updateNewUserDetails(AdWiseUser user) async => await updateUserDetails(user);

  Future<List<ProductData>> getProductsOfType({required ProductType type}) async {
    final CollectionReference<Map> collectionRef = _mInstance.collection('productData');
    QuerySnapshot<Map> productCollectionData = await collectionRef.where('type', isEqualTo: type.index).get();
    List<ProductData> products = [];
    for (QueryDocumentSnapshot<Map> value in productCollectionData.docs) {
      products.add(ProductData.fromFirestore(value.data()));
    }
    return products;
  }

  StreamSubscription<QuerySnapshot> listenToProductData(
    ProductType productType,
    Function(List<ProductData> productData)? onUpdate,
  ) {
    if (productDataStream != null) {
      productDataStream!.cancel();
      productDataStream = null;
    }
    productDataStream =
        _mInstance.collection('productData').where('type', isEqualTo: productType.index).snapshots().listen((event) {
      List<ProductData> products = [];
      for (QueryDocumentSnapshot<Map> value in event.docs) {
        products.add(ProductData.fromFirestore(value.data()));
      }
      onUpdate?.call(products);
    });
    return productDataStream!;
  }

  StreamSubscription<QuerySnapshot> listenToEvents(
    ProductType type,
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

  Future<ProductEvent?> getEventById(ProductType type, String companyUserName, String eventId) async {
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

  Future<List<MapEntry<ProductData, ProductEvent>>> getRecentEventsWithProductsName() async {
    List<MapEntry<ProductData, ProductEvent>> productDataToEventsMap = [];
    try {
      QuerySnapshot<Map> eventSnapshot =
          await _mInstance.collection(eventsCollectionName).orderBy('postedTime', descending: true).limit(10).get();
      List<ProductEvent> productEvents = [];
      for (QueryDocumentSnapshot<Map> doc in eventSnapshot.docs) {
        productEvents.add(ProductEvent.fromFirestore(doc.data()));
      }
      QuerySnapshot<Map> dataSnapshot = await _mInstance
          .collection('productData')
          .where('userName', whereIn: productEvents.map((e) => e.productId).toList())
          .get();
      int i = 0;
      List<ProductData> productDataList = [];
      for (QueryDocumentSnapshot<Map> doc in dataSnapshot.docs) {
        productDataList.add(ProductData.fromFirestore(doc.data()));
      }

      for (ProductEvent event in productEvents) {
        productDataToEventsMap
            .add(MapEntry(productDataList.firstWhere((element) => element.userName == event.productId), event));
      }
    } catch (e, stack) {
      debugPrint("FirestoreDatabase getRecentEvents: error in getting recent events $e\n$stack");
    }
    return productDataToEventsMap;
  }
}
