import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdWiseUser {
  final String userId, phoneNumber;

  final String? firstName, lastName, emailId, companyName, gstNumber, businessType, profilePhotoUrl;
  final DateTime? age;
  final bool? isEmailVerified;
  final ImageProvider? proPicImageProvider;

  static const String firstNameTitle = 'First name',
      lastNameTitle = 'Last name',
      phoneNumberTitle = 'Phone number',
      emailTitle = 'Email',
      dobTitle = 'Date of birth',
      companyNameTitle = 'Company name',
      gstNumberTitle = 'GST number',
      businessTypeTitle = 'Business type';

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
  })  : proPicImageProvider = (profilePhotoUrl != null) ? CachedNetworkImageProvider(profilePhotoUrl) : null,
        assert(
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
    bool? deleteProfilePic,
  }) {
    assert((deleteProfilePic == null || !deleteProfilePic || profilePhotoUrl == null),
        'if deleteProfilePic is set to true, then profilePhotoUrl value should not be given');
    String? proPicUrl;
    if (deleteProfilePic == null || !deleteProfilePic) {
      proPicUrl = (profilePhotoUrl?.isNotEmpty ?? false) ? profilePhotoUrl : this.profilePhotoUrl;
    }
    return AdWiseUser(
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
      profilePhotoUrl: proPicUrl,
    );
  }

  String get displayName {
    String displayName = '';
    if (firstName != null) displayName = '$firstName ';
    if (lastName != null) displayName = displayName + lastName!;
    return displayName;
  }

  String get ageAsString => age != null ? (DateTime.now().year - age!.year).toString() : '';
}
