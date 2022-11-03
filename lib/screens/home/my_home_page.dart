library home_page;

import 'dart:math';
import 'package:ad/globals.dart';
import 'package:ad/screens/home/my_app_bar.dart';
import 'package:ad/screens/product_widgets/bottombar.dart';
import 'package:ad/screens/productscreens/product_page.dart';
import 'package:flutter/material.dart';

import '../../firebase/firestore_manager.dart';
import '../../product/product_data.dart';
import '../../product/product_event.dart';
import '../../product/product_type.dart';
import '../../routes/my_route_delegate.dart';

part 'home_helper_widgets.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MyAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60.0),
                  child: _CustomHorizontalScroller(
                    itemLength: ProductType.values.length,
                    itemBuilder: (index) => _ProductListViewTile(type: ProductType.values[index]),
                    height: 100.0,
                    scrollingArrowSize: 33,
                    scrollPixelsPerClick: ((screenSize.width - 120.0) / 116) * 70,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                  child: Text(
                    "Recent Events",
                    style: TextStyle(fontSize: 25.0),
                  ),
                ),
                FutureBuilder(
                    future: FirestoreManager().getRecentEventsWithProductsName(),
                    initialData: null,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<MapEntry<ProductData, ProductEvent>> recentProductDataToEventsMap = snapshot.data!;
                        return _CustomHorizontalScroller(
                          itemLength: recentProductDataToEventsMap.length,
                          height: 400,
                          scrollingArrowSize: 50.0,
                          scrollPixelsPerClick: (screenSize.width / 300) * 200,
                          itemBuilder: (index) {
                            return recentProductDataToEventsMap.isNotEmpty
                                ? ProductEventTile(
                                    index: index,
                                    event: recentProductDataToEventsMap[index].value,
                                    productData: recentProductDataToEventsMap[index].key,
                                    tileWidth: 300,
                                  )
                                : const SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Text('some error is there'),
                                  );
                          },
                        );
                      } else {
                        int noOfEmptyEvents = (screenSize.width / 340).ceil();
                        return SizedBox(
                          height: 400,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: noOfEmptyEvents,
                            itemBuilder: (context, index) {
                              return ProductEventTile(
                                index: index,
                                event: null,
                                productData: null,
                                isLoading: true,
                                tileWidth: 300,
                              );
                            },
                          ),
                        );
                      }
                    }),
                const SizedBox(height: 50.0),
                const BottomBar(),
              ],
            );
          }),
        ),
      ),
    );
  }
}
