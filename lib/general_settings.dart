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
  GeneralSettings settings;
  DataManager dataManager;
  FirestoreManager firestoreManager;

  GeneralSettingsProvider._()
      : settings = DataManager().user?.settings ?? GeneralSettings.defaultSettings(),
        dataManager = DataManager(),
        firestoreManager = FirestoreManager();

  factory GeneralSettingsProvider() => mInstance;

  bool get isDarkTheme => settings.themeMode.isDarkTheme;

  ThemeMode get themeMode => settings.themeMode;

  toggleThemeMode() {
    settings = settings.copyWith(
      themeMode: settings.themeMode.isDarkTheme ? ThemeMode.light : ThemeMode.dark,
    );
    dataManager.user = dataManager.user?.copyWith(generalSettings: settings);
    firestoreManager.updateUserDetails(dataManager.user!);
    notifyListeners();
  }

  setThemeMode(ThemeMode themeMode) {
    if (themeMode == settings.themeMode) return;
    settings = settings.copyWith(themeMode: themeMode);
    dataManager.user = dataManager.user?.copyWith(generalSettings: settings);
    firestoreManager.updateUserDetails(dataManager.user!);
    notifyListeners();
  }

  setTimeZone(String zone) {
    if (settings.timeZone == zone) return;
    settings = settings.copyWith(timeZone: zone);
    dataManager.user = dataManager.user?.copyWith(generalSettings: settings);
    firestoreManager.updateUserDetails(dataManager.user!);
    notifyListeners();
  }

  updateUserSettings(GeneralSettings settings) {
    this.settings = settings;
    notifyListeners();
  }

  resetSettingsToDefault() {
    settings = GeneralSettings.defaultSettings();
    notifyListeners();
  }

  get map => settings.map;
}
