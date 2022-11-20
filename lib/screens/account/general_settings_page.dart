part of account_library;

class GeneralSettingsPage extends StatefulWidget {
  const GeneralSettingsPage({Key? key}) : super(key: key);

  @override
  State<GeneralSettingsPage> createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage> {
  List<bool> editMode = List.filled(2, false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Column(
        children: [
          _SettingsContentTile(
            title: 'Time zone',
            value: 'Indian standard time',
            isEditMode: editMode[0],
            onEditMode: (isEditMode) => setState(() => editMode[0] = isEditMode),
            hasEditTile: editMode.any((element) => element == true),
            settingsTile: _SettingsTile(
              title: 'Time zonee',
              value: 'IST',
              onEditMode: (isEditMode) => setState(() => editMode[0] = isEditMode),
            ),
          ),
          _SettingsContentTile(
            title: 'Time zone',
            value: 'Indian standard time',
            isEditMode: editMode[1],
            onEditMode: (isEditMode) => setState(() => editMode[1] = isEditMode),
            hasEditTile: editMode.any((element) => element == true),
            settingsTile: _SettingsTile(
              title: 'Enter time zone',
              value: 'Indian standard time',
              onEditMode: (isEditMode) => setState(() => editMode[1] = isEditMode),
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
