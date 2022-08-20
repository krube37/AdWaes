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
    print("RouteParser parseRouteInformation: pathsegments ${pathSegments.length}");
    if (pathSegments.isEmpty) {
      return Routes.home();
    }

    switch (pathSegments.first) {
      case 'p':
        if (pathSegments.length > 1) {
          ProductType? productType = ProductTypeExtention.getTypeByName(pathSegments[1]);
          print("RouteParser parseRouteInformation: product type ${productType?.name}");
          if (productType != null) {
            if (pathSegments.length > 2) {
              String companyUserName = pathSegments[2];
              if (pathSegments.length > 3) {
                if(pathSegments.length>4){
                  return Routes.productEvent(productType, companyUserName, pathSegments[4]);
                }
                return Routes.invalidProductEvent(productType, companyUserName);
                //String eventId = pathSegments[3];
                //FirestoreDatabase().getEventById()
              } else {
                // return Routes.invalidProductEvent();
              }
              List<ProductData> products = await FirestoreDatabase().getProductData(type: productType);
              return Routes.company(productType, products,  companyUserName);
            }
          }
        }
        return Routes.unknown();
      case 'product-event':
        if (pathSegments.length > 1) {
          String eventId = pathSegments[1];
        }
        return Routes.unknown();
      default:
        print("RouteParser parseRouteInformation: into default ");
        return Routes.unknown();
    }
  }

  @override
  RouteInformation? restoreRouteInformation(Routes configuration) =>
      RouteInformation(location: configuration.path, state: configuration.companyUserName);
}
