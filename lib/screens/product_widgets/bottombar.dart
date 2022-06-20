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

      child: MediaQuery.of(context).size.width < 800
          ? Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    BottomBarColumn(
                      heading: 'ABOUT',
                      s1: 'contact Us',
                      s2: 'about Us',
                      s3: 'careers',
                    ),
                    BottomBarColumn(
                      heading: 'Help',
                      s1: 'payment',
                      s2: 'cancellation',
                      s3: 'fAQ',
                    ),
                    BottomBarColumn(
                      heading: 'SOCIAL',
                      s1: 'twitter',
                      s2: 'facebook',
                      s3: 'youtube',
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 10,
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
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Copyright © 2021 | Adwisor',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const BottomBarColumn(
                      heading: 'ABOUT',
                      s1: 'contact Us',
                      s2: 'about us',
                      s3: 'careers',
                    ),
                    const BottomBarColumn(
                      heading: 'Help',
                      s1: 'payment',
                      s2: 'cancellation',
                      s3: 'fAQ',
                    ),
                    const BottomBarColumn(
                      heading: 'SOCIAL',
                      s1: 'twitter',
                      s2: 'facebook',
                      s3: 'youtube',
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
