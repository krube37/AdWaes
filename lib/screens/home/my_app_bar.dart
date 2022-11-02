import 'package:ad/adwise_user.dart';
import 'package:ad/firebase/auth_manager.dart';
import 'package:ad/firebase/firestore_database.dart';
import 'package:ad/helper/custom_icons.dart';
import 'package:ad/provider/data_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../globals.dart';
import '../../routes/my_route_delegate.dart';
import '../sign_in/sign_in_card.dart';

/// default height of app bar is 56.0...
/// but we are using custom height in Appbar ([toolbarHeight]) as 75.0
/// if need to use any bottom feature in appbar or need to manually set different height for appBar later,
///  should change the value of [localPreferredSize] according to new height
class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Size localPreferredSize;

  const MyAppBar({Key? key})
      : localPreferredSize = const Size.fromHeight(75.0),
        super(key: key);

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => localPreferredSize;
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    DataManager dataManager = Provider.of<DataManager>(context);
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Center(
          child: InkWell(
            onTap: () => MyRouteDelegate.of(context).navigateToHome(),
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: const Text(
              'Adwise',
              style: TextStyle(
                color: primaryColor,
                fontSize: 30.0,
                fontFamily: 'Ubuntu',
              ),
            ),
          ),
        ),
      ),
      title: Container(
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          child: const _SearchBar()),
      centerTitle: true,
      leadingWidth: 150.0,
      toolbarHeight: 75.0,
      actions: dataManager.user != null
          ? [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 13.0),
                width: 50.0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25.0),
                  onTap: () async {
                    await SignInManager().showNewUserFields(context, dataManager.user!);
                  },
                  child: const Icon(
                    CustomIcons.heart_svgrepo_com,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: _navigateToAccountsPage,
                    onDoubleTap: () => AuthManager().signOut(context),
                    borderRadius: BorderRadius.circular(18.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade400,
                      backgroundImage: dataManager.user!.proPicImageProvider,
                      child: dataManager.user!.profilePhotoUrl == null
                          ? const Icon(
                              Icons.person,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  const Text(
                    'UserName',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontFamily: 'Ubuntu',
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 20.0,
              ),
            ]
          : [
              Center(
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onTap: _signIn,
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 40.0,
              ),
            ],
      backgroundColor: Colors.white,
    );
  }

  _signIn() async {
    await SignInManager().showSignInDialog(context);
  }

  _navigateToAccountsPage() {
    MyRouteDelegate.of(context).navigateToAccount();
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar({Key? key}) : super(key: key);

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;

  @override
  void initState() {
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    _searchFocusNode.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorWidth: _searchFocusNode.hasFocus ? 1.5 : 0.0,
      cursorHeight: _searchFocusNode.hasFocus ? 20.0 : 0.0,
      controller: _searchController,
      focusNode: _searchFocusNode,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: 'search for products',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.black54,
            width: 0.5,
          ),
        ),
      ),
    );
  }
}
