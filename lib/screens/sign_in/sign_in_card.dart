library sign_in;

import 'package:ad/firebase/firestore_database.dart';
import 'package:ad/globals.dart';
import 'package:ad/provider/data_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../AdWiseUser.dart';
import '../../firebase/auth_manager.dart';
import '../../provider/sign_in_provider.dart';

part 'sign_up_card.dart';

part 'sign_in_manager.dart';

class SignInCard extends StatefulWidget {
  const SignInCard({Key? key}) : super(key: key);

  @override
  State<SignInCard> createState() => _SignInCardState();
}

class _SignInCardState extends State<SignInCard> {
  String? _phoneNumberErrorText, _otpErrorText;
  late SignInProvider _provider;
  ConfirmationResult? _otpSentResult;
  String? phoneNumber;
  bool waitingForOTP = false;

  @override
  void didChangeDependencies() {
    _provider = Provider.of<SignInProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        height: 400,
        margin: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Column(
              children: [
                Row(
                  children: [
                    if (waitingForOTP)
                      InkWell(
                        onTap: _onBackPressed,
                        borderRadius: BorderRadius.circular(20.0),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.arrow_back),
                        ),
                      ),
                    const Expanded(child: SizedBox()),
                    InkWell(
                      onTap: () => Navigator.pop(context, null),
                      borderRadius: BorderRadius.circular(20.0),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.clear_rounded),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                waitingForOTP ? _showOtpContent() : _showPhoneNumberContent()
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _validateFilledFields(String phoneNumber) {
    bool isValid = true;
    _phoneNumberErrorText = _otpErrorText = null;

    if (phoneNumber.isEmpty) {
      _phoneNumberErrorText = 'phone Number is Empty';
      isValid = false;
    }
    return isValid;
  }

  _onContinueButtonClicked() async {
    String email = _provider.phoneNumberTextController.text.trim();
    bool isValid = _validateFilledFields(email);

    if (!isValid) {
      setState(() {});
      return;
    }

    _provider.setSendingOtpState();

    try {
      _otpSentResult = await AuthManager().signInWithPhoneNumber(_provider.phoneNumberTextController.text.trim());
    } catch (e, stact) {
      debugPrint("_SignInCardState _onContinueButtonClicked: error in sending OTP $e\n$stact");
    }

    setState(() {
      if (_otpSentResult != null) {
        waitingForOTP = true;
        phoneNumber = _provider.phoneNumberTextController.text.trim();
        _provider.setIdleState();
      } else {
        _provider.setIdleState(phoneNumberErrorMessage: 'unable to send Verification Code!');
      }
    });
  }

  _onSigInButtonClicked() async {
    try {
      _provider.setVerifyingOtpState();
      UserCredential userCreds = await _otpSentResult!.confirm(_provider.otpTextController.text.trim());

      if (userCreds.user != null) {
        bool isNewUser = userCreds.additionalUserInfo?.isNewUser ?? false;

        AdWiseUser adWiseUser;
        if (isNewUser) {
          adWiseUser = AdWiseUser.newUser(userCreds.user!);
          await FirestoreDatabase().updateNewUserDetails(adWiseUser);
        } else {
          adWiseUser = await FirestoreDatabase().getCurrentUserDetails(userCreds.user!.uid);
        }
        DataManager().user = adWiseUser;
        SnackBar snackBar = const SnackBar(
          content: Text('Successfully logged in'),
          behavior: SnackBarBehavior.floating,
          width: 500.0,
        );
        if (mounted) {
          _provider.setIdleState();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pop(context, adWiseUser);
        }
      } else {
        _provider.setIdleState(otpErrorMessage: 'Error signing in. Please try after sometime');
      }
    } catch (e, stack) {
      print("_SignInCardState _onSigInButtonClicked: wrong otp, $e\n$stack");
      _provider.setIdleState(otpErrorMessage: 'Incorrect OTP entered. Please try again.');
    }
  }

  _onBackPressed() {
    print("_SignInCardState _onBackPressed: $waitingForOTP");
    if (waitingForOTP) {
      setState(() {
        _otpSentResult = null;
        waitingForOTP = false;
      });
    } else {
      Navigator.pop(context, null);
    }
  }

  _showPhoneNumberContent() => Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _CustomTextField(
              'Your Mobile Number',
              labelText: 'Mobile Number',
              controller: _provider.phoneNumberTextController,
              errorText: _phoneNumberErrorText,
              onFieldSubmitted: (_) => _onContinueButtonClicked,
            ),
            const SizedBox(
              height: 20,
            ),
            _CustomButton.continueBtn(
              onPressed: _onContinueButtonClicked,
            )
          ],
        ),
      );

  _showOtpContent() => Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter the 6 digit code sent to $phoneNumber'),
            const SizedBox(
              height: 10,
            ),
            _CustomTextField(
              'Enter OTP',
              labelText: 'Enter OTP',
              controller: _provider.otpTextController,
              errorText: _otpErrorText,
              onFieldSubmitted: (_) => _onSigInButtonClicked,
            ),
            const SizedBox(
              height: 20,
            ),
            _CustomButton.signInButton(onPressed: _onSigInButtonClicked)
          ],
        ),
      );
}

bool _isInValidEmail(String email) => (!email.contains('@') ||
    email.startsWith('@') ||
    email.endsWith('@') ||
    email.startsWith('.') ||
    email.endsWith('.') ||
    !email.contains('.') ||
    email.contains('@.'));
