library news_paper;

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../news_paper/news_paper_data.dart';
import '../news_paper/news_paper_event.dart';
import 'data_manager.dart';

part 'news_paper_event_provider.dart';

class NewsPaperProvider extends ChangeNotifier {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference<Map> newsPaperRef = firestore.collection('newsPaper');
  final List<NewsPaper> _newsPapers;
  late DataManager dataManager;

  /// sigleton class
  static NewsPaperProvider? mInstance;

  NewsPaperProvider._internal()
      : dataManager = DataManager(),
        _newsPapers = DataManager().newsPapers;

  factory NewsPaperProvider() => mInstance ?? (mInstance = NewsPaperProvider._internal());

  initialise() async {
    QuerySnapshot<Map> papers = await newsPaperRef.get();
    newsPapers.clear();
    for (QueryDocumentSnapshot<Map> value in papers.docs) {
      newsPapers.add(NewsPaper.fromFirestore(value.data()));
    }
    dataManager.newsPapers = newsPapers;
  }

  List<NewsPaper> get newsPapers => _newsPapers;

  StreamSubscription<QuerySnapshot>? newsPapersStream;

  listenToNewsPapers() {
    if (newsPapersStream != null) {
      newsPapersStream!.cancel();
      newsPapersStream = null;
    }
    newsPapersStream = newsPaperRef.snapshots().listen((event) {
      _newsPapers.clear();
      for (QueryDocumentSnapshot<Map> value in event.docs) {
        _newsPapers.add(NewsPaper.fromFirestore(value.data()));
      }
      dataManager.newsPapers = _newsPapers;
      notifyListeners();
    });
  }

  static disposeProvider() {
    mInstance?.dispose();
    mInstance = null;
  }
}
