import 'package:ad/adwise_user.dart';
import 'package:ad/globals.dart';
import 'package:ad/provider/data_manager.dart';
import 'package:ad/screens/home/my_app_bar.dart';
import 'package:ad/screens/product_widgets/bottombar.dart';
import 'package:flutter/material.dart';

import '../../firebase/auth_manager.dart';
import '../../routes/route_page_manager.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    AdWiseUser user = DataManager().user!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MyAppBar(),
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
                      const Text(
                        "Account",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30.0,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        "Hi ${user.displayName},",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      ),
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
                                    Icons.account_circle_rounded,
                                    color: Colors.grey,
                                    size: 50.0,
                                  ),
                                ),
                                _AccountDesktopTile(
                                  user: user,
                                  header: "Card Header",
                                  description: "Card description",
                                  onTap: () {},
                                  icon: const Icon(
                                    Icons.account_circle_rounded,
                                    color: Colors.grey,
                                    size: 50.0,
                                  ),
                                ),
                                _AccountDesktopTile(
                                  user: user,
                                  header: "Card Header",
                                  description: "Card description",
                                  onTap: () {},
                                  icon: const Icon(
                                    Icons.account_circle_rounded,
                                    color: Colors.grey,
                                    size: 50.0,
                                  ),
                                ),
                                _AccountDesktopTile(
                                  user: user,
                                  header: "Card Header",
                                  description: "Card description",
                                  onTap: () {},
                                  icon: const Icon(
                                    Icons.account_circle_rounded,
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
                                    Icons.account_circle_rounded,
                                    color: Colors.red,
                                    size: 50.0,
                                  ),
                                )
                              ],
                            )
                          : ListView(
                              shrinkWrap: true,
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
                                    Icons.account_circle_rounded,
                                    color: Colors.grey,
                                  ),
                                ),
                                _AccountMobileTile(
                                  user: user,
                                  header: "Header",
                                  onTap: () {},
                                  icon: const Icon(
                                    Icons.account_circle_rounded,
                                    color: Colors.grey,
                                  ),
                                ),
                                _AccountMobileTile(
                                  user: user,
                                  header: "Header",
                                  onTap: () {},
                                  icon: const Icon(
                                    Icons.account_circle_rounded,
                                    color: Colors.grey,
                                  ),
                                ),
                                _AccountMobileTile(
                                  user: user,
                                  header: "Header",
                                  onTap: () {},
                                  icon: const Icon(
                                    Icons.account_circle_rounded,
                                    color: Colors.grey,
                                  ),
                                ),
                                _AccountMobileTile(
                                  user: user,
                                  header: "Logout",
                                  headerColor: Colors.red,
                                  onTap: _logout,
                                  icon: const Icon(
                                    Icons.account_circle_rounded,
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

  _logout() => AuthManager().signOut(context);
}

class _AccountDesktopTile extends StatelessWidget {
  final Icon icon;
  final AdWiseUser user;
  final String header;
  final String? description;
  final Function? onTap;
  final Color headerColor;

  const _AccountDesktopTile({
    Key? key,
    required this.icon,
    required this.user,
    required this.header,
    this.description,
    this.onTap,
    this.headerColor = Colors.black87,
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
          elevation: 4.0,
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
  final Color headerColor;

  const _AccountMobileTile({
    Key? key,
    required this.icon,
    required this.user,
    required this.header,
    this.onTap,
    this.headerColor = Colors.black87,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
