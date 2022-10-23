import 'dart:math';

import 'package:ad/adwise_user.dart';
import 'package:ad/firebase/firestore_database.dart';
import 'package:ad/provider/data_manager.dart';
import 'package:flutter/material.dart';

import '../../globals.dart';

class PersonalInfoPage extends StatelessWidget {
  final AdWiseUser user;

  const PersonalInfoPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Info',
          style: TextStyle(color: Colors.black87),
        ),
      ),
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

    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 1100.0,
            minWidth: min(
              screenSize.width,
              1100.0,
            ),
          ),
          margin: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  top: 40.0,
                  bottom: 20.0,
                ),
                child: Text(
                  "Personal Info",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: _ProfilePic(),
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(flex: 2, child: _InfoContent()),
                ],
              ),
            ],
          ),
        ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(
                top: 40.0,
                bottom: 20.0,
              ),
              child: Text(
                "Personal Info",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                ),
              ),
            ),
            Column(
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
          ],
        ),
      ),
    );
  }
}

class _ProfilePic extends StatelessWidget {
  const _ProfilePic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AdWiseUser user = DataManager().user!;
    return Column(
      children: [
        CircleAvatar(
          radius: 100.0,
          backgroundImage: user.profilePhotoUrl != null
              ? Image.network(
                  user.profilePhotoUrl!,
                ).image
              : null,
        ),
        const SizedBox(
          height: 50.0,
        ),
        Row(
          children: [
            const Expanded(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: _CustomInfoBtn(
                  name: 'Edit',
                  color: Colors.orange,
                  textColor: Colors.white,
                  height: 40.0,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: _CustomInfoBtn(
                  name: 'Remove',
                  color: Colors.grey.shade300,
                  height: 40.0,
                ),
              ),
            ),
          ],
        )
      ],
    );
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
  List<bool> editMode = [false, false, false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    AdWiseUser user = DataManager().user!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoContentTile(
          title: 'Name',
          value: user.displayName,
          isEditMode: editMode[0],
          onEditMode: (isEditMode) => setState(() => editMode[0] = isEditMode),
          hasEditTile: editMode.any((element) => element == true),
          infoTile: _InfoNameTile(
            title: 'Name',
            firstName: user.firstName ?? '',
            lastName: user.lastName ?? '',
            onEditMode: (isEditMode) => setState(() => editMode[0] = isEditMode),
          ),
        ),
        _InfoContentTile(
          title: AdWiseUser.dobTitle,
          value: user.ageAsString,
          isEditMode: editMode[1],
          onEditMode: (isEditMode) => setState(() => editMode[1] = isEditMode),
          hasEditTile: editMode.any((element) => element == true),
          infoTile: _InfoTile(
            title: AdWiseUser.dobTitle,
            value: user.ageAsString,
            onEditMode: (isEditMode) => setState(() => editMode[1] = isEditMode),
          ),
        ),
        _InfoContentTile(
          title: AdWiseUser.phoneNumberTitle,
          value: user.phoneNumber,
          isEditMode: editMode[2],
          onEditMode: (isEditMode) => setState(() => editMode[2] = isEditMode),
          hasEditTile: editMode.any((element) => element == true),
          infoTile: _InfoTile(
            title: AdWiseUser.phoneNumberTitle,
            value: user.phoneNumber,
            onEditMode: (isEditMode) => setState(() => editMode[2] = isEditMode),
          ),
        ),
        _InfoContentTile(
          title: AdWiseUser.emailTitle,
          value: user.emailId ?? '',
          isEditMode: editMode[3],
          onEditMode: (isEditMode) => setState(() => editMode[3] = isEditMode),
          hasEditTile: editMode.any((element) => element == true),
          infoTile: _InfoTile(
            title: AdWiseUser.emailTitle,
            value: user.emailId ?? '',
            onEditMode: (isEditMode) => setState(() => editMode[3] = isEditMode),
          ),
        ),
        _InfoContentTile(
          title: AdWiseUser.companyNameTitle,
          value: user.companyName ?? '',
          isEditMode: editMode[4],
          onEditMode: (isEditMode) => setState(() => editMode[4] = isEditMode),
          hasEditTile: editMode.any((element) => element == true),
          infoTile: _InfoTile(
            title: AdWiseUser.companyNameTitle,
            value: user.companyName ?? '',
            onEditMode: (isEditMode) => setState(() => editMode[4] = isEditMode),
          ),
        ),
        _InfoContentTile(
          title: AdWiseUser.gstNumberTitle,
          value: user.gstNumber ?? '',
          isEditMode: editMode[5],
          onEditMode: (isEditMode) => setState(() => editMode[5] = isEditMode),
          hasEditTile: editMode.any((element) => element == true),
          infoTile: _InfoTile(
            title: AdWiseUser.gstNumberTitle,
            value: user.gstNumber ?? '',
            onEditMode: (isEditMode) => setState(() => editMode[5] = isEditMode),
          ),
        ),
        _InfoContentTile(
          title: AdWiseUser.businessTypeTitle,
          value: user.businessType ?? '',
          isEditMode: editMode[6],
          onEditMode: (isEditMode) => setState(() => editMode[6] = isEditMode),
          hasEditTile: editMode.any((element) => element == true),
          infoTile: _InfoTile(
            title: AdWiseUser.businessTypeTitle,
            value: user.businessType ?? '',
            onEditMode: (isEditMode) => setState(() => editMode[6] = isEditMode),
          ),
        ),
      ],
    );
  }
}

class _InfoContentTile extends StatefulWidget {
  final String title, value;
  final Function(bool isEditMode)? onEditMode;
  final bool isEditMode;
  final bool hasEditTile;
  final Widget infoTile;

  const _InfoContentTile({
    Key? key,
    required this.title,
    required this.value,
    this.onEditMode,
    required this.isEditMode,
    required this.hasEditTile,
    required this.infoTile,
  }) : super(key: key);

  @override
  State<_InfoContentTile> createState() => _InfoContentTileState();
}

class _InfoContentTileState extends State<_InfoContentTile> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: (widget.hasEditTile && !widget.isEditMode) ? 0.3 : 1,
      child: IgnorePointer(
        ignoring: widget.hasEditTile && !widget.isEditMode,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300),
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
                        Text(
                          widget.title,
                          style: const TextStyle(color: Colors.black),
                        ),
                        const SizedBox(height: 15.0),
                        widget.isEditMode
                            ? widget.infoTile
                            : Text(
                                widget.value,
                                style: const TextStyle(color: Colors.black54),
                              ),
                      ],
                    ),
                  ),
                  if (!widget.isEditMode)
                    _CustomInfoBtn(
                      name: widget.value.isEmpty ? 'Add' : 'Edit',
                      color: Colors.orange,
                      textColor: Colors.white,
                      minWidth: 60.0,
                      onTap: () => widget.onEditMode?.call(true),
                    ),
                  if (!widget.isEditMode) const SizedBox(width: 20.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoNameTile extends StatefulWidget {
  final String title;
  final String firstName;
  final String lastName;
  final Function(bool isEditMode)? onEditMode;

  const _InfoNameTile({
    Key? key,
    required this.title,
    required this.firstName,
    required this.lastName,
    this.onEditMode,
  }) : super(key: key);

  @override
  State<_InfoNameTile> createState() => _InfoNameTileState();
}

class _InfoNameTileState extends State<_InfoNameTile> {
  late TextEditingController _firstNameTextController, _lastNameTextController;

  @override
  void initState() {
    _firstNameTextController = TextEditingController(text: widget.firstName);
    _lastNameTextController = TextEditingController(text: widget.lastName);
    super.initState();
  }

  @override
  void dispose() {
    _firstNameTextController.dispose();
    _lastNameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isMobileView(context)
        ? Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _getTextField(
                      _firstNameTextController,
                      hintText: 'First name',
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
                color: Colors.grey.shade300,
                onTap: () => widget.onEditMode?.call(false),
              ),
            ),
          ),
        ],
      );

  Widget _getTextField(TextEditingController controller, {required String hintText}) => TextField(
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

class _InfoTile extends StatefulWidget {
  final String title, value;
  final Function(bool isEditMode)? onEditMode;
  final String? hintText;

  const _InfoTile({
    Key? key,
    required this.title,
    required this.value,
    this.onEditMode,
    this.hintText,
  }) : super(key: key);

  @override
  State<_InfoTile> createState() => _InfoTileState();
}

class _InfoTileState extends State<_InfoTile> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.value);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isMobileView(context)
        ? Column(
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
        String lastName = widget.lastName?.call();
        String firstName = value.isEmpty && lastName.isEmpty ? 'User_${user.userId}' : value;
        user = user.copyWith(firstName: firstName, lastName: widget.lastName?.call());
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
    bool isSuccess = await FirestoreDatabase().updateUserDetails(user);
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
