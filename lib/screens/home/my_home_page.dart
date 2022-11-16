library home_page;

import 'dart:math';
import 'package:ad/utils/globals.dart';
import 'package:ad/provider/data_manager.dart';
import 'package:ad/screens/home/my_app_bar.dart';
import 'package:ad/widgets/bottombar.dart';
import 'package:ad/screens/productscreens/product_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../firebase/firestore_manager.dart';
import '../../product/product_event.dart';
import '../../product/product_type.dart';
import '../../routes/route_page_manager.dart';

part 'home_helper_widgets.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Provider.of<DataManager>(context);

    if (isMobileView(context)) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            MobileAppbar(),
            SliverToBoxAdapter(
              child: _getBody(),
            )
          ],
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MyAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: LayoutBuilder(builder: (context, constraints) {
            return _getBody();
          }),
        ),
      ),
    );
  }

  Widget _getBody() {
    Size screenSize = MediaQuery.of(context).size;
    double listIconViewPadding = isMobileView(context) ? 0 : 60.0;
    double eventTileHeight = isMobileView(context) ? 300 : 400;
    double eventTileWidth = isMobileView(context) ? 220 : 300;

    double listIconTileWidth = 116; // refer [_ProductListIconTile]
    double listIconTileHeight = 100.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: listIconViewPadding),
          child: _CustomHorizontalScroller(
            itemLength: ProductType.values.length,
            itemBuilder: (index) => _ProductListIconTile(type: ProductType.values[index]),
            height: listIconTileHeight,
            scrollingArrowSize: 33,
            scrollPixelsPerClick:
                ((screenSize.width - (2 * listIconViewPadding)) / listIconTileWidth) * (listIconTileWidth / 1.3),
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
            future: FirestoreManager().getRecentEvents(),
            initialData: null,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<ProductEvent> recentEvents = snapshot.data!;
                return _CustomHorizontalScroller(
                  itemLength: recentEvents.length,
                  height: eventTileHeight,
                  scrollingArrowSize: 50.0,
                  alignItemBuilder: Alignment.centerLeft,
                  scrollPixelsPerClick: (screenSize.width / eventTileWidth) * (eventTileWidth / 1.3),
                  itemBuilder: (index) {
                    return recentEvents.isNotEmpty
                        ? ProductEventTile(
                            index: index,
                            event: recentEvents[index],
                            tileWidth: eventTileWidth,
                          )
                        : // todo: handle error
                        const SizedBox(
                            width: 100,
                            height: 100,
                            child: Text('some error is there'),
                          );
                  },
                );
              } else {
                int noOfEmptyEvents = (screenSize.width / (eventTileWidth + 40)).ceil();
                return SizedBox(
                  height: eventTileHeight,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: noOfEmptyEvents,
                    itemBuilder: (context, index) {
                      return ProductEventTile(
                        index: index,
                        event: null,
                        isLoading: true,
                        tileWidth: eventTileWidth,
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
  }
}
