import 'package:flutter/cupertino.dart';

class SignInProvider extends ChangeNotifier {
  static SignInProvider? _mInstance;

  static TextEditingController? _phoneNumberTextController, _otpTextController;

  SignInProvider() {
    _phoneNumberTextController ??= TextEditingController(text: '+91');
    _otpTextController ??= TextEditingController();
    _mInstance = this;
  }

  TextEditingController get phoneNumberTextController => _phoneNumberTextController!;

  TextEditingController get otpTextController => _otpTextController!;

  bool _sendingOtp = false;
  bool _verifyingOtp = false;
  String? _phoneNumberErrorMessage;
  String? _otpErrorMessage;

  bool get isSendingOtp => _sendingOtp;

  bool get isVerifyingOtp => _verifyingOtp;

  String? get phoneNumberErrorMessage => _phoneNumberErrorMessage;

  String? get otpErrorMessage => _otpErrorMessage;

  static notify() => _mInstance?.notifyListeners();

  setSendingOtpState() {
    _sendingOtp = true;
    _phoneNumberErrorMessage = null;
    notifyListeners();
  }

  setVerifyingOtpState() {
    _verifyingOtp = true;
    _otpErrorMessage = null;
    notifyListeners();
  }

  setIdleState({String? phoneNumberErrorMessage, String? otpErrorMessage}) {
    _sendingOtp = false;
    _verifyingOtp = false;
    _phoneNumberErrorMessage = phoneNumberErrorMessage;
    _otpErrorMessage = otpErrorMessage;
    notifyListeners();
  }
}
