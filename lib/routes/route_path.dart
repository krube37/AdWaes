import '../product/product_type.dart';

enum RouteState {
  home,
  account,
  personalInfo,
  bookedEvents,
  favouriteScreen,
  generalSettings,
  product,
  company,
  productEvent,
}

class RoutePath {
  final String path;
  final RouteState state;

  String? eventId;
  ProductType? productType;
  String? companyUserName;

  RoutePath.home()
      : path = '/',
        state = RouteState.home;

  RoutePath.account()
      : path = '/account',
        state = RouteState.account;

  RoutePath.personalInfo()
      : path = '/account/personal_info',
        state = RouteState.personalInfo;

  RoutePath.bookedEventsPage()
      : path = '/account/booked_events',
        state = RouteState.bookedEvents;

  RoutePath.favouriteEvents()
      : path = '/account/favourites',
        state = RouteState.favouriteScreen;

  RoutePath.generalSettings()
      : path = '/general_settings',
        state = RouteState.generalSettings;

  RoutePath.company(this.productType, this.companyUserName)
      : path = '/p/${productType!.name}/$companyUserName',
        state = RouteState.company;

  RoutePath.product(this.productType)
      : path = '/p/${productType!.name}',
        state = RouteState.product;

  RoutePath.productEvent(String this.eventId)
      : path = '/p/event/$eventId',
        state = RouteState.productEvent;

  bool get isHomePage => state == RouteState.home;

  bool get isProductPage => (state == RouteState.product && productType != null);

  bool get isCompanyPage => (state == RouteState.company && companyUserName != null);

  bool get isProductEventPage => (state == RouteState.productEvent && eventId != null);

  bool get isAccountPage => state == RouteState.account;

  bool get isPersonalInfoPage => state == RouteState.personalInfo;

  bool get isFavouriteScreen => state == RouteState.favouriteScreen;

  bool get isBookedEventsPage => state == RouteState.bookedEvents;

  bool get isGeneralSettingsPage => state == RouteState.generalSettings;
}
