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

  late ProductType _productType;

  get productEvents => _productEvents;

  StreamSubscription<QuerySnapshot>? eventsStream;

  CollectionReference<Map> getEventRef(ProductType type, String productDataName) =>
      firestore.collection(type.name).doc(productDataName).collection('events');

  listenToEvents(ProductType type, String productDataName) {
    if (eventsStream != null) {
      eventsStream!.cancel();
      eventsStream = null;
    }
    _productEvents.clear();
    eventsStream = getEventRef(type, productDataName).snapshots().listen((QuerySnapshot<Map> event) {
      print("NewsPaperEventProvider listenToEvents: listening ${productDataName} and result ${event.docs.length}");
      _productEvents.clear();
      for (QueryDocumentSnapshot<Map> value in event.docs) {
        _productEvents.add(ProductEvent.fromFirestore(value.data()));
      }
      notifyListeners();
    });
  }

  // todo remove test code.
  static addProductData(ProductData product, List<ProductEvent> events, ProductType type) async {
    DocumentReference ref = FirebaseFirestore.instance.collection(type.name).doc(product.name);
    await ref.set(product.map);
    CollectionReference eventsRef = ref.collection('events');
    for (ProductEvent event in events) {
      await eventsRef.add(event.map);
    }
  }

  static removeNewsPaperData(String newsPaperName, ProductType type) async =>
      await FirebaseFirestore.instance.collection(type.name).doc(newsPaperName).delete();

  static addNewsPaperEvent(String newsPaperName, ProductEvent event) async {
    DocumentReference ref = FirebaseFirestore.instance.collection(event.type.name).doc(newsPaperName);
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
