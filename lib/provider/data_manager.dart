import 'package:ad/media/media_data.dart';
import 'package:ad/product/product_data.dart';



class DataManager {

  /// singleton class
  static final DataManager _mInstance = DataManager._internal();
  DataManager._internal();
  factory DataManager() => _mInstance;

  List<ProductData> products = [];
  List<MediaData> media = [];

}