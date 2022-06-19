import 'dart:html';

import 'package:ad/widgets/top_bar_contents.dart';
import 'package:flutter/material.dart';

import '../../widgets/bottom_bar.dart';
import '../../widgets/menu_drawer.dart';

class billBoard extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _billBoardState createState() => _billBoardState();
}

class _billBoardState extends State<billBoard> {
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

  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    _opacity = _scrollPosition < screenSize.height * 0.40
        ? _scrollPosition / (screenSize.height * 0.40)
        : 1;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: screenSize.width < 800
            ? AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                elevation: 0,
                backgroundColor:
                    const Color.fromARGB(255, 0, 0, 0).withOpacity(_opacity),
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
                child: TopBarContents(_opacity),
              ),
        drawer: const MenuDrawer(),
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
