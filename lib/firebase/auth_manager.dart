import 'package:ad/firebase/api_response.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../provider/data_manager.dart';

class AuthManager {
  /// singleton class
  static AuthManager mInstance = AuthManager._internal();

  AuthManager._internal();

  factory AuthManager() => mInstance;

  final FirebaseAuth auth = FirebaseAuth.instance;

  // Stream<LocalUser?> get onAuthStateChange =>
  //     auth.authStateChanges().map((event) => event != null ? LocalUser.fromFirebaseUser(event) : null);

  // Future<FirebaseResult> createUser(String email, String password) async {
  //   FirebaseProvider provider = FirebaseProvider();
  //   try {
  //     UserCredential credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
  //
  //     // await value.user!.sendEmailVerification();
  //     // print("AuthManager createUserWithEmailPassword: success user email sent");
  //     // auth
  //     //     .sendSignInLinkToEmail(
  //     //         email: email, actionCodeSettings: ActionCodeSettings(url: 'localhost', handleCodeInApp: true))
  //     //     .catchError((error) {
  //     //   print("AuthManager createUserWithEmailPassword: check error in signin intent too $error");
  //     // });
  //     // final user = auth.currentUser;
  //     // print("AuthManager createUserWithEmailPassword: checkzzz current user $user");
  //     // await user!.sendEmailVerification()
  //     //   .catchError((error) => print("AuthManager createUserWithEmailPassword: checkzzzz on error $error"));
  //
  //     print("AuthManager createUserWithEmailPassword: User created ");
  //     if (credential.user == null) return FirebaseResult.somethingWentWrong;
  //     provider.updateActiveUser(LocalUser.fromFirebaseUser(credential.user!));
  //     return FirebaseResult.success;
  //   } catch (e) {
  //     print("AuthManager createUserWithEmailPassword: Exception in creating user $e");
  //     return FirebaseResult.somethingWentWrong;
  //   }
  // }

  // Future<bool> signInWithEmail(String email, String password) async {
  //   try {
  //     UserCredential cred = await auth.signInWithEmailAndPassword(email: email, password: password);
  //     print("AuthManager signInWithEmailPassword: sigin succeeded ${cred.toString()}");
  //     return true;
  //   } catch (e, stack) {
  //     print("AuthManager signInWithEmailPassword: signin failed $e\n$stack");
  //     return false;
  //   }
  // }

  // Future<bool> signInWithGoogle() async {
  //   try {
  //     GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  //     final AuthCredential credential =
  //         GoogleAuthProvider.credential(accessToken: googleAuth!.accessToken, idToken: googleAuth.idToken);
  //     final authResult = await auth.signInWithCredential(credential);
  //     print("AuthManager signInWithGoogle: google signed in $authResult");
  //     return true;
  //   } catch (e) {
  //     print("AuthManager signInWithGoogle: firebase exception $e");
  //     return false;
  //   }
  // }

  Future<ApiResponse<ConfirmationResult>> signInWithPhoneNumber(String phoneNumber) async {
    debugPrint("AuthManager signInWithPhoneNumber: ");
    try{
      ConfirmationResult result = await auth.signInWithPhoneNumber(phoneNumber);
      return ApiResponse.success(data: result);
    }catch(e){
      debugPrint("AuthManager signInWithPhoneNumber: error signing in with phone number $e");
      return ApiResponse.error(errorMessage: e.toString());
    }
  }

  Future<ApiResponse<void>> signOut(BuildContext context) async {
    try {
      await auth.signOut().then((value) => DataManager().removeUserBelongings(context));
      debugPrint("AuthManager signOut: sigined out successfully ");
      return ApiResponse.success();
    } catch (e) {
      debugPrint("AuthManager signOut: unable to Sign out $e");
      return ApiResponse.error(errorMessage: e.toString());
    }
  }

  Future<ApiResponse<void>> addEmailAddress(String email) async {
    try{
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: 'kjbhwcqokkjwecbj');

      UserCredential? cred = await auth.currentUser?.linkWithCredential(credential);
      return ApiResponse.success();
    }catch(e){
      debugPrint("AuthManager addEmailAddress: error in adding email address $e");
      return ApiResponse.error(errorMessage: e.toString());
    }
  }

  Future<ApiResponse<void>> verifyEmailAddress(String email) async {
    await addEmailAddress(email);
    throw UnimplementedError();
    return ApiResponse.success();
  }
}
