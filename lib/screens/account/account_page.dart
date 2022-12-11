import 'package:ad/adwise_user.dart';
import 'package:ad/firebase/api_response.dart';
import 'package:ad/screens/sign_in/sign_in_card.dart';
import 'package:ad/utils/globals.dart';
import 'package:ad/provider/data_manager.dart';
import 'package:ad/screens/home/my_app_bar.dart';
import 'package:ad/widgets/bottombar.dart';
import 'package:ad/widgets/primary_dialog.dart';
import 'package:flutter/material.dart';

import '../../firebase/auth_manager.dart';
import '../../routes/route_page_manager.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  DataManager dataManager = DataManager();

  @override
  Widget build(BuildContext context) {
    if (dataManager.user == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        AdWiseUser? user = await SignInManager().showSignInDialog(context);
        if (user != null) {
          setState(() {});
        } else {
          if (mounted) {
            PageManager.of(context).popRoute();
          }
        }
      });
      return const SizedBox();
    }
    AdWiseUser user = dataManager.user!;
    return Scaffold(
      appBar: isMobileView(context) ? const MobileAppBar(text: "Account") : const MyAppBar(showSearchBar: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 1100.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 70.0),
                      if (!isMobileView(context))
                        Text("Account",
                            style: Theme.of(context).textTheme.headline6?.copyWith(
                                  fontSize: 30.0,
                                )),
                      const SizedBox(height: 20.0),
                      Text("Hi ${user.displayName},",
                          style: Theme.of(context).textTheme.headline6?.copyWith(
                                fontSize: 20.0,
                              )),
                      const SizedBox(height: 20.0),
                      !isMobileView(context)
                          ? GridView(
                              shrinkWrap: true,
                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 500,
                                mainAxisExtent: 200,
                              ),
                              children: [
                                _AccountDesktopTile(
                                  user: user,
                                  header: "Personal Information",
                                  description: "Manage your personal Information",
                                  onTap: _navigateToPersonalInfoPage,
                                  icon: const Icon(
                                    Icons.account_circle_rounded,
                                    color: Colors.grey,
                                    size: 50.0,
                                  ),
                                ),
                                _AccountDesktopTile(
                                  user: user,
                                  header: "Booked Events",
                                  onTap: _navigateToBookedEventsPage,
                                  icon: const Icon(
                                    Icons.playlist_add_check,
                                    color: Colors.grey,
                                    size: 50.0,
                                  ),
                                ),
                                _AccountDesktopTile(
                                  user: user,
                                  header: "General Settings",
                                  description: "Set your theme mode, time zone, etc",
                                  onTap: _navigateToGeneralSettingsPage,
                                  icon: const Icon(
                                    Icons.settings,
                                    color: Colors.grey,
                                    size: 50.0,
                                  ),
                                ),
                                _AccountDesktopTile(
                                  user: user,
                                  header: "Logout",
                                  onTap: _logout,
                                  headerColor: Colors.red,
                                  icon: const Icon(
                                    Icons.logout,
                                    color: Colors.red,
                                    size: 50.0,
                                  ),
                                )
                              ],
                            )
                          : ListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                _AccountMobileTile(
                                  user: user,
                                  header: "Personal Info",
                                  onTap: _navigateToPersonalInfoPage,
                                  icon: const Icon(
                                    Icons.account_circle_rounded,
                                    color: Colors.grey,
                                  ),
                                ),
                                _AccountMobileTile(
                                  user: user,
                                  header: "Booked Events",
                                  onTap: _navigateToBookedEventsPage,
                                  icon: const Icon(
                                    Icons.playlist_add_check,
                                    color: Colors.grey,
                                  ),
                                ),
                                _AccountMobileTile(
                                  user: user,
                                  header: "General Settings",
                                  onTap: _navigateToGeneralSettingsPage,
                                  icon: const Icon(
                                    Icons.settings,
                                    color: Colors.grey,
                                  ),
                                ),
                                _AccountMobileTile(
                                  user: user,
                                  header: "Logout",
                                  headerColor: Colors.red,
                                  onTap: _logout,
                                  icon: const Icon(
                                    Icons.logout,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100.0),
            const BottomBar()
          ],
        ),
      ),
    );
  }

  _navigateToPersonalInfoPage() {
    PageManager.of(context).navigateToPersonalInfo();
  }

  _navigateToBookedEventsPage() {
    PageManager.of(context).navigateToBookedEventsPage();
  }

  _navigateToGeneralSettingsPage() {
    PageManager.of(context).navigateToGeneralSettingsPage();
  }

  _logout() async {
    PrimaryDialog dialog = PrimaryDialog(
      context,
      'Logout',
      description: 'Do you really want to Log out?',
      yesButton: PrimaryDialogButton('Logout', onTap: () async {
        Navigator.of(context).pop();
        ApiResponse response = await AuthManager().signOut(context);
        if (response.status && mounted) {
          PageManager.of(context).navigateToHome();
        }
      }),
      noButton: PrimaryDialogButton(
        'Cancel',
        onTap: () => Navigator.of(context).pop(),
      ),
    );
    await dialog.show();
  }
}

class _AccountDesktopTile extends StatelessWidget {
  final Icon icon;
  final AdWiseUser user;
  final String header;
  final String? description;
  final Function? onTap;
  final Color? headerColor;

  const _AccountDesktopTile({
    Key? key,
    required this.icon,
    required this.user,
    required this.header,
    this.description,
    this.onTap,
    this.headerColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: () => onTap?.call(),
        child: Card(
          shadowColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Expanded(
                  child: icon,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      header,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: headerColor,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: description != null
                      ? Center(
                          child: Text(
                            description!,
                            style: const TextStyle(fontSize: 13.0),
                          ),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AccountMobileTile extends StatelessWidget {
  final Icon icon;
  final AdWiseUser user;
  final String header;
  final Function? onTap;
  final Color? headerColor;

  const _AccountMobileTile({
    Key? key,
    required this.icon,
    required this.user,
    required this.header,
    this.onTap,
    this.headerColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: !isMobileView(context) ? const EdgeInsets.symmetric(horizontal: 30.0) : EdgeInsets.zero,
      child: InkWell(
        onTap: () => onTap?.call(),
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade100),
            ),
          ),
          child: Row(
            children: [
              icon,
              const SizedBox(width: 15.0),
              Expanded(
                child: Text(
                  header,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: headerColor,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_outlined,
                color: headerColor,
                size: 14.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
