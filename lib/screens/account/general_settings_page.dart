part of account_library;

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
          _SettingsContentTile(
            title: 'Time zone',
            value: settingsProvider.timeZone,
            isEditMode: editMode[0],
            onEditMode: (isEditMode) => setState(() => editMode[0] = isEditMode),
            hasEditTile: editMode.any((element) => element == true),
            settingsTile: _SettingsTile(
              title: 'Time zone',
              value: settingsProvider.timeZone,
              onEditMode: (isEditMode) => setState(() => editMode[0] = isEditMode),
            ),
          ),
          _SettingsContentTile(
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
