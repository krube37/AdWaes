import 'package:ad/adwise_user.dart';
import 'package:ad/firebase/firestore_manager.dart';
import 'package:ad/general_settings.dart';
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
  final List<ProductEvent> _favouriteEvents = [];

  List<ProductEvent> get favouriteEvents => _favouriteEvents;

  /// [_favouriteEvents] are arranged in descending order by added time
  /// this method will insert the new element at 0th position, as the event adding now is the latest
  addFavouriteEvent(ProductEvent event) {
    _favouriteEvents.insert(0, event);
  }

  /// clears and re-adds all the favourite event
  refreshFavouriteEventList(List<ProductEvent> events) {
    _favouriteEvents
      ..clear()
      ..addAll(events);
    if (events.isNotEmpty) notifyListeners();
  }

  removeFavouriteEvents(List<String> eventIds) =>
      _favouriteEvents.removeWhere((element) => eventIds.contains(element.eventId));

  bool isFavouriteEvent(String eventId) => _favouriteEvents.map((e) => e.eventId).toList().contains(eventId);

  /// events booked by current user
  final List<ProductEvent> _bookedEvents = [];

  List<ProductEvent> get bookedEvents => _bookedEvents;

  /// [_bookedEvents] are arranged in descending order by booked time
  /// this method will insert the new element at 0th position, as the event booking now is the latest
  addBookedEvent(ProductEvent event) {
    _bookedEvents.insert(0, event);
    notifyListeners();
  }

  refreshBookedEventsList(List<ProductEvent> events) {
    _bookedEvents
      ..clear()
      ..addAll(events);
    notifyListeners();
  }

  removeBookedEvents(List<String> eventIds) =>
      _bookedEvents.removeWhere((element) => eventIds.contains(element.eventId));

  final List<ProductEvent> _recentEvents = [];

  List<ProductEvent> get recentEvents => _recentEvents;

  refreshRecentEvents(List<ProductEvent> events) {
    _recentEvents
      ..clear()
      ..addAll(events);
    notifyListeners();
  }

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
        GeneralSettingsProvider().updateUserSettings(this.user?.settings ?? GeneralSettings.defaultSettings());
        refreshFavouriteEventList(await FirestoreManager().getAllFavouriteEvents());
        refreshBookedEventsList(await FirestoreManager().getAllBookedEvents());
      }
      notifyListeners();
    });
  }

  initialiseUserCreds(AdWiseUser adWiseUser) async {
    user = adWiseUser;
    refreshFavouriteEventList(await FirestoreManager().getAllFavouriteEvents());
    refreshBookedEventsList(await FirestoreManager().getAllBookedEvents());
    notifyListeners();
  }

  signOutCurrentUser(BuildContext context) {
    user = null;
    _favouriteEvents.clear();
    _bookedEvents.clear();
    notifyListeners();
  }
}
