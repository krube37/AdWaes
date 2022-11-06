import 'package:ad/routes/route_page_manager.dart';
import 'package:ad/routes/route_path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyRouteDelegate extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  MyRouteDelegate() {
    pageManager.addListener(notifyListeners);
  }

  factory MyRouteDelegate.of(BuildContext context) => (Router.of(context).routerDelegate as MyRouteDelegate);

  final PageManager pageManager = PageManager();

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    debugPrint("MyRouteDelegate _onPopPage: ");
    return route.didPop(result);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: pageManager,
      child: Consumer<PageManager>(
        builder: (context, pageManager, child) {
          return Navigator(
            key: navigatorKey,
            pages: [pageManager.currentPage],
            onPopPage: _onPopPage,
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
