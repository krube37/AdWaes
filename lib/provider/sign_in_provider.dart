import 'package:flutter/foundation.dart';

class SignInProvider extends ChangeNotifier {
  static SignInProvider? _mInstance;

  SignInProvider() {
    _mInstance = this;
  }

  bool _isLoading = false;
  String? _errorMessage;
  String? _googleErrorMessage;
  bool _isGoogleLoading = false;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  bool get isGoogleLoading => _isGoogleLoading;

  String? get googleErrorMessage => _googleErrorMessage;

  static notify() => _mInstance?.notifyListeners();

  setLoadingState() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
  }

  setGoogleLoadingState() {
    _isGoogleLoading = true;
    _errorMessage = null;
    notifyListeners();
  }

  setIdleState({String? errorMessage, String? googleErrorMessage}) {
    _isLoading = false;
    _isGoogleLoading = false;
    _errorMessage = errorMessage;
    _googleErrorMessage = googleErrorMessage;
    notifyListeners();
  }
}
