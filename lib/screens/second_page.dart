import 'package:flutter/material.dart';
import 'package:ad/widgets/carousel.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                child: SizedBox(
                  height: screenSize.height * 0.65,
                  width: screenSize.width,
                  child: Image.asset(
                    '../assets/images/sample3.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(height: screenSize.height / 10),
                  const MainCarousel(),
                  SizedBox(height: screenSize.height / 10),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
