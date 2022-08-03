part of news_paper;

class ProductEventProvider extends ChangeNotifier {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// singleton Class
  static ProductEventProvider? mInstance;

  ProductEventProvider._internal();

  factory ProductEventProvider() => mInstance ?? (mInstance = ProductEventProvider._internal());

  static disposeProvider() {
    mInstance?.dispose();
    mInstance = null;
  }

  final List<ProductEvent> _productEvents = [];
  final CollectionReference<Map> newsPaperRef = firestore.collection('newsPaper');

  get productEvents => _productEvents;

  StreamSubscription<QuerySnapshot>? eventsStream;

  CollectionReference<Map> getEventRef(String newsPaperName) => newsPaperRef.doc(newsPaperName).collection('events');

  listenToEvents(String newsPaperName) {
    if (eventsStream != null) {
      eventsStream!.cancel();
      eventsStream = null;
    }
    _productEvents.clear();
    eventsStream = getEventRef(newsPaperName).snapshots().listen((QuerySnapshot<Map> event) {
      print("NewsPaperEventProvider listenToEvents: listening ${newsPaperName}");
      _productEvents.clear();
      for (QueryDocumentSnapshot<Map> value in event.docs) {
        print("NewsPaperEventProvider listenToEvents: insidee------------- ${value.data()}");
        _productEvents.add(ProductEvent.fromFirestore(value.data()));
      }
      notifyListeners();
    });
  }

  // todo remove test code.
  static addNewsPaperData(ProductData product, List<ProductEvent> events) async {
    DocumentReference ref = FirebaseFirestore.instance.collection('newsPaper').doc(product.name);
    await ref.set(product.map);
    CollectionReference eventsRef = ref.collection('events');
    for (ProductEvent event in events) {
      await eventsRef.add(event.map);
    }
  }

  static removeNewsPaperData(String newsPaperName) async =>
      await FirebaseFirestore.instance.collection('newsPaper').doc(newsPaperName).delete();

  static addNewsPaperEvent(String newsPaperName, ProductEvent event) async {
    DocumentReference ref = FirebaseFirestore.instance.collection('newsPaper').doc(newsPaperName);
    await ref.collection('events').add(event.map);
  }

  static deleteLastNewsPaperEvent(String newsPaper) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('newsPaper').doc(newsPaper).collection('events');
    QuerySnapshot events = await ref.get();

    if (events.docs.isNotEmpty) {
      events.docs.last.reference.delete();
    }
  }

  static getTestNewsPaperData() async {
    DocumentSnapshot snapshot = await firestore.collection('Data').doc('NewsPaper').get();
    DocumentReference reference = snapshot.reference;
  }
}
