import 'package:ad/constants.dart';
import 'package:ad/product/product_event.dart';

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
  String? productUserName;

  Routes.home()
      : path = '/',
        state = RouteState.home;

  Routes.product(this.productType)
      : path = '/p/${productType!.name}',
        state = RouteState.product;

  Routes.invalidProduct()
      : path = '/p/404',
        state = RouteState.invalidProduct;

  Routes.company(this.productType, this.productUserName)
      : path = '/p/${productType!.name}/$productUserName',
        state = RouteState.company;

  Routes.productEvent(this.productType, this.productUserName, this.event)
      : path = '/p/${productType!.name}/$productUserName/${event!.eventId}',
        state = RouteState.productEvent;

  Routes.invalidProductEvent(this.productType, this.productUserName)
      : path = '/p/${productType!.name}/$productUserName/404',
        state = RouteState.invalidProductEvent;

  Routes.unknown()
      : path = '/error',
        state = RouteState.error;

  bool get isHomePage => state == RouteState.home;

  bool get isProductPage => (state == RouteState.product && productType != null);

  bool get isCompanyPage => (state == RouteState.company);

  bool get isProductErrorPage => (state == RouteState.product && productType == null);

  bool get isProductEventPage => (state == RouteState.productEvent && event != null);

  bool get isProductEventErrorPage => (state == RouteState.productEvent && event == null);

  bool get isErrorPage => state == RouteState.error;
}
