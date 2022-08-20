import 'package:ad/constants.dart';
import 'package:ad/product/product_data.dart';
import 'package:ad/product/product_event.dart';
import 'package:ad/provider/data_manager.dart';
import 'package:ad/routes/routes.dart';
import 'package:ad/screens/error_page.dart';
import 'package:ad/screens/home_page.dart';
import 'package:ad/screens/invalid_event_page.dart';
import 'package:ad/screens/my_home_page.dart';
import 'package:ad/screens/productscreens/product_page.dart';
import 'package:flutter/material.dart';

import '../screens/product_event_page.dart';

class MyRouteDelegate extends RouterDelegate<Routes> with ChangeNotifier, PopNavigatorRouterDelegateMixin<Routes> {
  MyRouteDelegate() : _routes = Routes.home();

  factory MyRouteDelegate.of(BuildContext context) => (Router.of(context).routerDelegate as MyRouteDelegate);

  late Routes _routes;
  final GlobalKey<NavigatorState> _key = GlobalKey();

  List<Page> get _pageStack => [
        if (_routes.isHomePage)
          const MaterialPage(
            key: ValueKey('Home'),
            child: MyHomePage(),
          ),
        if (_routes.isProductPage || _routes.isCompanyPage)
          MaterialPage(
            key: const ValueKey('Products'),
            child: ProductPage(
              productType: _routes.productType!,
              currentUserName: _routes.companyUserName != null ? _routes.companyUserName! : '',
              products: DataManager().products.values.toList(),
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
    List<Page> pages = _pageStack;
    print("RouteDelegate build: ${pages.length} and ${_routes.state}");

    if (pages.isEmpty) _routes = Routes.home();

    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: _onPopPage,
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _key;

  navigateToProductEventPage(ProductType type, String productUserName, ProductEvent event) {
    _routes = Routes.productEvent(type, productUserName, event);
    notifyListeners();
  }

  navigateToCompany(ProductType type, List<ProductData> products, String companyUserName) {
    _routes = Routes.company(type, products, companyUserName);
    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(Routes configuration) async => _routes = configuration;

  @override
  Routes? get currentConfiguration => _routes;
}
