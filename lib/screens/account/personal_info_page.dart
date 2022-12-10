part of account_library;

class PersonalInfoPage extends StatelessWidget {
  const PersonalInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AdWiseUser user = DataManager().user!;
    return Scaffold(
      appBar: isMobileView(context) ? const MobileAppBar(text: "Personal Info") : const MyAppBar(showSearchBar: false),
      body: isMobileView(context)
          ? _MobileView(
              user: user,
            )
          : _TabAndDesktopView(
              user: user,
            ),
    );
  }
}

class _TabAndDesktopView extends StatelessWidget {
  final AdWiseUser user;

  const _TabAndDesktopView({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: maxScreenWidth,
        ),
        child: CustomSliver(
          leftSideWidget: const _ProfilePicSide(),
          rightSideWidget: const _InfoContent(),
          leftSideWidth: (min(screenSize.width, maxScreenWidth)) * 0.40,
          rightSideWidth: (min(screenSize.width, maxScreenWidth)) * 0.60,
        ),
      ),
    );
  }
}

class _ProfilePicSide extends StatelessWidget {
  const _ProfilePicSide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 40.0,
              bottom: 50.0,
            ),
            child: Text("Personal Info",
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      fontSize: 30.0,
                    )),
          ),
          const _ProfilePic(),
        ],
      ),
    );
  }
}

class _MobileView extends StatelessWidget {
  final AdWiseUser user;

  const _MobileView({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Container(
              constraints: const BoxConstraints(
                maxWidth: 300,
              ),
              child: const _ProfilePic(),
            ),
            const SizedBox(width: 20.0),
            const _InfoContent(),
          ],
        ),
      ),
    );
  }
}

class _ProfilePic extends StatefulWidget {
  const _ProfilePic({Key? key}) : super(key: key);

  @override
  State<_ProfilePic> createState() => _ProfilePicState();
}

// todo: IMPORTANT *********************************handle CORS issue and remove CORS neglect package **********************************
class _ProfilePicState extends State<_ProfilePic> {
  bool isLoading = false;
  late AdWiseUser user;

  @override
  Widget build(BuildContext context) {
    user = DataManager().user!;
    return Column(
      children: [
        CircleAvatar(
          radius: 100.0,
          backgroundImage: user.proPicImageProvider,
          backgroundColor: Colors.grey.shade400,
          child: isLoading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : user.profilePhotoUrl == null
                  ? const Icon(
                      Icons.person_sharp,
                      size: 150.0,
                      color: Colors.white,
                    )
                  : null,
        ),
        const SizedBox(
          height: 50.0,
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: _CustomInfoBtn(
                  name: user.profilePhotoUrl != null ? 'Edit' : 'Add',
                  color: Colors.orange,
                  textColor: Colors.white,
                  height: 40.0,
                  onTap: _pickProfilePic,
                ),
              ),
            ),
            if (user.profilePhotoUrl != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: _CustomInfoBtn(
                    name: 'Remove',
                    color: GeneralSettingsProvider().isDarkTheme ? Colors.grey : Colors.grey.shade300,
                    height: 40.0,
                    onTap: _deleteProfilePic,
                  ),
                ),
              ),
          ],
        )
      ],
    );
  }

  _pickProfilePic() async {
    Uint8List? imageInBytes = await conditional_import.pickImage();
    if (imageInBytes == null) return;

    setState(() => isLoading = true);
    bool isSuccess = await FirestoreManager().updateUserProfilePic(imageInBytes);
    if (isSuccess) {
      DataManager.notify();
      setState(() => isLoading = false);
    }
  }

  _deleteProfilePic() async {
    PrimaryDialog dialog = PrimaryDialog(
      context,
      'Remove photo',
      description: 'Do you really want to remove the profile picture?',
      yesButton: PrimaryDialogButton(
        'Yes',
        onTap: () async {
          Navigator.of(context).pop();
          String url = user.profilePhotoUrl!;
          setState(() => isLoading = true);
          bool isSuccess = await FirestoreManager().deleteUserProfilePic();
          if (isSuccess) {
            CachedNetworkImage.evictFromCache(url);
            setState(() => isLoading = false);
          }
        },
      ),
      noButton: PrimaryDialogButton(
        'cancel',
        onTap: () => Navigator.of(context).pop(),
      ),
    );
    await dialog.show();
  }
}

class _CustomInfoBtn extends StatelessWidget {
  final String name;
  final Color color;
  final Color? textColor;
  final Function? onTap;
  final double? minWidth, height;
  final bool isLoading;

  const _CustomInfoBtn({
    Key? key,
    required this.name,
    required this.color,
    this.textColor,
    this.onTap,
    this.minWidth,
    this.height = 30.0,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3.0),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: minWidth != null ? minWidth! / 2.5 : 10,
        ),
        child: Center(
          child: isLoading
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  ),
                )
              : Text(
                  name,
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
        ),
      ),
    );
  }
}

class _InfoContent extends StatefulWidget {
  const _InfoContent({Key? key}) : super(key: key);

  @override
  State<_InfoContent> createState() => _InfoContentState();
}

class _InfoContentState extends State<_InfoContent> {
  List<bool> editMode = List.filled(7, false);

  @override
  Widget build(BuildContext context) {
    AdWiseUser user = DataManager().user!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SettingsContentTile(
          title: 'Name',
          value: user.fullName,
          isEditMode: editMode[0],
          onEditMode: (isEditMode) => setState(() => editMode[0] = isEditMode),
          hasEditTile: editMode.any((element) => element == true),
          settingsTile: _SettingsNameTile(
            title: 'Name',
            firstName: user.firstName ?? '',
            lastName: user.lastName ?? '',
            onEditMode: (isEditMode) => setState(() => editMode[0] = isEditMode),
          ),
        ),
        _SettingsContentTile(
          title: AdWiseUser.dobTitle,
          value: user.ageAsString,
          isEditMode: editMode[1],
          onEditMode: (isEditMode) => setState(() => editMode[1] = isEditMode),
          hasEditTile: editMode.any((element) => element == true),
          settingsTile: _SettingsTile(
            title: AdWiseUser.dobTitle,
            value: user.ageAsString,
            onEditMode: (isEditMode) => setState(() => editMode[1] = isEditMode),
          ),
        ),
        _SettingsContentTile(
          title: AdWiseUser.phoneNumberTitle,
          value: user.phoneNumber,
          isEditMode: editMode[2],
          onEditMode: (isEditMode) => setState(() => editMode[2] = isEditMode),
          hasEditTile: editMode.any((element) => element == true),
          settingsTile: _SettingsTile(
            title: AdWiseUser.phoneNumberTitle,
            value: user.phoneNumber,
            onEditMode: (isEditMode) => setState(() => editMode[2] = isEditMode),
          ),
        ),
        _SettingsContentTile(
          title: AdWiseUser.emailTitle,
          value: user.emailId ?? '',
          isEditMode: editMode[3],
          onEditMode: (isEditMode) => setState(() => editMode[3] = isEditMode),
          hasEditTile: editMode.any((element) => element == true),
          settingsTile: _SettingsTile(
            title: AdWiseUser.emailTitle,
            value: user.emailId ?? '',
            onEditMode: (isEditMode) => setState(() => editMode[3] = isEditMode),
          ),
        ),
        _SettingsContentTile(
          title: AdWiseUser.companyNameTitle,
          value: user.companyName ?? '',
          isEditMode: editMode[4],
          onEditMode: (isEditMode) => setState(() => editMode[4] = isEditMode),
          hasEditTile: editMode.any((element) => element == true),
          settingsTile: _SettingsTile(
            title: AdWiseUser.companyNameTitle,
            value: user.companyName ?? '',
            onEditMode: (isEditMode) => setState(() => editMode[4] = isEditMode),
          ),
        ),
        _SettingsContentTile(
          title: AdWiseUser.gstNumberTitle,
          value: user.gstNumber ?? '',
          isEditMode: editMode[5],
          onEditMode: (isEditMode) => setState(() => editMode[5] = isEditMode),
          hasEditTile: editMode.any((element) => element == true),
          settingsTile: _SettingsTile(
            title: AdWiseUser.gstNumberTitle,
            value: user.gstNumber ?? '',
            onEditMode: (isEditMode) => setState(() => editMode[5] = isEditMode),
          ),
        ),
        _SettingsContentTile(
          title: AdWiseUser.businessTypeTitle,
          value: user.businessType ?? '',
          isEditMode: editMode[6],
          onEditMode: (isEditMode) => setState(() => editMode[6] = isEditMode),
          hasEditTile: editMode.any((element) => element == true),
          settingsTile: _SettingsTile(
            title: AdWiseUser.businessTypeTitle,
            value: user.businessType ?? '',
            onEditMode: (isEditMode) => setState(() => editMode[6] = isEditMode),
          ),
        ),
      ],
    );
  }
}
