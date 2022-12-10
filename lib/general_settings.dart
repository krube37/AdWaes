import 'package:ad/extensions.dart';
import 'package:ad/firebase/firestore_manager.dart';
import 'package:ad/provider/data_manager.dart';
import 'package:flutter/material.dart';

class GeneralSettings {
  final String timeZone;
  final ThemeMode themeMode;

  GeneralSettings({
    required this.timeZone,
    required this.themeMode,
  });

  bool get isDarkTheme => themeMode.isDarkTheme;

  factory GeneralSettings.defaultSettings() => GeneralSettings(
        timeZone: 'Indian Standard Time',
        themeMode: ThemeMode.light,
      );

  factory GeneralSettings.fromFirestore(Map<String, dynamic> json) => GeneralSettings(
        timeZone: json['timeZone'],
        themeMode: json['isDarkTheme'] ? ThemeMode.dark : ThemeMode.light,
      );

  GeneralSettings copyWith({
    String? timeZone,
    ThemeMode? themeMode,
  }) =>
      GeneralSettings(
        timeZone: timeZone ?? this.timeZone,
        themeMode: themeMode ?? this.themeMode,
      );

  get map => {
        'timeZone': timeZone,
        'isDarkTheme': themeMode.isDarkTheme,
      };
}

class GeneralSettingsProvider extends ChangeNotifier {
  static final mInstance = GeneralSettingsProvider._();
  GeneralSettings _settings;
  DataManager _dataManager;
  FirestoreManager _firestoreManager;

  GeneralSettingsProvider._()
      : _settings = DataManager().user?.settings ?? GeneralSettings.defaultSettings(),
        _dataManager = DataManager(),
        _firestoreManager = FirestoreManager();

  factory GeneralSettingsProvider() => mInstance;

  bool get isDarkTheme => _settings.themeMode.isDarkTheme;

  ThemeMode get themeMode => _settings.themeMode;

  String get timeZone => _settings.timeZone;

  toggleThemeMode() {
    _settings = _settings.copyWith(
      themeMode: _settings.themeMode.isDarkTheme ? ThemeMode.light : ThemeMode.dark,
    );
    if (_dataManager.user != null) {
      _dataManager.user = _dataManager.user!.copyWith(generalSettings: _settings);
      _firestoreManager.updateUserDetails(_dataManager.user!);
    }
    notifyListeners();
  }

  setThemeMode(ThemeMode themeMode) {
    if (themeMode == _settings.themeMode) return;
    _settings = _settings.copyWith(themeMode: themeMode);
    if (_dataManager.user != null) {
      _dataManager.user = _dataManager.user!.copyWith(generalSettings: _settings);
      _firestoreManager.updateUserDetails(_dataManager.user!);
    }
    notifyListeners();
  }

  setTimeZone(String zone) {
    if (_settings.timeZone == zone) return;
    _settings = _settings.copyWith(timeZone: zone);
    if (_dataManager.user != null) {
      _dataManager.user = _dataManager.user!.copyWith(generalSettings: _settings);
      _firestoreManager.updateUserDetails(_dataManager.user!);
    }
    notifyListeners();
  }

  updateUserSettings(GeneralSettings settings) {
    _settings = settings;
    notifyListeners();
  }

  resetSettingsToDefault() {
    _settings = GeneralSettings.defaultSettings();
    notifyListeners();
  }

  get map => _settings.map;
}
