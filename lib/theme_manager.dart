import 'package:flutter/material.dart';

class ThemeManager extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  static final ThemeManager mInstance = ThemeManager._();

  ThemeManager._();

  factory ThemeManager() => mInstance;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkTheme => themeMode == ThemeMode.dark;

  toggleThemeMode() {
    _themeMode = isDarkTheme ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }
}
