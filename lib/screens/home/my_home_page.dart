library home_page;

import 'dart:math';
import 'package:ad/product/product_data.dart';
import 'package:ad/utils/globals.dart';
import 'package:ad/provider/data_manager.dart';
import 'package:ad/screens/home/my_app_bar.dart';
import 'package:ad/widgets/bottombar.dart';
import 'package:ad/screens/productscreens/product_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../firebase/firestore_manager.dart';
import '../../general_settings.dart';
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
  late ScrollController scrollController;
  double appBarElevation = 0;
  double appBarColorOpacity = 0.0;

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      double pixel = scrollController.position.pixels;
      if (appBarColorOpacity > 0 && appBarColorOpacity < 1) {
        setState(() {
          appBarColorOpacity = min(pixel / 65, 1.0);
        });
      } else if (appBarColorOpacity == 0.0 && pixel > 0.0) {
        setState(() => appBarColorOpacity = min(pixel / 65, 1.0));
      } else if (appBarColorOpacity == 1.0 && pixel < 65) {
        setState(() => appBarColorOpacity = min(pixel / 65, 1.0));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<DataManager>(context);

    if (isMobileView(context)) {
      return SafeArea(
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              MobileSliverAppbar(),
              SliverToBoxAdapter(
                child: _getBody(),
              )
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: MyAppBar(
        elevation: appBarElevation,
        colorOpacity: appBarColorOpacity,
      ),
      body: SingleChildScrollView(
        controller: scrollController,
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
    double eventTileHeight = isMobileView(context) ? 350 : 420;
    double eventTileWidth = isMobileView(context) ? 220 : 300;

    double listIconViewPadding = isMobileView(context) ? 0 : 60.0;
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
        const Divider(),
        const Padding(
          padding: EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 30.0,
          ),
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
                List<MapEntry<ProductEvent, ProductData>> recentEventsToDataEntryList = snapshot.data!;

                if (recentEventsToDataEntryList.isEmpty) {
                  return const Center(
                    child: Text('No events Available'),
                  );
                }
                return _CustomHorizontalScroller(
                  itemLength: recentEventsToDataEntryList.length,
                  height: eventTileHeight,
                  scrollingArrowSize: 50.0,
                  alignItemBuilder: Alignment.centerLeft,
                  scrollPixelsPerClick: (screenSize.width / eventTileWidth) * (eventTileWidth / 1.3),
                  itemBuilder: (index) => EventTile(
                    event: recentEventsToDataEntryList[index].key,
                    productData: recentEventsToDataEntryList[index].value,
                    tileWidth: eventTileWidth,
                  ),
                );
              } else {
                int noOfEmptyEvents = (screenSize.width / (eventTileWidth + 40)).ceil();
                return SizedBox(
                  height: eventTileHeight,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: noOfEmptyEvents,
                    itemBuilder: (context, index) {
                      return EventTile(
                        event: null,
                        productData: null,
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
