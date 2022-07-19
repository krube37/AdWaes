// ignore_for_file: constant_identifier_names

import 'package:ad/screens/home_page.dart';
import 'package:ad/screens/media_page.dart';
import 'package:ad/screens/sign_in_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String SIGN_IN = '/signin';
  static const String SIGN_UP = '/signup';
  static const String HOME_ROUTE = '/home';
  static const String BILL_BOARD = '/billboard';
  static const String NEWS_PAPER = '/newspaper';
  static const String MEDIA = '/media';
  static const String STREAMING = '/streaming';
  static const String SOCIAL_MEDIA = '/socialmedia';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    Widget widget;
    var args = settings.arguments;

    switch (settings.name) {
      case SIGN_IN:
        widget = const SignInPage();
        break;
      case SIGN_UP:
        widget = const SignUpPage();
        break;
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
        widget = const MediaPage();
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
