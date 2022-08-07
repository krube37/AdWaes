import 'dart:math';

import 'package:ad/constants.dart';
import 'package:ad/globals.dart';
import 'package:ad/product/product_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../product/product_event.dart';
import '../../product/product_tile.dart';
import '../../provider/product_data_provider.dart';

class ProductPage extends StatefulWidget {
  final ProductType productType;

  const ProductPage({Key? key, required this.productType}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int cursorIndex = -1;
  int selectedIndex = 0;
  List<ProductData> products = [];
  List<ProductEvent> events = [];
  late ProductDataProvider productDataProvider;
  bool _isListeningToEvent = false;

  @override
  void initState() {
    print("_ProductPageState initState: ");
    productDataProvider = ProductDataProvider();
    super.initState();
  }

  @override
  void dispose() {
    print("_ProductPageState dispose: ");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    products = productDataProvider.products;

    return FutureBuilder(
      future: productDataProvider.getProductData(type: widget.productType),
      builder: (BuildContext context, AsyncSnapshot<List<ProductData>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Could not load Page!'),
          );
        }
        products = snapshot.data!;
        print("_ProductPageState build: checkzzz snapshot ${snapshot.data}");

        //todo: remove test code.
        if (products.isEmpty) {
          return ElevatedButton(
              onPressed: () {
                List<ProductEvent> events = [
                  ProductEvent(
                      eventName: "${widget.productType.name} event ${Random().nextInt(100)}",
                      price: 2000,
                      dateTime: DateTime.now(),
                      type: widget.productType),
                ];
                ProductDataProvider.addProductData(
                    ProductData(
                        name: '${widget.productType.name} ${Random().nextInt(100)}',
                        totalEvents: 15,
                        description: 'this is product data description string ',
                        type: widget.productType),
                    events,
                    widget.productType);
              },
              child: Text("Add"));
        }

        return Scaffold(
          appBar: getAppBar(MediaQuery.of(context).size),
          body: Consumer<ProductDataProvider>(
            builder: (context, newsPaperValue, _) {
              productDataProvider = Provider.of<ProductDataProvider>(context);
              products = productDataProvider.products;
              print("_ProductPageState build: checkzzz products in cunsumer ${productDataProvider.products.map((e) => e.name)}");
              events = productDataProvider.productEvents;

              if (!_isListeningToEvent) {
                productDataProvider.listenToEvents(widget.productType, products[selectedIndex].name);
                productDataProvider.listenToProductData(widget.productType);
                _isListeningToEvent = true;
              }
              return Column(
                children: [
                  Center(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.productType.getDisplayName(),
                          style: const TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
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
                              : events.isEmpty
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
                                                      decoration:
                                                          BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                                      child: Center(child: Text(events[index].eventName)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
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
                                        eventName: "${widget.productType.name} event ${Random().nextInt(100)}",
                                        price: 2000,
                                        dateTime: DateTime.now(),
                                        type: widget.productType),
                                  ];

                                  ProductDataProvider.addProductData(
                                      ProductData(
                                          name: '${widget.productType.name} ${Random().nextInt(100)}',
                                          totalEvents: 15,
                                          description: 'this is product data description string ',
                                          type: widget.productType),
                                      events,
                                      widget.productType);
                                },
                                child: Text("Add")),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  ProductDataProvider.removeNewsPaperData(
                                      products[selectedIndex].name, widget.productType);
                                },
                                child: Text("delete")),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  ProductDataProvider.addNewsPaperEvent(
                                    '${products[selectedIndex].name}',
                                    ProductEvent(
                                        eventName: "${widget.productType.name} event ${Random().nextInt(100)}",
                                        price: 2000,
                                        dateTime: DateTime.now(),
                                        type: widget.productType),
                                  );
                                },
                                child: Text("add Event")),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  ProductDataProvider.deleteLastNewsPaperEvent(products[selectedIndex].name);
                                },
                                child: Text("delete Event"))
                          ],
                        ))
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }
}
