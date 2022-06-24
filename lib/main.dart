import 'dart:js';

import 'package:ad/routes/rotes.dart';
import 'package:ad/screens/productscreens/billBoard.dart';
import 'package:ad/screens/second_page.dart';
import 'package:flutter/material.dart';

import 'screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}
