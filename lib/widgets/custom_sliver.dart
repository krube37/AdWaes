import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import 'bottombar.dart';

class CustomSliver extends StatefulWidget {
  final Widget leftSideWidget, rightSideWidget;
  final double leftSideWidth, rightSideWidth;

  const CustomSliver({
    Key? key,
    required this.leftSideWidget,
    required this.rightSideWidget,
    required this.leftSideWidth,
    required this.rightSideWidth,
  }) : super(key: key);

  @override
  State<CustomSliver> createState() => _CustomSliverState();
}

class _CustomSliverState extends State<CustomSliver> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverStickyHeader.builder(
          overlapsContent: true,
          builder: (context, state) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                margin: const EdgeInsets.only(bottom: 20.0),
                width: widget.leftSideWidth,
                child: widget.leftSideWidget,
              ),
            );
          },
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 1,
              (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  color: Colors.white,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.all(30.0),
                      width: widget.rightSideWidth,
                      child: widget.rightSideWidget,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: BottomBar(),
        ),
      ],
    );
  }
}
