library bottom_bar;

import 'package:ad/theme_manager.dart';
import 'package:flutter/material.dart';

part 'bottom_bar_helper_widgets.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeManager themeManager = ThemeManager();
    ThemeData theme = Theme.of(context);
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(0.0)),
        //color: themeManager.isDarkTheme ? Colors.black87 : Colors.grey.shade100,
      ),
      padding: const EdgeInsets.all(30),
      //color: Colors.blueGrey[900],

      child: MediaQuery.of(context).size.width < 800
          ? Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    _BottomBarColumn(
                      heading: 'ABOUT',
                      s1: 'contact Us',
                      s2: 'about Us',
                      s3: 'careers',
                    ),
                    _BottomBarColumn(
                      heading: 'Help',
                      s1: 'payment',
                      s2: 'cancellation',
                      s3: 'fAQ',
                    ),
                    _BottomBarColumn(
                      heading: 'SOCIAL',
                      s1: 'twitter',
                      s2: 'facebook',
                      s3: 'youtube',
                    ),
                  ],
                ),
                Divider(
                  color: themeManager.isDarkTheme ? Colors.white54 : Colors.black54,
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _InfoText(
                      type: 'Email',
                      text: 'customercare@adwisor.com',
                    ),
                    SizedBox(height: 5),
                    _InfoText(
                      type: 'Address',
                      text: 'Kent Mahal 😂',
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Divider(
                  color: themeManager.isDarkTheme ? Colors.white54 : Colors.black54,
                ),
                const SizedBox(height: 20),
                Text(
                  'Copyright © 2021 | Adwisor',
                  style: theme.textTheme.headline5?.copyWith(fontSize: 14.0),
                ),
              ],
            )
          : Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const _BottomBarColumn(
                      heading: 'ABOUT',
                      s1: 'contact Us',
                      s2: 'about us',
                      s3: 'careers',
                    ),
                    const _BottomBarColumn(
                      heading: 'Help',
                      s1: 'payment',
                      s2: 'cancellation',
                      s3: 'fAQ',
                    ),
                    const _BottomBarColumn(
                      heading: 'SOCIAL',
                      s1: 'twitter',
                      s2: 'facebook',
                      s3: 'youtube',
                    ),
                    Container(
                      color: Colors.black87,
                      width: 2,
                      height: 150,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _InfoText(
                          type: 'Email',
                          text: 'customercare@adwisor.com',
                        ),
                        SizedBox(height: 5),
                        _InfoText(
                          type: 'Address',
                          text: 'Kent Mahal 😂',
                        )
                      ],
                    ),
                  ],
                ),
                Divider(
                  color: themeManager.isDarkTheme ? Colors.white54 : Colors.black54,
                ),
                const SizedBox(height: 20),
                Text(
                  'Copyright © 2021 | Adwisor',
                  style: theme.textTheme.headline5?.copyWith(fontSize: 14.0),
                ),
              ],
            ),
    );
  }
}
