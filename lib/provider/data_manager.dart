import 'package:ad/media/media_data.dart';

import '../news_paper/news_paper_data.dart';

class DataManager {

  /// singleton class
  static final DataManager _mInstance = DataManager._internal();
  DataManager._internal();
  factory DataManager() => _mInstance;

  List<ProductData> products = [];
  List<MediaData> media = [];

}