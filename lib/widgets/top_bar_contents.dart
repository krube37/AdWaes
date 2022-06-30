import 'package:flutter/material.dart';

class TopBarContents extends StatefulWidget {
  final double opacity;

  const TopBarContents({this.opacity = 1});

  @override
  _TopBarContentsState createState() => _TopBarContentsState();
}

class _TopBarContentsState extends State<TopBarContents> {
  final List _isHovering = [false, false, false, false, false, false, false, false];

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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: screenSize.width / 20,
                  ),
                  const Text(
                    'Adwisor',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 48,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.bold,
                      //letterSpacing: 3,
                    ),
                  ),
                  SizedBox(width: screenSize.width / 30),
                  InkWell(
                    onHover: (value) {
                      setState(() {
                        value ? _isHovering[2] = true : _isHovering[2] = false;
                      });
                    },
                    onTap: () {},
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'LogIn',
                          style: TextStyle(
                              color: _isHovering[2]
                                  ? const Color.fromARGB(255, 255, 255, 255)
                                  : const Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        //const SizedBox(height: 5),
                        SizedBox(
                          width: screenSize.width / 50,
                        ),
                        Visibility(
                          maintainAnimation: true,
                          maintainState: true,
                          maintainSize: true,
                          visible: _isHovering[2],
                          child: Container(
                            height: 2,
                            width: 20,
                            color: const Color(0xFF051441),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: screenSize.width / 50,
                  ),
                  //SizedBox(width: screenSize.width / 55),
                  InkWell(
                    onHover: (value) {
                      setState(() {
                        value ? _isHovering[3] = true : _isHovering[3] = false;
                      });
                    },
                    onTap: () {},
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'SignUp',
                          style: TextStyle(
                              color: _isHovering[3]
                                  ? const Color.fromARGB(255, 255, 255, 255)
                                  : const Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        //const SizedBox(height: 5),
                        SizedBox(width: screenSize.width / 20),
                        Visibility(
                          maintainAnimation: true,
                          maintainState: true,
                          maintainSize: true,
                          visible: _isHovering[3],
                          child: Container(
                            height: 2,
                            width: 20,
                            color: const Color(0xFF051441),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
