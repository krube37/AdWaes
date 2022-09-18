import 'package:ad/adwise_user.dart';
import 'package:ad/firebase/firestore_database.dart';
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
  final Set<String> _favouriteEventIds = {};

  get favouriteEventIds => _favouriteEventIds;

  addFavouriteEventIds(List<String> eventIds) => _favouriteEventIds.addAll(eventIds);

  removeFavouriteIds(List<String> eventIds) => _favouriteEventIds.removeAll(eventIds);

  isFavouriteId(String eventId) => _favouriteEventIds.contains(eventId);

  initialize() async {
    if (FirebaseAuth.instance.currentUser != null) {
      user = await FirestoreDatabase().getCurrentUserDetails(FirebaseAuth.instance.currentUser!);
    }
    _favouriteEventIds.addAll(await FirestoreDatabase().getAllFavouriteEventIds());
    _listenToUser();
  }

  _listenToUser() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      debugPrint("DataManager _listenToUser: user changed ${user?.uid} time ${DateTime.now().millisecondsSinceEpoch}");
      if (user != null) {
        fetchingSigInDetails = true;
        notifyListeners();
        this.user = await FirestoreDatabase().getCurrentUserDetails(user);
        fetchingSigInDetails = false;
      }
      notifyListeners();
    });
  }

  initialiseUserCreds(AdWiseUser adWiseUser) async {
    user = adWiseUser;
    _favouriteEventIds.addAll(await FirestoreDatabase().getAllFavouriteEventIds());
    notifyListeners();
  }

  removeUserBelongings(BuildContext context) {
    user = null;
    _favouriteEventIds.clear();
    notifyListeners();
  }
}
