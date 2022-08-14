import 'package:ad/AdWiseUser.dart';
import 'package:ad/globals.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  final AdWiseUser user;

  const AccountPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: getAppBar(screenSize),
      body: Column(
        children: [
          Text('user Id : ${user.userId}'),
          const SizedBox(
            height: 20,
          ),
          Text('userName : ${user.userName}'),
          const SizedBox(
            height: 20,
          ),
          Text('phoneNumber ${user.phoneNumber}'),
          const SizedBox(
            height: 20,
          ),
          Text('email Id : ${user.emailId}'),
          const SizedBox(
            height: 20,
          ),
          Text('age : ${user.age}'),
          const SizedBox(
            height: 20,
          ),
          Text('profileUrl : ${user.profilePhotoUrl}'),
          const SizedBox(
            height: 20,
          ),
          Text('businessType : ${user.businessType}'),
          const SizedBox(
            height: 20,
          ),
          Text('company name : ${user.companyName}'),
          const SizedBox(
            height: 20,
          ),
          Text('gst Number : ${user.gstNumber}'),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
