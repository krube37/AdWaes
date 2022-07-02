// ignore_for_file: constant_identifier_names

import 'package:ad/screens/home_page.dart';
import 'package:ad/screens/media_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String SIGN_IN = '/';
  static const String HOME_ROUTE = '/home';
  static const String BILL_BOARD = '/BillBoard';
  static const String NEWS_PAPER = '/Newspaper';
  static const String MEDIA = '/Media';
  static const String STREAMING = '/Streaming';
  static const String SOCIAL_MEDIA = '/SocialMedia';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    Widget widget;
    var args = settings.arguments;

    switch (settings.name) {
      // case SIGN_IN:
      //   // widget =
      //   break;
      case HOME_ROUTE:
        widget = HomePage();
        break;
      // case BILL_BOARD:
      //  // widget =
      //   break;
      // case NEWS_PAPER:
      //   // widget =
      //   break;
      case MEDIA:
        widget = MediaPage();
        break;
      // case STREAMING:
      //   // widget =
      //   break;
      // case SOCIAL_MEDIA:
      //   // widget =
      //   break;
      default:
        widget = HomePage();
        break;
    }
    return MaterialPageRoute(builder: (_) => widget, settings: settings);
  }
}
