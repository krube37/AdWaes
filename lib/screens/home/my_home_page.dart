library home_page;

import 'dart:math';
import 'package:ad/globals.dart';
import 'package:ad/screens/home/my_app_bar.dart';
import 'package:ad/screens/product_widgets/bottombar.dart';
import 'package:ad/screens/productscreens/product_page.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../firebase/firestore_database.dart';
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
  List<MapEntry<ProductData, ProductEvent>> dataToEventsMap = [];
  bool isRecentEventsFetched = false;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    //todo: test code
    ProductData data = ProductData(
        userName: 'username_${const Uuid().v1()}',
        name: '${ProductType.tvChannel.name} ${Random().nextInt(100)}',
        totalEvents: 15,
        description: 'this is product data description string ',
        type: ProductType.tvChannel);

    var productEvent = ProductEvent(
        eventId: const Uuid().v1(),
        eventName: "${ProductType.tvChannel.name} event ${Random().nextInt(100)}",
        description: 'this is description',
        price: 2000,
        eventTime: DateTime.now(),
        postedTime: DateTime.now(),
        type: ProductType.tvChannel,
        productId: data.userName);

    if (dataToEventsMap.isEmpty && !isRecentEventsFetched) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        dataToEventsMap = await FirestoreDatabase().getRecentEventsWithProductsName();
        if(mounted) setState(() => isRecentEventsFetched = true);
      });
    }

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
                _CustomHorizontalScroller(
                  itemLength: dataToEventsMap.length,
                  height: 400,
                  scrollingArrowSize: 50.0,
                  scrollPixelsPerClick: (screenSize.width / 300) * 200,
                  //todo : implement loading before fetching
                  itemBuilder: (index) {
                    return dataToEventsMap.isNotEmpty
                        ? ProductEventTile(
                            index: index,
                            event: dataToEventsMap[index].value,
                            productData: dataToEventsMap[index].key,
                            tileWidth: 300,
                          )
                        : const SizedBox(
                            width: 100,
                            height: 100,
                            child: Text('some error is there'),
                          );
                  },
                ),
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
