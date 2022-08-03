library news_paper;

import 'dart:async';

import 'package:ad/news_paper/news_paper_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../news_paper/news_paper_data.dart';
import 'data_manager.dart';

part 'news_paper_event_provider.dart';

class ProductDataProvider extends ChangeNotifier {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference<Map> newsPaperRef = firestore.collection('newsPaper');
  final List<ProductData> _products;
  late DataManager dataManager;

  /// sigleton class
  static ProductDataProvider? mInstance;

  ProductDataProvider._internal()
      : dataManager = DataManager(),
        _products = DataManager().products;

  factory ProductDataProvider() => mInstance ?? (mInstance = ProductDataProvider._internal());

  Future<List<ProductData>> initialise() async {
    QuerySnapshot<Map> papers = await newsPaperRef.get();
    _products.clear();
    for (QueryDocumentSnapshot<Map> value in papers.docs) {
      _products.add(ProductData.fromFirestore(value.data()));
    }
    dataManager.products = _products;
    return _products;
  }

  List<ProductData> get products => _products;

  StreamSubscription<QuerySnapshot>? newsPapersStream;

  listenToNewsPapers() {
    if (newsPapersStream != null) {
      newsPapersStream!.cancel();
      newsPapersStream = null;
    }
    newsPapersStream = newsPaperRef.snapshots().listen((event) {
      _products.clear();
      for (QueryDocumentSnapshot<Map> value in event.docs) {
        _products.add(ProductData.fromFirestore(value.data()));
      }
      dataManager.products = _products;
      notifyListeners();
    });
  }

  static disposeProvider() {
    mInstance?.dispose();
    mInstance = null;
  }
}
