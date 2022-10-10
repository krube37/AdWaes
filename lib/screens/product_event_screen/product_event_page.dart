library product_event_page;

import 'dart:math';

import 'package:ad/adwise_user.dart';
import 'package:ad/constants.dart';
import 'package:ad/firebase/firestore_database.dart';
import 'package:ad/globals.dart';
import 'package:ad/product/product_event.dart';
import 'package:ad/screens/home/my_app_bar.dart';
import 'package:ad/screens/product_widgets/bottombar.dart';
import 'package:ad/screens/sign_in/sign_in_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:intl/intl.dart';

part 'product_event_helper_widgets.dart';

class ProductEventPage extends StatelessWidget {
  final ProductEvent _event;

  const ProductEventPage({Key? key, required ProductEvent event})
      : _event = event,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isMobileView(context)) return const Center(child: Text("Mobile view"));

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: const MyAppBar(),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: maxScreenWidth,
          ),
          child: _CustomSliver(
            eventImageWidget: _EventImageWidget(event: _event),
            eventContentWidget: _EventContentWidget(event: _event),
          ),
        ),
      ),
    );
  }

}

class _CustomSliver extends StatefulWidget {
  final Widget eventImageWidget, eventContentWidget;

  const _CustomSliver({
    Key? key,
    required this.eventImageWidget,
    required this.eventContentWidget,
  }) : super(key: key);

  @override
  State<_CustomSliver> createState() => _CustomSliverState();
}

class _CustomSliverState extends State<_CustomSliver> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        for (int i = 0; i < 2; i++)
          SliverStickyHeader.builder(
            overlapsContent: true,
            builder: (context, state) {
              return i == 0 ? widget.eventImageWidget : const SizedBox();
            },
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: 1,
                (context, index) {
                  return i == 0 ? widget.eventContentWidget : const BottomBar();
                },
              ),
            ),
          ),
      ],
    );
  }
}
