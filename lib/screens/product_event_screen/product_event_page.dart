library product_event_page;

import 'dart:math';

import 'package:ad/adwise_user.dart';
import 'package:ad/constants.dart';
import 'package:ad/firebase/firestore_manager.dart';
import 'package:ad/globals.dart';
import 'package:ad/product/product_event.dart';
import 'package:ad/routes/my_route_delegate.dart';
import 'package:ad/screens/home/my_app_bar.dart';
import 'package:ad/screens/sign_in/sign_in_card.dart';
import 'package:ad/widgets/primary_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../widgets/custom_sliver.dart';

part 'product_event_helper_widgets.dart';

class ProductEventPage extends StatelessWidget {
  final ProductEvent _event;

  const ProductEventPage({Key? key, required ProductEvent event})
      : _event = event,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isMobileView(context)) return const Center(child: Text("Mobile view"));

    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: const MyAppBar(),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: maxScreenWidth,
          ),
          child: CustomSliver(
            leftSideWidget: _EventImageWidget(event: _event),
            rightSideWidget: _EventContentWidget(event: _event),
            leftSideWidth: (min(screenSize.width, maxScreenWidth)) * 0.40,
            rightSideWidth: (min(screenSize.width, maxScreenWidth)) * 0.60,
          ),
        ),
      ),
    );
  }
}
