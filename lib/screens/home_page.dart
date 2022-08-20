import 'package:ad/constants.dart';
import 'package:ad/widgets/bottom_bar.dart';
import 'package:ad/widgets/carousel.dart';
import 'package:ad/widgets/featured_heading.dart';
import 'package:ad/widgets/featured_tiles.dart';
import 'package:ad/widgets/floating_quick_access_bar.dart';
import 'package:ad/widgets/main_heading.dart';
import 'package:ad/widgets/menu_drawer.dart';
import 'package:ad/widgets/top_bar_contents.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class HomePage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();

  const HomePage({super.key});
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
    _opacity = _scrollPosition < screenSize.height * 0.40 ? _scrollPosition / (screenSize.height * 0.40) : 1;

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: screenSize.width < 800
            ? AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                elevation: 0,
                backgroundColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(_opacity),
                title: const Text(
                  'Adwisor',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 24,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.bold,
                    //letterSpacing: 3,
                  ),
                ),
              )
            : PreferredSize(
                preferredSize: Size(screenSize.width, 150),
                child: TopBarContents(opacity: _opacity),
              ),
        drawer: const MenuDrawer(),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: screenSize.height * 0.65,
                    width: screenSize.width,
                    child: Image.asset(
                      '../assets/images/sample3.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    children: [
                      FloatingQuickAccessBar(
                        screenSize: screenSize,
                      ),
                      FeaturedHeading(screenSize: screenSize),
                      FeaturedTiles(screenSize: screenSize),
                      MainHeading(screenSize: screenSize),
                      const MainCarousel(),
                      SizedBox(height: screenSize.height / 10),
                      const BottomBar()
                    ],
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
