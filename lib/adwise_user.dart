import 'package:firebase_auth/firebase_auth.dart';

class AdWiseUser {
  final String userId, phoneNumber;

  final String? firstName, lastName, emailId, companyName, gstNumber, businessType, profilePhotoUrl;
  final DateTime? age;
  final bool? isEmailVerified;

  AdWiseUser(
    this.userId,
    this.phoneNumber, {
    this.firstName,
    this.emailId,
    this.isEmailVerified,
    this.companyName,
    this.gstNumber,
    this.age,
    this.businessType,
    this.profilePhotoUrl,
    this.lastName,
  }) : assert(
          (emailId != null || isEmailVerified == false),
          'if isEmailVerified is true, emailId should be provided',
        );

  factory AdWiseUser.fromFirestoreDB(Map<String, dynamic> user) => AdWiseUser(
        user['userId'],
        user['phoneNumber'],
        firstName: user['firstName'],
        emailId: user['emailId'],
        isEmailVerified: user['isEmailVerified'],
        lastName: user['lastName'],
        companyName: user['companyName'],
        gstNumber: user['gstNumber'],
        age: user['age'] != null ? DateTime.fromMillisecondsSinceEpoch(user['age']) : null,
        businessType: user['businessType'],
        profilePhotoUrl: user['profilePhotoUrl'],
      );

  factory AdWiseUser.newUser(User user) => AdWiseUser(
        user.uid,
        user.phoneNumber!,
        firstName: 'User_${user.uid}',
        emailId: user.email,
        isEmailVerified: user.emailVerified,
        profilePhotoUrl: user.photoURL,
      );

  Map<String, dynamic> get map => {
        'userId': userId,
        'phoneNumber': phoneNumber,
        'firstName': firstName,
        'emailId': emailId,
        'isEmailVerified': isEmailVerified,
        'companyName': companyName,
        'gstNumber': gstNumber,
        'age': age?.millisecondsSinceEpoch,
        'businessType': businessType,
        'profilePhotoUrl': profilePhotoUrl,
        'lastName': lastName,
      };

  copyWith({
    String? firstName,
    String? lastName,
    String? emailId,
    bool? isEmailVerified,
    String? companyName,
    String? gstNumber,
    DateTime? age,
    String? businessType,
    String? profilePhotoUrl,
  }) =>
      AdWiseUser(
        userId,
        phoneNumber,
        firstName: (firstName?.isNotEmpty ?? false) ? firstName! : this.firstName,
        lastName: (lastName?.isNotEmpty ?? false) ? lastName : this.lastName,
        emailId: (emailId?.isNotEmpty ?? false) ? emailId : this.emailId,
        isEmailVerified: isEmailVerified ?? this.isEmailVerified,
        companyName: (companyName?.isNotEmpty ?? false) ? companyName : this.companyName,
        gstNumber: (gstNumber?.isNotEmpty ?? false) ? gstNumber : this.gstNumber,
        age: age ?? this.age,
        businessType: (businessType?.isNotEmpty ?? false) ? businessType : this.businessType,
        profilePhotoUrl: (profilePhotoUrl?.isNotEmpty ?? false) ? profilePhotoUrl : this.profilePhotoUrl,
      );
}
