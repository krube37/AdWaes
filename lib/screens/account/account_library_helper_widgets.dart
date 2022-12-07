part of account_library;

class _SettingsContentTile extends StatelessWidget {
  final String title, value;
  final Function(bool isEditMode)? onEditMode;
  final bool isEditMode;
  final bool hasEditTile;
  final Widget settingsTile;
  final bool alwaysShowContent;

  const _SettingsContentTile({
    Key? key,
    required this.title,
    required this.value,
    this.onEditMode,
    this.isEditMode = false,
    required this.hasEditTile,
    required this.settingsTile,
    this.alwaysShowContent = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: (hasEditTile && !isEditMode) ? 0.3 : 1,
      child: IgnorePointer(
        ignoring: hasEditTile && !isEditMode,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: GeneralSettingsProvider().isDarkTheme ? Colors.grey : Colors.grey.shade300,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 10.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(fontSize: 16.0)),
                        const SizedBox(height: 15.0),
                        isEditMode || alwaysShowContent
                            ? settingsTile
                            : Text(
                                value,
                                style: const TextStyle(fontSize: 14.0),
                              ),
                      ],
                    ),
                  ),
                  if (!isEditMode && !alwaysShowContent)
                    _CustomInfoBtn(
                      name: value.isEmpty ? 'Add' : 'Edit',
                      color: Colors.orange,
                      textColor: Colors.white,
                      minWidth: 60.0,
                      onTap: () => onEditMode?.call(true),
                    ),
                  if (!isEditMode) const SizedBox(width: 20.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsNameTile extends StatefulWidget {
  final String title;
  final String firstName;
  final String lastName;
  final Function(bool isEditMode)? onEditMode;

  const _SettingsNameTile({
    Key? key,
    required this.title,
    required this.firstName,
    required this.lastName,
    this.onEditMode,
  }) : super(key: key);

  @override
  State<_SettingsNameTile> createState() => _SettingsNameTileState();
}

class _SettingsNameTileState extends State<_SettingsNameTile> {
  late TextEditingController _firstNameTextController, _lastNameTextController;
  late FocusNode _firstNameFocusNode;

  @override
  void initState() {
    _firstNameTextController = TextEditingController(text: widget.firstName);
    _lastNameTextController = TextEditingController(text: widget.lastName);
    _firstNameFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _firstNameTextController.dispose();
    _lastNameTextController.dispose();
    _firstNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_firstNameFocusNode.canRequestFocus) {
        _firstNameFocusNode.requestFocus();
      }
    });
    return isMobileView(context)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _getTextField(
                      _firstNameTextController,
                      hintText: 'First name',
                      focusNode: _firstNameFocusNode,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: _getTextField(
                      _lastNameTextController,
                      hintText: 'Last name',
                    ),
                  )
                ],
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 200),
                child: _getSaveCancelBtns(),
              )
            ],
          )
        : Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _getTextField(
                      _firstNameTextController,
                      hintText: 'First name',
                      focusNode: _firstNameFocusNode,
                    ),
                    const SizedBox(height: 10.0),
                    _getTextField(
                      _lastNameTextController,
                      hintText: 'Last name',
                    )
                  ],
                ),
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 200),
                child: _getSaveCancelBtns(),
              )
            ],
          );
  }

  Widget _getSaveCancelBtns() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _SaveButton(
                  title: widget.title,
                  value: () => _firstNameTextController.text.trim(),
                  lastName: () => _lastNameTextController.text.trim(),
                  onCompleted: () => widget.onEditMode?.call(false),
                )),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _CustomInfoBtn(
                name: 'Cancel',
                color: GeneralSettingsProvider().isDarkTheme ? Colors.grey : Colors.grey.shade300,
                onTap: () => widget.onEditMode?.call(false),
              ),
            ),
          ),
        ],
      );

  Widget _getTextField(
    TextEditingController controller, {
    required String hintText,
    focusNode,
  }) =>
      TextField(
        focusNode: focusNode,
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
      );
}

class _SettingsTile extends StatefulWidget {
  final String title, value;
  final Function(bool isEditMode)? onEditMode;
  final String? hintText;

  const _SettingsTile({
    Key? key,
    required this.title,
    required this.value,
    this.onEditMode,
    this.hintText,
  }) : super(key: key);

  @override
  State<_SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<_SettingsTile> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_focusNode.canRequestFocus) {
        _focusNode.requestFocus();
      }
    });
    return isMobileView(context)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _getTextField(),
              const SizedBox(height: 10.0),
              Container(
                constraints: const BoxConstraints(maxWidth: 200),
                child: _getSaveCancelBtns(),
              )
            ],
          )
        : Row(
            children: [
              Expanded(
                child: _getTextField(),
              ),
              const SizedBox(width: 10.0),
              Container(
                constraints: const BoxConstraints(maxWidth: 200),
                child: _getSaveCancelBtns(),
              )
            ],
          );
  }

  Widget _getSaveCancelBtns() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _SaveButton(
                  title: widget.title,
                  value: () => _controller.text.trim(),
                  onCompleted: () => widget.onEditMode?.call(false),
                )),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _CustomInfoBtn(
                name: 'Cancel',
                color: Colors.grey.shade300,
                onTap: () => widget.onEditMode?.call(false),
              ),
            ),
          ),
        ],
      );

  Widget _getTextField() => TextField(
        focusNode: _focusNode,
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: widget.hintText ?? widget.title,
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
      );
}

class _SaveButton extends StatefulWidget {
  final String title;
  final Function? onCompleted, lastName;
  final Function value;

  const _SaveButton({
    Key? key,
    required this.title,
    this.onCompleted,
    required this.value,
    this.lastName,
  })  : assert(
          (title != 'Name' || lastName != null),
          'if title is Name, then should provide last Name',
        ),
        super(key: key);

  @override
  State<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<_SaveButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _CustomInfoBtn(
      name: 'Save',
      color: Colors.orange,
      textColor: Colors.white,
      onTap: _updateUserData,
      isLoading: isLoading,
    );
  }

  _updateUserData() async {
    DataManager dataManager = DataManager();
    AdWiseUser user = dataManager.user!;
    String value = widget.value.call();

    switch (widget.title) {
      case 'Name':
        user = user.copyWith(firstName: value, lastName: widget.lastName?.call());
        break;
      case AdWiseUser.dobTitle:
        user = user.copyWith(age: DateTime.fromMillisecondsSinceEpoch(int.parse(value)));
        break;
      case AdWiseUser.phoneNumberTitle:
        // should not allow user to edit phone number
        break;
      case AdWiseUser.emailTitle:
        user = user.copyWith(emailId: value);
        break;
      case AdWiseUser.companyNameTitle:
        user = user.copyWith(companyName: value);
        break;
      case AdWiseUser.gstNumberTitle:
        user = user.copyWith(gstNumber: value);
        break;
      case AdWiseUser.businessTypeTitle:
        user = user.copyWith(businessType: value);
        break;
      default:
        widget.onCompleted?.call();
        return;
    }
    String toastMsg;
    setState(() => isLoading = true);
    bool isSuccess = await FirestoreManager().updateUserDetails(user);
    if (isSuccess) {
      toastMsg = 'Updated the account details';
      dataManager.user = user;
    } else {
      toastMsg = 'Error in updating the account details';
    }
    SnackBar snackBar = SnackBar(
      content: Text(toastMsg),
      behavior: SnackBarBehavior.floating,
      width: 500.0,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() => isLoading = false);
    }
    widget.onCompleted?.call();
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
        height: 20.0,
        width: 20.0,
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
