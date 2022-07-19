import 'package:ad/media/firebase/local_user.dart';
import 'package:flutter/foundation.dart';

class FirebaseProvider extends ChangeNotifier {

  static final FirebaseProvider _mInstance = FirebaseProvider._internal();

  FirebaseProvider._internal();

  factory FirebaseProvider() => _mInstance;



  LocalUser? activeUser;

  void updateActiveUser(LocalUser? user) {
    activeUser = user;
    notifyListeners();
  }
}
