import 'dart:math';

import 'package:flutter/material.dart';

class PersonalInfoPage extends StatelessWidget {
  const PersonalInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Info',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: screenSize.width < 700 ? const _MobileView() : const _TabAndDesktopView(),
    );
  }
}

class _TabAndDesktopView extends StatelessWidget {
  const _TabAndDesktopView({Key? key}) : super(key: key);

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
  const _MobileView({Key? key}) : super(key: key);

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
    return Column(
      children: [
        CircleAvatar(
          radius: 100.0,
          backgroundImage: Image.asset(
            'assets/images/newspaper.jpeg',
          ).image,
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

  const _CustomInfoBtn({
    Key? key,
    required this.name,
    required this.color,
    this.textColor,
    this.onTap,
    this.minWidth,
    this.height = 30.0,
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
          //vertical: 8.0,
          horizontal: minWidth != null ? minWidth! / 2.5 : 10,
        ),
        child: Center(
          child: Text(
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
  List<bool> editMode = [false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoTile(
          title: 'Name',
          value: 'Shanmugam',
          isEditMode: editMode[0],
          onEditMode: (isEditMode) => setState(() => editMode[0] = isEditMode),
          hasEditTile: editMode.any((element) => element == true),
          isNameTile: true,
        ),
        _InfoTile(
          title: 'Name',
          value: 'Shanmugam',
          isEditMode: editMode[1],
          onEditMode: (isEditMode) => setState(() => editMode[1] = isEditMode),
          hasEditTile: editMode.any((element) => element == true),
        ),
        _InfoTile(
          title: 'Name',
          value: 'Shanmugam',
          isEditMode: editMode[2],
          onEditMode: (isEditMode) => setState(() => editMode[2] = isEditMode),
          hasEditTile: editMode.any((element) => element == true),
        ),
        _InfoTile(
          title: 'Name',
          value: 'Shanmugam',
          isEditMode: editMode[3],
          onEditMode: (isEditMode) => setState(() => editMode[3] = isEditMode),
          hasEditTile: editMode.any((element) => element == true),
        ),
        _InfoTile(
          title: 'Name',
          value: 'Shanmugam',
          isEditMode: editMode[4],
          onEditMode: (isEditMode) => setState(() => editMode[4] = isEditMode),
          hasEditTile: editMode.any((element) => element == true),
        ),
      ],
    );
  }
}

class _InfoTile extends StatefulWidget {
  final String title, value;
  final Function(bool isEditMode)? onEditMode;
  final bool isEditMode;
  final bool hasEditTile;
  final bool isNameTile;

  const _InfoTile({
    Key? key,
    required this.title,
    required this.value,
    this.onEditMode,
    this.isEditMode = false,
    this.hasEditTile = false,
    this.isNameTile = false,
  }) : super(key: key);

  @override
  State<_InfoTile> createState() => _InfoTileState();
}

class _InfoTileState extends State<_InfoTile> {
  late TextEditingController _controller, _lastNameController;

  @override
  void initState() {
    _controller = TextEditingController();
    if (widget.isNameTile) {
      _lastNameController = TextEditingController();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
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
                            ? screenSize.width < 700
                            ? Column(
                          children: [
                            widget.isNameTile
                                ? Row(
                              children: [
                                Expanded(child: _getTextField(_controller)),
                                const SizedBox(width: 10.0),
                                Expanded(child: _getTextField(_lastNameController))
                              ],
                            )
                                : _getTextField(_controller),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 200),
                              child: _getSaveCancelBtns(),
                            )
                          ],
                        )
                            : Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: _getTextField(_controller),
                            ),
                            const SizedBox(width: 30.0),
                            Expanded(
                              flex: 1,
                              child: _getSaveCancelBtns(),
                            ),
                          ],
                        )
                            : Text(
                          widget.value,
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  if (!widget.isEditMode)
                    _CustomInfoBtn(
                      name: 'Edit',
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

  Widget _getSaveCancelBtns() => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      const Expanded(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: _CustomInfoBtn(
            name: 'Save',
            color: Colors.orange,
            textColor: Colors.white,
          ),
        ),
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

  Widget _getTextField(TextEditingController controller) => TextField(
    controller: controller,
    decoration: const InputDecoration(
      hintText: 'First name',
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
    ),
  );
}

