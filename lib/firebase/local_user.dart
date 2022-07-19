import 'package:firebase_auth/firebase_auth.dart';

class LocalUser {
  String uid;
  String? email;
  String? displayName;
  String? photoUrl;
  bool isEmailVerified;

  LocalUser({required this.uid, this.email, this.displayName, this.photoUrl, this.isEmailVerified = false});

  factory LocalUser.fromFirebaseUser(User user) => LocalUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      isEmailVerified: user.emailVerified);
}
