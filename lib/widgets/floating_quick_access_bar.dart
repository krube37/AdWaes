import 'package:ad/widgets/responsive.dart';
import 'package:flutter/material.dart';

import '../product/product_type.dart';
import '../routes/route_page_manager.dart';

class FloatingQuickAccessBar extends StatefulWidget {
  const FloatingQuickAccessBar({
    Key? key,
    required this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  @override
  // ignore: library_private_types_in_public_api
  _FloatingQuickAccessBarState createState() => _FloatingQuickAccessBarState();
}

class _FloatingQuickAccessBarState extends State<FloatingQuickAccessBar> {
  final List _isHovering = [false, false, false, false, false, false, false, false, false];
  List<Widget> rowElements = [];

  List<ProductType> items = ProductType.values;
  List<IconData> icons = [Icons.location_on, Icons.date_range, Icons.people, Icons.wb_sunny];

  List<Widget> generateRowElements() {
    rowElements.clear();
    for (int i = 0; i < items.length; i++) {
      Widget elementTile = InkWell(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onHover: (value) {
          setState(() {
            value ? _isHovering[i] = true : _isHovering[i] = false;
          });
        },
        onTap: () => PageManager.of(context).navigateToProduct(items[i]),
        child: Text(
          items[i].getDisplayName(),
          style: TextStyle(
            color: _isHovering[i] ? Colors.blueGrey[900] : Colors.blueGrey,
          ),
        ),
      );
      Widget spacer = SizedBox(
        height: widget.screenSize.height / 20,
        child: VerticalDivider(
          width: 1,
          color: Colors.blueGrey[100],
          thickness: 1,
        ),
      );
      rowElements.add(elementTile);
      if (i < items.length - 1) {
        rowElements.add(spacer);
      }
    }

    return rowElements;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Center(
        heightFactor: 1,
        child: Padding(
          padding: EdgeInsets.only(
            top: widget.screenSize.height * 0.60,
            left: ResponsiveWidget.isSmallScreen(context) ? widget.screenSize.width / 12 : widget.screenSize.width / 5,
            right: ResponsiveWidget.isSmallScreen(context) ? widget.screenSize.width / 12 : widget.screenSize.width / 5,
          ),
          child: widget.screenSize.width < 800
              ? Column(
                  children: [
                    for (int i = 0; i < items.length; i++)
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: widget.screenSize.height / 55,
                        ),
                        child: Card(
                            elevation: 4,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: widget.screenSize.height / 45,
                                bottom: widget.screenSize.height / 45,
                              ),
                              child: Row(children: [
                                SizedBox(
                                  width: widget.screenSize.width / 50,
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  onHover: (value) {
                                    setState(() {
                                      value ? _isHovering[i] = true : _isHovering[i] = false;
                                    });
                                  },
                                  onTap: () => PageManager.of(context).navigateToProduct(items[i]),
                                  child: Text(
                                    items[i].getDisplayName(),
                                    style: TextStyle(
                                      color: _isHovering[i] ? Colors.blueGrey[900] : Colors.blueGrey,
                                    ),
                                  ),
                                ),
                              ]),
                            )),
                      )
                  ],
                )
              : Card(
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: widget.screenSize.height / 50,
                      bottom: widget.screenSize.height / 50,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //children: generateRowElements(),
                      children: [
                        for (int i = 0; i < items.length; i++)
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: widget.screenSize.height / 55,
                            ),
                            child: Card(
                                elevation: 4,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: widget.screenSize.height / 45,
                                    bottom: widget.screenSize.height / 45,
                                  ),
                                  child: Row(children: [
                                    SizedBox(
                                      width: widget.screenSize.width / 50,
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      onHover: (value) {
                                        setState(() {
                                          value ? _isHovering[i] = true : _isHovering[i] = false;
                                        });
                                      },
                                      onTap: () => PageManager.of(context).navigateToProduct(items[i]),
                                      child: Text(
                                        items[i].getDisplayName(),
                                        style: TextStyle(
                                          color: _isHovering[i] ? Colors.blueGrey[900] : Colors.blueGrey,
                                        ),
                                      ),
                                    ),
                                  ]),
                                )),
                          )
                      ],
                    ),
                  )),
        ),
      ),
    );
  }
}
