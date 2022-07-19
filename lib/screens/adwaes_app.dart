import 'package:flutter/material.dart';

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
    return MaterialApp(
        title: 'Flutter Web',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        // initialRoute: "/home",
        onGenerateRoute: Routes.onGenerateRoute,
        home:HomePage());
  }
}
