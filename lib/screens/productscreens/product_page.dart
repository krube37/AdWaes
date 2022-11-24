library product_page;

import 'dart:math';

import 'package:ad/adwise_user.dart';
import 'package:ad/utils/constants.dart';
import 'package:ad/firebase/firestore_manager.dart';
import 'package:ad/utils/globals.dart';
import 'package:ad/helper/custom_icons.dart';
import 'package:ad/product/product_data.dart';
import 'package:ad/provider/data_manager.dart';
import 'package:ad/screens/home/my_app_bar.dart';
import 'package:ad/screens/sign_in/sign_in_card.dart';
import 'package:ad/widgets/underlined_text_clicker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../product/product_event.dart';
import '../../product/product_type.dart';
import '../../provider/product_data_provider.dart';
import '../../routes/route_page_manager.dart';

part 'product_page_helper_widgets.dart';

class ProductPage extends StatefulWidget {
  final ProductType productType;
  final String? currentUserName;

  ProductPage({
    Key? key,
    required this.productType,
    this.currentUserName,
  }) : super(key: key) {
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
      products.update(
        element.userName,
        (value) => element,
        ifAbsent: () => element,
      );
    }
    if (products.isNotEmpty) {
      if (products.values.map((e) => e.userName).contains(widget.currentUserName)) {
        currentUserName = widget.currentUserName!;
      } else {
        currentUserName = products.values.first.userName;
      }
    }
    if (!_isListeningToEvent) {
      productDataProvider.listenToProductData(widget.productType);
      _isListeningToEvent = true;
    }

    if (currentUserName.isNotEmpty && widget.currentUserName == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Future.delayed(const Duration(seconds: 2))
            .then((value) => PageManager.of(context).navigateToCompany(widget.productType, currentUserName));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Consumer<ProductDataProvider>(
        builder: (context, productDataValue, _) {
          _fetchData();

          //todo: remove test code.
          if (products.isEmpty) {
            return Center(
              child: ElevatedButton(
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
                          eventTime: DateTime.now(),
                          postedTime: DateTime.now(),
                          type: widget.productType,
                          productId: data.userName),
                    ];
                    ProductDataProvider.addProductData(data, events, widget.productType);
                  },
                  child: const Text("Add")),
            );
          }

          return Container(
            constraints: const BoxConstraints(
              maxWidth: maxScreenWidth,
            ),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 30.0,
                    ),
                    const Expanded(
                      child: Text(
                        'Events',
                        style: TextStyle(
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        children: const [
                          Text(
                            'Sort by',
                          ),
                          Icon(Icons.arrow_drop_down)
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: _productListView(),
                      ),
                      const Divider(
                        color: Colors.black45,
                        thickness: 1.0,
                        height: 100,
                      ),
                      Expanded(
                        flex: 3,
                        child: products.isEmpty || currentUserName.isEmpty
                            ? const Center(child: Text("there are no Events available or selected "))
                            : StreamBuilder<List<ProductEvent>>(
                                stream: productDataProvider.listenToEvents(currentUserName),
                                builder: (context, snapshot) {
                                  events.clear();
                                  debugPrint(
                                      "_ProductPageState build: snapshot ${snapshot.data?.map((e) => e.eventId)}");
                                  if (!snapshot.hasData ||
                                      (snapshot.data != null && snapshot.data!.isEmpty) ||
                                      widget.currentUserName == null) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  events = snapshot.data!;
                                  return GridView.builder(
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: isDesktopView(context) ? 3 : 2,
                                        childAspectRatio: isDesktopView(context) ? 3 / 4 : 3 / 4,
                                      ),
                                      itemCount: events.length,
                                      itemBuilder: (context, index) {
                                        return EventTile(
                                          event: events[index],
                                          showProductHeader: false,
                                          productData: products[currentUserName],
                                        );
                                      });
                                }),
                      ),
                      // todo: remove test code
                      // _testCode()
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  _productListView() => ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        ProductData currentProductData = products.values.toList()[index];
        return _ProductTile(
            productData: currentProductData,
            isTileSelected: currentUserName == currentProductData.userName,
            onClick: () {
              if (currentUserName == currentProductData.userName) return;
              currentUserName = currentProductData.userName;
              _isListeningToEvent = false;
              debugPrint("_ProductPageState _productListView: success for new model ");
              PageManager.of(context).navigateToCompany(widget.productType, currentUserName);
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
                      eventTime: DateTime.now(),
                      postedTime: DateTime.now(),
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
                      eventTime: DateTime.now(),
                      postedTime: DateTime.now(),
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
