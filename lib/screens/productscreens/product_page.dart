import 'package:ad/constants.dart';
import 'package:ad/globals.dart';
import 'package:ad/news_paper/news_paper_data.dart';
import 'package:ad/news_paper/news_paper_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../news_paper/news_paper_event.dart';
import '../../provider/news_paper_provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int cursorIndex = -1;
  int selectedIndex = 0;
  List<ProductData> products = [];
  late ProductEventProvider productEventProvider;
  late ProductDataProvider productDataProvider;
  bool _isListeningToEvent = false;

  @override
  void didChangeDependencies() {
    productDataProvider = ProductDataProvider();
    productEventProvider = ProductEventProvider();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    ProductEventProvider.disposeProvider();
    ProductDataProvider.disposeProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    products = productDataProvider.products;

    return FutureBuilder(
      future: productDataProvider.initialise(),
      builder: (BuildContext context, AsyncSnapshot<List<ProductData>> snapshot) {
        if(!snapshot.hasData){
          return const Center(child: CircularProgressIndicator());
        }
        if(snapshot.hasError){
          return const Center(child: Text('Could not load Page!'),);
        }
        products = snapshot.data!;

        if(products.isEmpty){
          return  ElevatedButton(
              onPressed: () {
                List<ProductEvent> events = [
                  ProductEvent(
                      eventName: "movie event india ",
                      price: 2000,
                      dateTime: DateTime.now(),
                      type: ProductType.newsPaper),
                  // NewsPaperEvent("Function event india ", "center", 10000, 1, dateTime: DateTime.now()),
                  // NewsPaperEvent("scientific event ", "top center", 5000, 5, dateTime: DateTime.now())
                ];
                List<ProductData> newsPapers = [
                  ProductData(
                      name: 'The Hindu',
                      totalEvents: 10,
                      description: ' this is product data description string ',
                      type: ProductType.newsPaper),
                  ProductData(
                      name: 'The New York Times',
                      totalEvents: 15,
                      description: 'this is product data description string ',
                      type: ProductType.newsPaper),
                ];
                ProductEventProvider.addNewsPaperData(
                  ProductData(
                      name: 'The New York Times',
                      totalEvents: 15,
                      description: 'this is product data description string ',
                      type: ProductType.newsPaper),
                  events,
                );
              },
              child: Text("Add"));
        }

        return Scaffold(
            appBar: getAppBar(MediaQuery.of(context).size),
            body: Consumer<ProductDataProvider>(
              builder: (context, newsPaperValue, _) {
                if (!_isListeningToEvent) {
                  productEventProvider.listenToEvents(products[selectedIndex].name);
                  _isListeningToEvent = true;
                }
                return Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return ProductTile(
                                productData: products[index],
                                isTileSelected: selectedIndex == index,
                                onClick: () {
                                  if (selectedIndex == index) return;
                                  setState(() {
                                    selectedIndex = index;
                                    _isListeningToEvent = false;
                                  });
                                });
                          }),
                    ),
                    Expanded(
                      flex: 3,
                      child: products.isEmpty
                          ? const Center(
                        child: Text("there are no Events available "),
                      )
                          : Consumer<ProductEventProvider>(builder: (_, newsPaperValue, child) {
                        List<ProductEvent> events = Provider.of<ProductEventProvider>(context).productEvents;
                        return events.isEmpty
                        //todo: do something here because if is empty, then will always show circular progress
                            ? const Center(child: CircularProgressIndicator())
                            : GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isDesktopView(screenSize) ? 2 : 1,
                              childAspectRatio: isDesktopView(screenSize) ? 3 / 2 : 6,
                            ),
                            itemCount: events.length,
                            itemBuilder: (context, index) {
                              return StatefulBuilder(
                                builder: (BuildContext context, void Function(void Function()) setState) {
                                  return Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: MouseRegion(
                                      onEnter: (_) => setState(() => cursorIndex = index),
                                      onExit: (_) => setState(() => cursorIndex = -1),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            side: BorderSide(
                                              color: Colors.grey.shade400,
                                              width: 0.5,
                                            )),
                                        elevation: cursorIndex == index ? 10 : 0,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(10),
                                          hoverColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          onTap: () {},
                                          child: Container(
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                            child: Center(child: Text(events[index].eventName)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            });
                      }),
                    ),
                    // todo: remove test code
                    Expanded(
                        child: Column(
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  List<ProductEvent> events = [
                                    ProductEvent(
                                        eventName: "movie event india ",
                                        price: 2000,
                                        dateTime: DateTime.now(),
                                        type: ProductType.newsPaper),
                                    // NewsPaperEvent("Function event india ", "center", 10000, 1, dateTime: DateTime.now()),
                                    // NewsPaperEvent("scientific event ", "top center", 5000, 5, dateTime: DateTime.now())
                                  ];
                                  List<ProductData> newsPapers = [
                                    ProductData(
                                        name: 'The Hindu',
                                        totalEvents: 10,
                                        description: ' this is product data description string ',
                                        type: ProductType.newsPaper),
                                    ProductData(
                                        name: 'The New York Times',
                                        totalEvents: 15,
                                        description: 'this is product data description string ',
                                        type: ProductType.newsPaper),
                                  ];
                                  ProductEventProvider.addNewsPaperData(
                                    ProductData(
                                        name: 'The New York Times',
                                        totalEvents: 15,
                                        description: 'this is product data description string ',
                                        type: ProductType.newsPaper),
                                    events,
                                  );
                                },
                                child: Text("Add")),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  ProductEventProvider.removeNewsPaperData('The Hindu');
                                },
                                child: Text("delete")),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  ProductEventProvider.addNewsPaperEvent(
                                    'The Hindu',
                                    ProductEvent(
                                        eventName: "movie event india ",
                                        price: 2000,
                                        dateTime: DateTime.now(),
                                        type: ProductType.newsPaper),
                                  );
                                },
                                child: Text("add Event")),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  ProductEventProvider.deleteLastNewsPaperEvent('The Hindu');
                                },
                                child: Text("delete Event"))
                          ],
                        ))
                  ],
                );
              },
            ));
      },
    );
  }
}
