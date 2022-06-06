import 'package:ad/widgets/bottom_bar.dart';
import 'package:ad/widgets/carousel.dart';
import 'package:ad/widgets/featured_heading.dart';
import 'package:ad/widgets/featured_tiles.dart';
import 'package:ad/widgets/floating_quick_access_bar.dart';
import 'package:ad/widgets/main_heading.dart';
import 'package:ad/widgets/menu_drawer.dart';
import 'package:ad/widgets/top_bar_contents.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0;
  double _opacity = 0;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    _opacity = _scrollPosition < screenSize.height * 0.40
        ? _scrollPosition / (screenSize.height * 0.40)
        : 1;

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size(screenSize.width, 150),
          child: TopBarContents(_opacity),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    child: SizedBox(
                      height: screenSize.height * 0.65,
                      width: screenSize.width,
                      child: Image.asset(
                        '../assets/images/sample3.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      FloatingQuickAccessBar(screenSize: screenSize),
                      FeaturedHeading(screenSize: screenSize),
                      FeaturedTiles(screenSize: screenSize),
                      MainHeading(screenSize: screenSize),
                      MainCarousel(),
                      SizedBox(height: screenSize.height / 10),
                      BottomBar()
                    ],
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
