/// firebase signIn/signUp errors and success enum
///

enum FirebaseResult { success, somethingWentWrong, invalidCredentials, passwordWrong, userNotFound, userAlreadyExist }

enum ProductType {
  tvChannel,
  newsPaper,
  billBoard,
  onlineGame,
  webpage,
  youtube,
  instagram,
  fmRadio,
  sponsorship,
}

extension ProductTypeExtention on ProductType {
  String getDisplayName() {
    switch (this) {
      case ProductType.tvChannel:
        return 'Tv Channel';
      case ProductType.newsPaper:
        return 'Newspaper';
      case ProductType.billBoard:
        return 'Billboard';
      case ProductType.onlineGame:
        return 'Online Game';
      case ProductType.webpage:
        return 'Webpage';
      case ProductType.youtube:
        return 'Youtube';
      case ProductType.instagram:
        return 'Instagram';
      case ProductType.fmRadio:
        return 'FM Radio';
      case ProductType.sponsorship:
        return 'Sponsorship';
    }
  }

  static ProductType? getTypeByName(String name) {
    try {
      return ProductType.values.firstWhere((element) => element.name == name);
    } catch (e) {
      return null;
    }
  }
}
