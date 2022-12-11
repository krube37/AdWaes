import 'package:flutter/material.dart';

import '../../general_settings.dart';
import '../../utils/globals.dart';
import '../home/my_app_bar.dart';
import 'account_library_helper_widgets.dart';

class GeneralSettingsPage extends StatefulWidget {
  const GeneralSettingsPage({Key? key}) : super(key: key);

  @override
  State<GeneralSettingsPage> createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage> {
  List<bool> editMode = List.filled(1, false);

  @override
  Widget build(BuildContext context) {
    GeneralSettingsProvider settingsProvider = GeneralSettingsProvider();
    return Scaffold(
      appBar:
          isMobileView(context) ? const MobileAppBar(text: " General Settings") : const MyAppBar(showSearchBar: false),
      body: Column(
        children: [
          SettingsContentTile(
            title: 'Time zone',
            value: settingsProvider.timeZone,
            isEditMode: editMode[0],
            onEditMode: (isEditMode) => setState(() => editMode[0] = isEditMode),
            hasEditTile: editMode.any((element) => element == true),
            settingsTile: SettingsTile(
              title: 'Time zone',
              value: settingsProvider.timeZone,
              onEditMode: (isEditMode) => setState(() => editMode[0] = isEditMode),
            ),
          ),
          SettingsContentTile(
            title: 'Theme mode',
            value: '',
            alwaysShowContent: true,
            hasEditTile: editMode.any((element) => element == true),
            settingsTile: const _ThemeTile(),
          ),
        ],
      ),
    );
  }
}

class _ThemeTile extends StatefulWidget {
  const _ThemeTile({Key? key}) : super(key: key);

  @override
  State<_ThemeTile> createState() => _ThemeTileState();
}

class _ThemeTileState extends State<_ThemeTile> {
  GeneralSettingsProvider settingsProvider = GeneralSettingsProvider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          InkWell(
            onTap: _onLightThemePressed,
            child: _getThemeContainer(
              isEnabled: !settingsProvider.isDarkTheme,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          InkWell(
            onTap: _onDarkThemePressed,
            child: _getThemeContainer(
              isEnabled: settingsProvider.isDarkTheme,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }

  _onLightThemePressed() {
    if (!settingsProvider.isDarkTheme) return;

    settingsProvider.toggleThemeMode();
    setState(() {});
  }

  _onDarkThemePressed() {
    if (settingsProvider.isDarkTheme) return;

    settingsProvider.toggleThemeMode();
    setState(() {});
  }

  _getThemeContainer({
    required isEnabled,
    required color,
  }) =>
      Container(
        height: 30.0,
        width: 30.0,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: isEnabled ? primaryColor : Colors.grey,
            width: isEnabled ? 1 : 0.2,
          ),
          borderRadius: BorderRadius.circular(2),
        ),
      );
}
