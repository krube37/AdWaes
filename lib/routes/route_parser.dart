import 'package:ad/constants.dart';
import 'package:ad/firebase/firestore_database.dart';
import 'package:ad/product/product_data.dart';
import 'package:ad/product/product_event.dart';
import 'package:ad/routes/routes.dart';
import 'package:flutter/material.dart';

class RouteParser extends RouteInformationParser<Routes> {
  @override
  Future<Routes> parseRouteInformation(RouteInformation routeInformation) async {
    final Uri uri = Uri.parse(routeInformation.location!);

    print("RouteParser parseRouteInformation:  $uri");

    List<String> pathSegments = uri.pathSegments;
    switch (pathSegments.length) {
      case 0:
      case 1:
        return Routes.home();
      case 3:
        return await _getProductsRoute(pathSegments);
      case 5:
        return await _getProductEventRoute(pathSegments);
      default:
        return Routes.unknown();
    }
  }

  @override
  RouteInformation? restoreRouteInformation(Routes configuration) =>
      RouteInformation(location: configuration.path, state: configuration.companyUserName);

  Future<Routes> _getProductsRoute(List<String> pathSegments) async {
    ProductType? productType = ProductTypeExtention.getTypeByName(pathSegments[1]);
    String companyUserName = pathSegments[2];
    if (productType != null) {
      List<ProductData> products = await FirestoreDatabase().getProductData(type: productType);
      return Routes.company(productType, products, companyUserName);
    }
    return Routes.invalidProduct();
  }

  Future<Routes> _getProductEventRoute(List<String> pathSegments) async {
    ProductType? productType = ProductTypeExtention.getTypeByName(pathSegments[1]);
    String companyUserName = pathSegments[2];
    String eventId = pathSegments[4];
    if (productType != null) {
      ProductEvent? event = await FirestoreDatabase().getEventById(productType, eventId);
      if(event != null) {
        return Routes.productEvent(productType, companyUserName, event);
      }
    }
    return Routes.invalidProductEvent(productType, companyUserName);
  }
}
