library home_page;

import 'package:ad/constants.dart';
import 'package:ad/globals.dart';
import 'package:ad/screens/home/my_app_bar.dart';
import 'package:ad/screens/product_widgets/bottombar.dart';
import 'package:flutter/material.dart';

import '../../firebase/firestore_database.dart';
import '../../product/product_data.dart';
import '../../routes/my_route_delegate.dart';

part 'home_helper_widgets.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MyAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            _ProductsMenu(),
            SizedBox(height: 400.0,),
            BottomBar(),
          ],
        ),
      ),
    );
  }
}
