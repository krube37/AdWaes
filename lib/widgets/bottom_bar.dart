import 'package:ad/widgets/bottom_bar_column.dart';
import 'package:ad/widgets/info_text.dart';
import 'package:ad/widgets/responsive.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    Key? key,
  }) : super(key: key);
  static const Color gradientStartColor = Color.fromARGB(255, 0, 0, 0);
  static const Color gradientEndColor = Color.fromARGB(255, 0, 0, 0);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(0.0)),
          /*gradient: LinearGradient(
            colors: [gradientStartColor, gradientEndColor],
            begin: FractionalOffset(0.2, 0.2),
            end: FractionalOffset(1.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),*/
          color: Colors.black),
      padding: const EdgeInsets.all(30),
      //color: Colors.blueGrey[900],
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const BottomBarColumn(
                heading: 'ABOUT',
                s1: 'Contact Us',
                s2: 'About Us',
                s3: 'Careers',
              ),
              const BottomBarColumn(
                heading: 'Help',
                s1: 'Payment',
                s2: 'Cancellation',
                s3: 'FAQ',
              ),
              const BottomBarColumn(
                heading: 'SOCIAL',
                s1: 'Twitter',
                s2: 'Facebook',
                s3: 'Youtube',
              ),
              Container(
                color: Colors.white,
                width: 2,
                height: 150,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoText(
                    type: 'Email',
                    text: 'customercare@adwisor.com',
                  ),
                  const SizedBox(height: 5),
                  InfoText(
                    type: 'Address',
                    text: 'Kent Mahal 😂',
                  )
                ],
              ),
            ],
          ),
          const Divider(
            color: Colors.white,
          ),
          const SizedBox(height: 20),
          const Text(
            'Copyright © 2021 | Adwisor',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
