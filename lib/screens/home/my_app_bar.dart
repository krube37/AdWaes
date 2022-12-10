library app_bar;

import 'dart:async';

import 'package:ad/firebase/firestore_manager.dart';
import 'package:ad/helper/custom_icons.dart';
import 'package:ad/product/product_data.dart';
import 'package:ad/product/product_event.dart';
import 'package:ad/product/product_type.dart';
import 'package:ad/provider/data_manager.dart';
import 'package:ad/screens/productscreens/product_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../general_settings.dart';
import '../../helper/my_search_field.dart';
import '../../utils/globals.dart';
import '../../routes/route_page_manager.dart';
import '../sign_in/sign_in_card.dart';

part 'search_manager.dart';

/// default height of app bar is 56.0...
/// but we are using custom height in Appbar ([toolbarHeight]) as 75.0
/// if need to use any bottom feature in appbar or need to manually set different height for appBar later,
///  should change the value of [localPreferredSize] according to new height
class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Size localPreferredSize;
  final double elevation;
  final double colorOpacity;
  final bool showSearchBar;

  const MyAppBar({
    Key? key,
    this.elevation = 0.0,
    this.colorOpacity = 1.0,
    this.showSearchBar = true,
  })  : localPreferredSize = const Size.fromHeight(75.0),
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
    GeneralSettingsProvider settingsProvider = GeneralSettingsProvider();
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor?.withAlpha(widget.colorOpacity.toInt() * 100),
      leading: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Center(
          child: InkWell(
            onTap: () => PageManager.of(context).navigateToHome(),
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Text(
              'Adwise',
              style: Theme.of(context).textTheme.headline4?.copyWith(color: primaryColor),
            ),
          ),
        ),
      ),
      title: widget.showSearchBar
          ? Container(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              child: const _SearchBar())
          : const SizedBox(),
      centerTitle: true,
      leadingWidth: 150.0,
      toolbarHeight: 75.0,
      elevation: widget.elevation,
      actions: dataManager.user != null
          ? [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 13.0),
                width: 50.0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25.0),
                  onTap: () => PageManager.of(context).navigateToFavouriteEvent(),
                  child: Icon(
                    CustomIcons.heart_svgrepo_com,
                    color: settingsProvider.isDarkTheme ? Colors.white : Colors.black,
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
                    borderRadius: BorderRadius.circular(18.0),
                    child: CircleAvatar(
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
                  Text(
                    dataManager.user!.displayName,
                    style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 16),
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
                  child: Text(
                    'Log In',
                    style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(
                width: 40.0,
              ),
            ],
    );
  }

  _signIn() async {
    await SignInManager().showSignInDialog(context);
  }

  _navigateToAccountsPage() {
    PageManager.of(context).navigateToAccount();
  }
}

class MobileAppbar extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  MobileAppbar({Key? key})
      : controller = TextEditingController(),
        focusNode = FocusNode(),
        super(key: key);

  @override
  State<MobileAppbar> createState() => _MobileAppbarState();
}

class _MobileAppbarState extends State<MobileAppbar> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      listenToSearchFocus();
    });
    return SliverAppBar(
        expandedHeight: 130.0,
        collapsedHeight: 80.0,
        pinned: true,
        floating: true,
        flexibleSpace: FlexibleSpaceBar(
          background: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Adwise',
              style: TextStyle(
                color: primaryColor,
                fontSize: 30.0,
                fontFamily: 'Ubuntu',
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: TextField(
              focusNode: widget.focusNode,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'search for products',
                border: Theme.of(context).inputDecorationTheme.border,
              ),
            ),
          ),
          centerTitle: true,
          expandedTitleScale: 1,
        ));
  }

  listenToSearchFocus() {
    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        widget.focusNode.unfocus();
        showSearch(
          context: context,
          delegate: CustomMobileSearchDelegate(
            searchFieldLabel: 'Search for Events and Companies',
          ),
        );
      }
    });
  }
}
