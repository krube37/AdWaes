import 'package:ad/adwise_user.dart';
import 'package:ad/firebase/firestore_manager.dart';
import 'package:ad/product/product_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class DataManager extends ChangeNotifier {
  /// singleton class
  static final DataManager _mInstance = DataManager._internal();

  DataManager._internal();

  factory DataManager() => _mInstance;

  /// notifies the listening widgets
  static notify() => _mInstance.notifyListeners();

  AdWiseUser? user;
  bool isNewUser = false;
  bool fetchingSigInDetails = false;

  /// favourite event ids of current user
  final Map<String, ProductEvent> _favouriteEvents = {};

  List<ProductEvent> get favouriteEvents => _favouriteEvents.values.toList();

  addFavouriteEvents(List<ProductEvent> events) {
    for (ProductEvent event in events) {
      _favouriteEvents.update(event.eventId, (value) => event, ifAbsent: () => event);
    }
  }

  removeFavouriteEvents(List<String> eventIds) => _favouriteEvents.removeWhere((key, value) => eventIds.contains(key));

  bool isFavouriteEvent(String eventId) => _favouriteEvents.containsKey(eventId);

  initialize() async {
    if (FirebaseAuth.instance.currentUser != null) {
      user = await FirestoreManager().getCurrentUserDetails(FirebaseAuth.instance.currentUser!);
    }
    _listenToUser();
  }

  _listenToUser() {
    FirebaseAuth.instance.userChanges().listen((user) async {
      debugPrint("DataManager _listenToUser: user changed ${user?.uid} time ${DateTime.now().millisecondsSinceEpoch}");
      if (user != null) {
        fetchingSigInDetails = true;
        notifyListeners();
        this.user = await FirestoreManager().getCurrentUserDetails(user);
        fetchingSigInDetails = false;
        addFavouriteEvents(await FirestoreManager().getAllFavouriteEvents());
      }
      notifyListeners();
    });
  }

  initialiseUserCreds(AdWiseUser adWiseUser) async {
    user = adWiseUser;
    addFavouriteEvents(await FirestoreManager().getAllFavouriteEvents());
    notifyListeners();
  }

  removeUserBelongings(BuildContext context) {
    user = null;
    _favouriteEvents.clear();
    notifyListeners();
  }
}
