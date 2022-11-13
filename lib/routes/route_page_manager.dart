import 'package:ad/routes/route_path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../product/product_type.dart';
import '../provider/product_data_provider.dart';
import '../screens/account/account_page.dart';
import '../screens/account/personal_info_page.dart';
import '../screens/account/booked_events_page.dart';
import '../screens/account/favourite_screen.dart';
import '../screens/home/my_home_page.dart';
import '../screens/product_event_screen/product_event_page.dart';
import '../screens/productscreens/product_page.dart';

class PageManager extends ChangeNotifier {
  static PageManager of(BuildContext context) => Provider.of<PageManager>(context, listen: false);

  final GlobalKey<NavigatorState> _key = GlobalKey();

  GlobalKey<NavigatorState> get navigatorKey => _key;

  Page _currentPage = MaterialPage(
    key: UniqueKey(),
    child: const MyHomePage(),
    name: RoutePath.home().path,
  );

  Page get currentPage => _currentPage;

  RoutePath get currentPath {
    debugPrint("PageManager currentPath: checkzzz pages info $currentPage");
    return parseRoute(_currentPage.name);
  }

  Future<void> setNewRoutePath(RoutePath configuration) async {
    debugPrint(
        "PageManager setNewRoutePath: page conditions ${configuration.isCompanyPage}, ${configuration.isProductPage}, ${configuration.path}");

    if (configuration.isAccountPage) {
      _currentPage = MaterialPage(
        key: const ValueKey('AccountPage'),
        name: configuration.path,
        child: const AccountPage(),
      );
    } else if (configuration.isPersonalInfoPage) {
      _currentPage = MaterialPage(
        key: const ValueKey('PersonalInfoPage'),
        name: configuration.path,
        child: const PersonalInfoPage(),
      );
    } else if (configuration.isFavouriteScreen) {
      _currentPage = MaterialPage(
        key: const ValueKey('FavouriteEventsPage'),
        name: configuration.path,
        child: const FavouriteScreen(),
      );
    } else if (configuration.isBookedEventsPage) {
      _currentPage = MaterialPage(
        key: const ValueKey('BookedEventsPage'),
        name: configuration.path,
        child: const BookedEventsPage(),
      );
    } else if (configuration.isProductPage || configuration.isCompanyPage) {
      _currentPage = MaterialPage(
        key: ValueKey(configuration.productType!.name),
        name: configuration.path,
        child: ChangeNotifierProvider<ProductDataProvider>(
          create: (_) => ProductDataProvider(),
          child: ProductPage(
            productType: configuration.productType!,
            currentUserName: configuration.companyUserName,
          ),
        ),
      );
    } else if (configuration.isProductEventPage) {
      _currentPage = MaterialPage(
        key: const ValueKey('ProductEventPage'),
        name: configuration.path,
        child: ProductEventPage(eventId: configuration.eventId!),
      );
    } else {
      _currentPage = MaterialPage(
        key: const ValueKey('HomePage'),
        child: const MyHomePage(),
        name: RoutePath.home().path,
      );
    }
    notifyListeners();
  }

  /// parse the url, returns the corresponding [RoutePath]
  static RoutePath parseRoute(String? uriString) {
    debugPrint("PageManager parseRoute: uriString $uriString");
    if (uriString == null) return RoutePath.home();

    Uri uri = Uri.parse(uriString);
    List<String> pathSegments = uri.pathSegments;
    if (pathSegments.isEmpty) return RoutePath.home();

    String primarySegment = pathSegments[0];
    if (primarySegment == 'account') {
      return _parseAccountSubRoute(pathSegments);
    } else if (primarySegment == 'p' && pathSegments.length > 1) {
      return _parseProductSubRoute(pathSegments);
    }
    return RoutePath.home();
  }

  static RoutePath _parseProductSubRoute(List<String> pathSegments) {
    String secondarySegment = pathSegments[1];
    if (secondarySegment == 'event' && pathSegments.length > 1) {
      return _getProductEventRoute(pathSegments);
    } else {
      return _getProductsRoute(pathSegments);
    }
  }

  static RoutePath _getProductsRoute(List<String> pathSegments) {
    ProductType? productType = ProductTypeExtention.getTypeByName(pathSegments[1]);
    if (pathSegments.length < 3) return RoutePath.product(productType);
    String companyUserName = pathSegments[2];
    if (productType != null) {
      return RoutePath.company(productType, companyUserName);
    }
    return RoutePath.home();
  }

  static RoutePath _getProductEventRoute(List<String> pathSegments) {
    String eventId = pathSegments[2];
    return RoutePath.productEvent(eventId);
  }

  static RoutePath _parseAccountSubRoute(List<String> pathSegments) {
    if (pathSegments.length > 1) {
      String secondarySegment = pathSegments[1];
      if (secondarySegment == 'personal_info') {
        return RoutePath.personalInfo();
      } else if (secondarySegment == 'favourites') {
        return RoutePath.favouriteEvents();
      } else if (secondarySegment == 'booked_events') {
        return RoutePath.bookedEventsPage();
      }
    }
    return RoutePath.account();
  }

  /// navigation helper methods
  navigateToProductEventPage(String eventId) => setNewRoutePath(RoutePath.productEvent(eventId));

  navigateToCompany(ProductType type, String companyUserName) {
    return setNewRoutePath(RoutePath.company(type, companyUserName));
  }

  navigateToProduct(ProductType type) => setNewRoutePath(RoutePath.product(type));

  navigateToHome() => setNewRoutePath(RoutePath.home());

  navigateToAccount() => setNewRoutePath(RoutePath.account());

  navigateToPersonalInfo() => setNewRoutePath(RoutePath.personalInfo());

  navigateToBookedEventsPage() => setNewRoutePath(RoutePath.bookedEventsPage());

  navigateToFavouriteEvent() => setNewRoutePath(RoutePath.favouriteEvents());
}
