import 'package:ad/constants.dart';
import 'package:ad/product/product_event.dart';

import '../product/product_data.dart';

enum RouteState {
  home,
  product,
  company,
  invalidProduct,
  productEvent,
  invalidProductEvent,
  error,
}

class Routes {
  final String path;
  final RouteState state;

  ProductEvent? event;
  ProductType? productType;
  String? companyUserName;
  List<ProductData>? products;

  Routes.home()
      : path = '/',
        state = RouteState.home;

  Routes.company(this.productType, this.products, this.companyUserName)
      : path = '/p/${productType!.name}/$companyUserName',
        state = RouteState.company;

  Routes.invalidProduct()
      : path = '/p/404',
        state = RouteState.invalidProduct;

  Routes.productEvent(this.productType, this.companyUserName, ProductEvent this.event)
      : path = '/p/${productType!.name}/$companyUserName/event/${event.eventId}',
        state = RouteState.productEvent;

  Routes.invalidProductEvent(this.productType, this.companyUserName)
      : path = '/p/${productType!.name}/$companyUserName/event/404',
        state = RouteState.invalidProductEvent;

  Routes.unknown()
      : path = '/error',
        state = RouteState.error;

  bool get isHomePage => state == RouteState.home;

  bool get isProductPage => (state == RouteState.product && productType != null);

  bool get isCompanyPage => (state == RouteState.company && companyUserName != null);

  bool get isProductErrorPage => (state == RouteState.product && productType == null);

  bool get isProductEventPage => (state == RouteState.productEvent && event != null);

  bool get isProductEventErrorPage => (state == RouteState.productEvent && event == null);

  bool get isErrorPage => state == RouteState.error;
}
