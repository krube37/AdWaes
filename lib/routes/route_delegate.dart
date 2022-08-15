import 'package:ad/constants.dart';
import 'package:ad/product/product_event.dart';
import 'package:ad/routes/routes.dart';
import 'package:ad/screens/error_page.dart';
import 'package:ad/screens/home_page.dart';
import 'package:ad/screens/invalid_event_page.dart';
import 'package:ad/screens/product_event_page.dart';
import 'package:ad/screens/productscreens/product_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RouteDelegate extends RouterDelegate<Routes> with ChangeNotifier, PopNavigatorRouterDelegateMixin<Routes> {
  RouteDelegate() {
    _isLoggedIn = FirebaseAuth.instance.currentUser != null;
    _routes = Routes.home();
  }

  late bool _isLoggedIn;
  late Routes _routes;
  final GlobalKey<NavigatorState> _key = GlobalKey();

  List<Page> get _pageStack => [
        if (_routes.isHomePage)
          MaterialPage(
            key: const ValueKey('Home'),
            child: HomePage(
              navigateToProductPage: _navigateToProductPage,
            ),
          ),
        if (_routes.isProductPage || _routes.isCompanyPage)
          MaterialPage(
            key: const ValueKey('Products'),
            child: ProductPage(
              productType: _routes.productType!,
              navigateToProductEventPage: _navigateToProductEventPage,
              navigateToCompany: _navigateToCompany,
            ),
          ),
        if (_routes.isProductErrorPage)
          const MaterialPage(
            key: ValueKey('ProductsError'),
            child: ErrorPage(),
          ),
        if (_routes.isProductEventPage)
          MaterialPage(
            key: const ValueKey('ProductEvent'),
            child: ProductEventPage(event: _routes.event!),
          ),
        if (_routes.isProductEventErrorPage)
          const MaterialPage(
            key: ValueKey('ProductEventError'),
            child: InvalidEventPage(),
          ),
        if (_routes.isErrorPage)
          const MaterialPage(
            key: ValueKey('ErrorPage'),
            child: ErrorPage(),
          ),
      ];

  bool _onPopPage(Route<dynamic> route, result) {
    print("RouteDelegate _onPopPage: ${route.didPop(result)}, result $result");
    return route.didPop(result);
  }

  @override
  Widget build(BuildContext context) {
    print("RouteDelegate build: ${_pageStack.length} and ${_routes.state}");

    if (_pageStack.isEmpty) {
      _routes = Routes.home();
    }

    return Navigator(
      key: navigatorKey,
      pages: _pageStack,
      onPopPage: _onPopPage,
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _key;

  _navigateToProductPage(ProductType productType) {
    _routes = Routes.product(productType);
    notifyListeners();
  }

  _navigateToProductEventPage(ProductType type, String productUserName, ProductEvent event) {
    _routes = Routes.productEvent(type, productUserName, event);
    notifyListeners();
  }

  _navigateToCompany(ProductType type, String companyUserName) {
    _routes = Routes.company(type, companyUserName);
    //notifyListeners();
    setNewRoutePath(_routes);
    //RouteDelegate().setNewRoutePath(_routes);
  }

  @override
  Future<void> setNewRoutePath(Routes configuration) async => _routes = configuration;

  @override
  Routes? get currentConfiguration => _routes;
}
