import 'package:ad/main.dart';
import 'package:ad/routes/rotes.dart';
import 'package:ad/screens/home_page.dart';
import 'package:ad/screens/second_page.dart';
import 'package:ad/widgets/responsive.dart';
import 'package:flutter/material.dart';

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
  final List _isHovering = [false, false, false, false, false];
  List<Widget> rowElements = [];

  List<String> items = [
    'BillBoard',
    'Media',
    'Newspaper',
    'Streaming',
    'SocialMedia'
  ];
  List<IconData> icons = [
    Icons.location_on,
    Icons.date_range,
    Icons.people,
    Icons.wb_sunny
  ];

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
        onTap: () {
          if (items[i] == "BillBoard") {
            Navigator.pushNamed(context, Routes.BILL_BOARD);
          } else if (items[i] == "Newspaper") {
            Navigator.pushNamed(context, Routes.NEWS_PAPER);
          } else if (items[i] == "Media") {
            Navigator.pushNamed(context, Routes.MEDIA);
          } else if (items[i] == "Streaming") {
            Navigator.pushNamed(context, Routes.BILL_BOARD);
          } else if (items[i] == "SocialMedia") {
            Navigator.pushNamed(context, Routes.BILL_BOARD);
          }
        },
        child: Text(
          items[i],
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
    return Center(
      heightFactor: 1,
      child: Padding(
        padding: EdgeInsets.only(
          top: widget.screenSize.height * 0.60,
          left: ResponsiveWidget.isSmallScreen(context)
              ? widget.screenSize.width / 12
              : widget.screenSize.width / 5,
          right: ResponsiveWidget.isSmallScreen(context)
              ? widget.screenSize.width / 12
              : widget.screenSize.width / 5,
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
                                    value
                                        ? _isHovering[i] = true
                                        : _isHovering[i] = false;
                                  });
                                },
                                onTap: () {
                                  if (items[i] == "BillBoard") {
                                    Navigator.pushNamed(context, '/BillBoard');
                                  } else if (items[i] == "Newspaper") {
                                    Navigator.pushNamed(context, '/Newspaper');
                                  } else if (items[i] == "Media") {
                                    Navigator.pushNamed(context, '/Media');
                                  } else if (items[i] == "Streaming") {
                                    Navigator.pushNamed(context, '/BillBoard');
                                  } else if (items[i] == "SocialMedia") {
                                    Navigator.pushNamed(context, '/BillBoard');
                                  }
                                },
                                child: Text(
                                  items[i],
                                  style: TextStyle(
                                    color: _isHovering[i]
                                        ? Colors.blueGrey[900]
                                        : Colors.blueGrey,
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
                                        value
                                            ? _isHovering[i] = true
                                            : _isHovering[i] = false;
                                      });
                                    },
                                    onTap: () {
                                      if (items[i] == "BillBoard") {
                                        Navigator.pushNamed(
                                            context, '/BillBoard');
                                      } else if (items[i] == "Newspaper") {
                                        Navigator.pushNamed(
                                            context, '/Newspaper');
                                      } else if (items[i] == "Media") {
                                        Navigator.pushNamed(context, '/Media');
                                      } else if (items[i] == "Streaming") {
                                        Navigator.pushNamed(
                                            context, '/BillBoard');
                                      } else if (items[i] == "SocialMedia") {
                                        Navigator.pushNamed(
                                            context, '/BillBoard');
                                      }
                                    },
                                    child: Text(
                                      items[i],
                                      style: TextStyle(
                                        color: _isHovering[i]
                                            ? Colors.blueGrey[900]
                                            : Colors.blueGrey,
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
    );
  }
}
