import 'package:ad/routes/route_page_manager.dart';
import 'package:ad/routes/route_path.dart';
import 'package:flutter/material.dart';

class RouteParser extends RouteInformationParser<RoutePath> {
  @override
  Future<RoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final Uri uri = Uri.parse(routeInformation.location!);
    debugPrint("RouteParser parseRouteInformation:  $uri");

    return PageManager.parseRoute(routeInformation.location);
  }

  @override
  RouteInformation? restoreRouteInformation(RoutePath configuration) => RouteInformation(location: configuration.path);
}
