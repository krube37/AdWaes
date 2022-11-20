import 'package:ad/helper/bottom_navigation_bar.dart';
import 'package:ad/routes/route_page_manager.dart';
import 'package:ad/routes/route_path.dart';
import 'package:ad/screens/home/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/globals.dart';

class MyRouteDelegate extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  MyRouteDelegate() {
    pageManager.addListener(notifyListeners);
  }

  int selectedIndex = 0;

  factory MyRouteDelegate.of(BuildContext context) => (Router.of(context).routerDelegate as MyRouteDelegate);

  final PageManager pageManager = PageManager();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: pageManager,
      child: Consumer<PageManager>(
        builder: (context, pageManager, child) {
          return HomeScaffold(
            pageManager: pageManager,
            navigatorKey: navigatorKey,
          );
        },
      ),
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => pageManager.navigatorKey;

  @override
  Future<void> setNewRoutePath(RoutePath configuration) async => await pageManager.setNewRoutePath(configuration);

  @override
  RoutePath? get currentConfiguration => pageManager.currentPath;
}

class HomeScaffold extends StatefulWidget {
  final PageManager pageManager;
  final GlobalKey<NavigatorState>? navigatorKey;

  const HomeScaffold({
    Key? key,
    required this.pageManager,
    this.navigatorKey,
  }) : super(key: key);

  @override
  State<HomeScaffold> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: widget.navigatorKey,
        pages: [widget.pageManager.currentPage],
        onPopPage: _onPopPage,
      ),
      bottomNavigationBar: isMobileView(context)
          ? HomeBottomNavigationBar(
              selectedIndex: selectedIndex,
              onItemTapped: onItemTapped,
            )
          : null,
    );
  }

  onItemTapped(int index) {
    switch (index) {
      case 0:
        PageManager.of(context).navigateToHome();
        break;
      case 1:
        PageManager.of(context).navigateToFavouriteEvent();
        break;
      case 2:
        PageManager.of(context).navigateToAccount();
        break;
    }

    setState(() => selectedIndex = index);
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    debugPrint("MyRouteDelegate _onPopPage: ");
    return route.didPop(result);
  }
}
