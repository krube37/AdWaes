library product_event_page;

import 'dart:math';

import 'package:ad/adwise_user.dart';
import 'package:ad/utils/constants.dart';
import 'package:ad/firebase/firestore_manager.dart';
import 'package:ad/utils/globals.dart';
import 'package:ad/product/product_event.dart';
import 'package:ad/screens/home/my_app_bar.dart';
import 'package:ad/screens/productscreens/product_page.dart';
import 'package:ad/screens/sign_in/sign_in_card.dart';
import 'package:ad/widgets/primary_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../routes/route_page_manager.dart';
import '../../widgets/custom_sliver.dart';

part 'product_event_helper_widgets.dart';

class ProductEventPage extends StatelessWidget {
  final String _eventId;

  const ProductEventPage({Key? key, required String eventId})
      : _eventId = eventId,
        super(key: key);

  @override
  Widget build(BuildContext context) {


    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: isMobileView(context) ? const MobileAppBar(text: 'Put some name',) : const MyAppBar(),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: maxScreenWidth,
          ),
          child: FutureBuilder(
            future: _getProductEvent(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'no even available',
                  ),
                );
              }

              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              ProductEvent event = snapshot.data!;
              if(isMobileView(context)){
                return _MobileView(event: event,);
              }
              return CustomSliver(
                leftSideWidget: _EventImageWidget(event: event),
                rightSideWidget: _EventContentWidget(event: event),
                leftSideWidth: (min(screenSize.width, maxScreenWidth)) * 0.40,
                rightSideWidth: (min(screenSize.width, maxScreenWidth)) * 0.60,
              );
            },
          ),
        ),
      ),
    );
  }

  Future<ProductEvent?> _getProductEvent() async {
    ProductEvent? event = await FirestoreManager().getEventById(_eventId);
    if(event != null) return event;

    throw Exception('no Event Available');
  }
}
