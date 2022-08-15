import 'package:ad/routes/route_delegate.dart';
import 'package:ad/routes/route_parser.dart';
import 'package:flutter/material.dart';
import 'package:ad/globals.dart';

import '../routes/routes.dart';
import 'home_page.dart';

class AdWaesApp extends StatefulWidget {
  const AdWaesApp({super.key});

  @override
  State<AdWaesApp> createState() => _AdWaesAppState();
}

class _AdWaesAppState extends State<AdWaesApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Adwisor',
      theme: defaultTheme,
      debugShowCheckedModeBanner: false,
      routerDelegate: RouteDelegate(),
      routeInformationParser: RouteParser(),
      builder: (context, child) => child!,
    );
  }
}
