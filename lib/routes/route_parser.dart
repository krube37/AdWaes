import 'package:ad/firebase/firestore_manager.dart';
import 'package:ad/product/product_data.dart';
import 'package:ad/product/product_event.dart';
import 'package:ad/routes/routes.dart';
import 'package:flutter/material.dart';

import '../product/product_type.dart';

class RouteParser extends RouteInformationParser<Routes> {
  @override
  Future<Routes> parseRouteInformation(RouteInformation routeInformation) async {
    final Uri uri = Uri.parse(routeInformation.location!);

    debugPrint("RouteParser parseRouteInformation:  $uri");

    List<String> pathSegments = uri.pathSegments;
    if (pathSegments.isEmpty) return Routes.home();

    String primarySegment = pathSegments[0];
    if (primarySegment == 'account') {
      return _parseAccountSubRoute(pathSegments);
    } else if (primarySegment == 'p' && pathSegments.length > 1) {
      return _parseProductSubRoute(pathSegments);
    }
    return Routes.home();
  }

  @override
  RouteInformation? restoreRouteInformation(Routes configuration) =>
      RouteInformation(location: configuration.path, state: configuration.companyUserName);

  Future<Routes> _parseProductSubRoute(List<String> pathSegments) async {
    String secondarySegment = pathSegments[1];
    if (secondarySegment == 'event' && pathSegments.length > 1) {
      return _getProductEventRoute(pathSegments);
    } else if (secondarySegment == '404') {
      return Routes.invalidProduct();
    } else {
      return _getProductsRoute(pathSegments);
    }
  }

  Future<Routes> _getProductsRoute(List<String> pathSegments) async {
    ProductType? productType = ProductTypeExtention.getTypeByName(pathSegments[1]);
    String companyUserName = pathSegments[2];
    if (productType != null) {
      List<ProductData> products = await FirestoreManager().getProductsOfType(type: productType);
      return Routes.company(productType, products, companyUserName);
    }
    return Routes.invalidProduct();
  }

  Future<Routes> _getProductEventRoute(List<String> pathSegments) async {
    String eventId = pathSegments[2];
    ProductEvent? event = await FirestoreManager().getEventById(eventId);
    if (event != null) {
      return Routes.productEvent(event);
    }
    return Routes.invalidProduct();
  }

  _parseAccountSubRoute(List<String> pathSegments) {
    if (pathSegments.length > 1) {
      String secondarySegment = pathSegments[1];
      if (secondarySegment == 'personal_info') {
        return Routes.personalInfo();
      } else if (secondarySegment == 'favourites') {
        return Routes.favouriteEvents();
      } else if (secondarySegment == 'booked_events') {
        return Routes.bookedEventsPage();
      }
    }
    return Routes.account();
  }
}
