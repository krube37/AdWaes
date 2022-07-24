import 'dart:async';

import 'package:ad/news_paper/news_paper_data.dart';
import 'package:ad/news_paper/news_paper_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewsPaperEventProvider extends ChangeNotifier {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// singleton Class
  static NewsPaperEventProvider? mInstance;

  NewsPaperEventProvider._internal();

  factory NewsPaperEventProvider() => mInstance ?? (mInstance = NewsPaperEventProvider._internal());

  static disposeProvider() {
    mInstance?.dispose();
    mInstance = null;
  }

  List<NewsPaperEvent> _newsPaperEvents = [];
  final CollectionReference<Map> newsPaperRef = firestore.collection('newsPaper');

  get newsPaperEvents => _newsPaperEvents;

  StreamSubscription<QuerySnapshot>? eventsStream;

  CollectionReference<Map> getEventRef(String newsPaperName) => newsPaperRef.doc(newsPaperName).collection('events');

  listenToEvents(String newsPaperName) {
    if (eventsStream != null) {
      eventsStream!.cancel();
      eventsStream = null;
    }
    _newsPaperEvents.clear();
    eventsStream = getEventRef(newsPaperName).snapshots().listen((QuerySnapshot<Map> event) {
      print("NewsPaperEventProvider listenToEvents: listening ${newsPaperName}");
      _newsPaperEvents.clear();
      for (QueryDocumentSnapshot<Map> value in event.docs) {
        print("NewsPaperEventProvider listenToEvents: insidee------------- ${value.data()}");
        _newsPaperEvents.add(NewsPaperEvent.fromFirestore(value.data()));
      }
      notifyListeners();
    });
  }

  // todo remove test code.
  static addNewsPaperData(NewsPaper newsPaper) async {
    DocumentReference ref = FirebaseFirestore.instance.collection('newsPaper').doc(newsPaper.name);
    await ref.set(newsPaper.map);
    CollectionReference eventsRef = ref.collection('events');
    for (NewsPaperEvent event in newsPaper.events) {
      await eventsRef.add(event.map);
    }
  }

  static removeNewsPaperData(String newsPaperName) async =>
      await FirebaseFirestore.instance.collection('newsPaper').doc(newsPaperName).delete();

  static addNewsPaperEvent(String newsPaperName, NewsPaperEvent event) async{
    DocumentReference ref = FirebaseFirestore.instance.collection('newsPaper').doc(newsPaperName);
    await ref.collection('events').add(event.map);
  }

  static deleteLastNewsPaperEvent(String newsPaper) async{
    CollectionReference ref = FirebaseFirestore.instance.collection('newsPaper').doc(newsPaper).collection('events');
    QuerySnapshot events = await ref.get();

    if(events.docs.isNotEmpty){
      events.docs.last.reference.delete();
    }
  }

  static getTestNewsPaperData() async {
    DocumentSnapshot snapshot = await firestore.collection('Data').doc('NewsPaper').get();
    DocumentReference reference = snapshot.reference;
  }
}
