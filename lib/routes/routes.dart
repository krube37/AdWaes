// ignore_for_file: constant_identifier_names

import 'package:ad/AdWiseUser.dart';
import 'package:ad/constants.dart';
import 'package:ad/product/product_event.dart';
import 'package:ad/screens/account_page.dart';
import 'package:ad/screens/home_page.dart';
import 'package:ad/screens/product_event_page.dart';
import 'package:ad/screens/productscreens/product_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String HOME_ROUTE = '/home';
  static const String BILL_BOARD = '/billboard';
  static const String PRODUCT_DATA = '/product-data';
  static const String PRODUCT_EVENT_DATA = '/product-event-data';
  static const String ACCOUNT_PAGE = '/account';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    Widget widget;
    var args = settings.arguments;

    switch (settings.name) {
      case HOME_ROUTE:
        widget = HomePage();
        break;
      case PRODUCT_DATA:
        if (args == null || args is! ProductType) {
          widget = HomePage();
        } else {
          widget = ProductPage(productType: args);
        }
        break;
      case PRODUCT_EVENT_DATA:
        if (args == null || args is! ProductEvent) {
          widget = HomePage();
        } else {
          widget = ProductEventPage(event: args);
        }
        break;
      case ACCOUNT_PAGE:
        widget = AccountPage(user: args as AdWiseUser);
        break;
      default:
        widget = HomePage();
        break;
    }
    return MaterialPageRoute(builder: (_) => widget, settings: settings);
  }
}
