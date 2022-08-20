import 'package:ad/AdWiseUser.dart';
import 'package:ad/constants.dart';
import 'package:ad/firebase/firestore_database.dart';
import 'package:ad/product/product_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class DataManager extends ChangeNotifier {
  /// singleton class
  static final DataManager _mInstance = DataManager._internal();

  DataManager._internal();

  factory DataManager() => _mInstance;

  Map<String, ProductData> products = {};
  AdWiseUser? user;
  bool fetchingSigInDetails = false;

  initialize() async {
    if (FirebaseAuth.instance.currentUser != null) {
      user = await FirestoreDatabase().getCurrentUserDetails(FirebaseAuth.instance.currentUser!.uid);
    }
    _listenToUser();
  }

  _listenToUser() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      print("DataManager _listenToUser: user changed ${user?.uid} time ${DateTime.now().millisecondsSinceEpoch}");
      if (user != null) {
        fetchingSigInDetails = true;
        notifyListeners();
        this.user = await FirestoreDatabase().getCurrentUserDetails(user.uid);
        fetchingSigInDetails = false;
      }
      notifyListeners();
    });
  }

  ProductData getProductDataByType(ProductType type) => products.values.firstWhere((element) => element.type == type);
}
