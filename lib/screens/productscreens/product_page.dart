import 'dart:math';

import 'package:ad/constants.dart';
import 'package:ad/globals.dart';
import 'package:ad/product/product_data.dart';
import 'package:ad/routes/my_route_delegate.dart';
import 'package:ad/screens/home/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../product/product_event.dart';
import '../../product/product_tile.dart';
import '../../provider/product_data_provider.dart';

class ProductPage extends StatefulWidget {
  final ProductType productType;
  final List<ProductData> products;
  final String currentUserName;

  ProductPage({Key? key, required this.productType, required this.products, required this.currentUserName})
      : super(key: key) {
    debugPrint("ProductPage ProductPage: constructor called..............................   ");
  }

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String currentUserName = '';
  Map<String, ProductData> products = {};
  List<ProductEvent> events = [];
  late ProductDataProvider productDataProvider;
  bool _isListeningToEvent = false;

  @override
  void initState() {
    debugPrint("_ProductPageState initState: ");
    productDataProvider = ProductDataProvider();
    super.initState();
  }

  @override
  void dispose() {
    debugPrint("_ProductPageState dispose: ");
    super.dispose();
  }

  void _fetchData() {
    productDataProvider = Provider.of<ProductDataProvider>(context);
    for (var element in productDataProvider.products) {
      products.update(element.userName, (value) => element, ifAbsent: () => element);
    }
    if (!_isListeningToEvent && currentUserName.isNotEmpty) {
      productDataProvider.listenToProductData(widget.productType);
      _isListeningToEvent = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    for (var element in widget.products) {
      products.update(element.userName, (value) => element, ifAbsent: () => element);
    }
    currentUserName = widget.currentUserName;
    var screenSize = MediaQuery.of(context).size;

    //todo: remove test code.
    if (products.isEmpty) {
      return ElevatedButton(
          onPressed: () {
            ProductData data = ProductData(
                userName: 'username_${const Uuid().v1()}',
                name: '${widget.productType.name} ${Random().nextInt(100)}',
                totalEvents: 15,
                description: 'this is product data description string ',
                type: widget.productType);
            List<ProductEvent> events = [
              ProductEvent(
                  eventId: const Uuid().v1(),
                  eventName: "${widget.productType.name} event ${Random().nextInt(100)}",
                  description: 'this is description',
                  price: 2000,
                  dateTime: DateTime.now(),
                  type: widget.productType,
                  productId: data.userName),
            ];
            ProductDataProvider.addProductData(data, events, widget.productType);
          },
          child: const Text("Add"));
    }

    return Scaffold(
      appBar: const MyAppBar(),
      body: Consumer<ProductDataProvider>(
        builder: (context, productDataValue, _) {
          _fetchData();
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
                      child: _productListView(),
                    ),
                    Expanded(
                      flex: 3,
                      child: products.isEmpty || currentUserName.isEmpty
                          ? const Center(child: Text("there are no Events available or selected "))
                          : StreamBuilder<List<ProductEvent>>(
                              stream: productDataProvider.listenToEvents(widget.productType, currentUserName),
                              builder: (context, snapshot) {
                                events.clear();
                                debugPrint("_ProductPageState build: snapshot ${snapshot.data?.map((e) => e.eventId)}");
                                if (!snapshot.hasData || (snapshot.data != null && snapshot.data!.isEmpty)) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                events = snapshot.data!;
                                return GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: isDesktopView(screenSize) ? 2 : 1,
                                      childAspectRatio: isDesktopView(screenSize) ? 3 / 2 : 6,
                                    ),
                                    itemCount: events.length,
                                    itemBuilder: (context, index) {
                                      return _ProductEventTile(
                                        index: index,
                                        event: events[index],
                                        productData: products[currentUserName]!,
                                      );
                                    });
                              }),
                    ),
                    // todo: remove test code
                    _testCode()
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  _productListView() => ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        ProductData currentProductData = products.values.toList()[index];
        return ProductTile(
            productData: currentProductData,
            isTileSelected: currentUserName == currentProductData.userName,
            onClick: () {
              if (currentUserName == currentProductData.userName) return;
              currentUserName = currentProductData.userName;
              _isListeningToEvent = false;
              debugPrint("_ProductPageState _productListView: success for new model ");
              MyRouteDelegate.of(context)
                  .navigateToCompany(widget.productType, products.values.toList(), currentUserName);
            });
      });

  _testCode() => Expanded(
          child: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                ProductData data = ProductData(
                    userName: 'username_${const Uuid().v1()}',
                    name: '${widget.productType.name} ${Random().nextInt(100)}',
                    totalEvents: 15,
                    description: 'this is product data description string ',
                    type: widget.productType);

                List<ProductEvent> events = [
                  ProductEvent(
                      eventId: const Uuid().v1(),
                      eventName: "${widget.productType.name} event ${Random().nextInt(100)}",
                      description: 'this is description',
                      price: 2000,
                      dateTime: DateTime.now(),
                      type: widget.productType,
                      productId: data.userName),
                ];

                ProductDataProvider.addProductData(data, events, widget.productType);
              },
              child: const Text("Add")),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                ProductDataProvider.removeProductData(currentUserName, widget.productType);
              },
              child: const Text("delete")),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                ProductDataProvider.addProductEvent(
                  currentUserName,
                  ProductEvent(
                      eventId: const Uuid().v1(),
                      eventName: "${widget.productType.name} event ${Random().nextInt(100)}",
                      description: 'this is description',
                      price: 2000,
                      dateTime: DateTime.now(),
                      type: widget.productType,
                      productId: currentUserName),
                );
              },
              child: const Text("add Event")),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                ProductDataProvider.deleteLastProductEvent(currentUserName, widget.productType);
              },
              child: const Text("delete Event"))
        ],
      ));
}

class _ProductEventTile extends StatefulWidget {
  final int index;
  final ProductEvent event;
  final ProductData productData;

  const _ProductEventTile({Key? key, required this.index, required this.event, required this.productData})
      : super(key: key);

  @override
  State<_ProductEventTile> createState() => _ProductEventTileState();
}

class _ProductEventTileState extends State<_ProductEventTile> {
  int cursorIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: MouseRegion(
        onEnter: (_) => setState(() => cursorIndex = widget.index),
        onExit: (_) => setState(() => cursorIndex = -1),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: Colors.grey.shade400,
                width: 0.5,
              )),
          elevation: cursorIndex == widget.index ? 10 : 0,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () => MyRouteDelegate.of(context)
                .navigateToProductEventPage(widget.event.type, widget.productData.userName, widget.event),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Center(child: Text(widget.event.eventName)),
            ),
          ),
        ),
      ),
    );
  }
}
