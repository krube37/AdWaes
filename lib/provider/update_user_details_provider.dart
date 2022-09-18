import 'package:flutter/material.dart';

import '../adwise_user.dart';

class UpdateUserDetailsProvider extends ChangeNotifier {
  static UpdateUserDetailsProvider? _mInstance;

  static notify() => _mInstance?.notifyListeners();

  /// text editing controllers
  late TextEditingController _userNameTextController,
      _firstNameTextController,
      _lastNameTextController,
      _phoneNumberTextController,
      _emailIdTextController,
      _ageTextController,
      _companyTextController,
      _gstNumberTextController,
      _businessTypeTextController;
  final AdWiseUser adWiseUser;

  UpdateUserDetailsProvider(this.adWiseUser) {
    _userNameTextController = TextEditingController(text: adWiseUser.userName);
    _firstNameTextController = TextEditingController();
    _lastNameTextController = TextEditingController();
    _phoneNumberTextController = TextEditingController(text: adWiseUser.phoneNumber);
    _emailIdTextController = TextEditingController(text: adWiseUser.emailId);
    _ageTextController = TextEditingController(text: adWiseUser.age?.toString());
    _companyTextController = TextEditingController(text: adWiseUser.companyName);
    _gstNumberTextController = TextEditingController(text: adWiseUser.gstNumber);
    _businessTypeTextController = TextEditingController(text: adWiseUser.businessType);
  }

  TextEditingController get userNameTextController => _userNameTextController;

  TextEditingController get firstNameTextController => _firstNameTextController;

  TextEditingController get lastNameTextController => _lastNameTextController;

  TextEditingController get phoneNumberTextController => _phoneNumberTextController;

  TextEditingController get emailIdTextController => _emailIdTextController;

  TextEditingController get ageTextController => _ageTextController;

  TextEditingController get companyTextController => _companyTextController;

  TextEditingController get gstTextController => _gstNumberTextController;

  TextEditingController get businessTypeTextController => _businessTypeTextController;

  bool _isSavingUserDetails = false;
  String? _userDetailsErrorMessage;

  bool get isSavingUserDetails => _isSavingUserDetails;

  String? get userDetailsErrorMessage => _userDetailsErrorMessage;

  setSavingDetailsState() {
    _isSavingUserDetails = true;
    _userDetailsErrorMessage = null;
    notifyListeners();
  }

  setIdleState({String? userDetailsErrorMessage}) {
    _isSavingUserDetails = false;
    _userDetailsErrorMessage = userDetailsErrorMessage;
    notifyListeners();
  }

  Future<DateTime?> pickAge(BuildContext context) async => await showDatePicker(
      context: context, initialDate: DateTime(1990), firstDate: DateTime(1800), lastDate: DateTime.now());

  bool isAllRequiredFieldsFilled() {
    if (userNameTextController.text.trim().isEmpty) return false;
    if (firstNameTextController.text.trim().isEmpty) return false;
    if (phoneNumberTextController.text.trim().isEmpty) return false;
    if (companyTextController.text.trim().isEmpty) return false;
    return true;
  }
}
