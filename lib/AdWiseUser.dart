import 'package:firebase_auth/firebase_auth.dart';

class AdWiseUser {
  final String userId, userName, phoneNumber;
  final String? emailId, companyName, gstNumber, businessType, profilePhotoUrl;
  final int? age;
  final bool? isEmailVerified;

  AdWiseUser(
    this.userId,
    this.userName,
    this.phoneNumber, {
    this.emailId,
    this.isEmailVerified,
    this.companyName,
    this.gstNumber,
    this.age,
    this.businessType,
    this.profilePhotoUrl,
  }) : assert(
          (emailId != null || isEmailVerified == false),
          'if isEmailVerified is true, emailId should be provided',
        );

  factory AdWiseUser.fromFirestoreDB(Map<String, dynamic> user) =>
      AdWiseUser(user['userId'], user['userName'], user['phoneNumber'],
          emailId: user['emailId'],
          isEmailVerified: user['isEmailVerified'],
          companyName: user['companyName'],
          gstNumber: user['gstNumber'],
          age: user['age'],
          businessType: user['businessType'],
          profilePhotoUrl: user['profilePhotoUrl']);

  factory AdWiseUser.newUser(User user) => AdWiseUser(
        user.uid,
        'User${user.uid}',
        user.phoneNumber!,
        emailId: user.email,
        isEmailVerified: user.emailVerified,
        profilePhotoUrl: user.photoURL,
      );

  Map<String, dynamic> get map => {
        'userId': userId,
        'userName': userName,
        'phoneNumber': phoneNumber,
        'emailId': emailId,
        'isEmailVerified': isEmailVerified,
        'companyName': companyName,
        'gstNumber': gstNumber,
        'age': age,
        'businessType': businessType,
        'profilePhotoUrl': profilePhotoUrl,
      };
}
