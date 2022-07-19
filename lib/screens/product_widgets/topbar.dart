import 'package:flutter/material.dart';

class TopBar extends StatefulWidget {
  final double opacity;

  const TopBar(this.opacity);

  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  final List _isHovering = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Container(
      color: const Color.fromARGB(255, 0, 0, 0).withOpacity(widget.opacity),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              //width: screenSize.width / 20,
              height: screenSize.height / 5,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: screenSize.width / 20,
                  ),
                  const Text(
                    'Adwisor',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 48,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.bold,
                      //letterSpacing: 3,
                    ),
                  ),
                  SizedBox(width: screenSize.width / 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
