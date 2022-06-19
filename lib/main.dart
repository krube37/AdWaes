import 'dart:js';

import 'package:ad/screens/productscreens/billBoard.dart';
import 'package:ad/screens/second_page.dart';
import 'package:flutter/material.dart';

import 'screens/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        '/': (context) => HomePage(),
        '/BillBoard': (context) => billBoard(),
        '/Newspaper': (context) => SecondScreen(),
        '/Media': (context) => SecondScreen(),
        '/Streaming': (context) => SecondScreen(),
        '/SocialMedia': (context) => SecondScreen(),
      },
      //home: HomePage(),
    );
  }
}
