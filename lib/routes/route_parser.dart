import 'package:ad/firebase/firestore_database.dart';
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
    if (pathSegments.length == 3) {
      return _getProductsRoute(pathSegments);
    } else if (pathSegments.length == 5) {
      return _getProductEventRoute(pathSegments);
    }
    return Routes.home();
  }

  Future<Routes> _getProductsRoute(List<String> pathSegments) async {
    ProductType? productType = ProductTypeExtention.getTypeByName(pathSegments[1]);
    String companyUserName = pathSegments[2];
    if (productType != null) {
      List<ProductData> products = await FirestoreDatabase().getProductsOfType(type: productType);
      return Routes.company(productType, products, companyUserName);
    }
    return Routes.invalidProduct();
  }

  Future<Routes> _getProductEventRoute(List<String> pathSegments) async {
    ProductType? productType = ProductTypeExtention.getTypeByName(pathSegments[1]);
    String companyUserName = pathSegments[2];
    String eventId = pathSegments[4];
    if (productType != null) {
      ProductEvent? event = await FirestoreDatabase().getEventById(productType, companyUserName, eventId);
      if (event != null) {
        return Routes.productEvent(productType, companyUserName, event);
      }
    }
    return Routes.invalidProductEvent(productType, companyUserName);
  }

  _parseAccountSubRoute(List<String> pathSegments) {
    if (pathSegments.length > 1) {
      String secondarySegment = pathSegments[1];
      if (secondarySegment == 'personal_info') {
        debugPrint("RouteParser _parseAccountSubRoute: ");
        return Routes.personalInfo();
      }
    }
    return Routes.account();
  }
}
