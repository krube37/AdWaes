import 'package:flutter/material.dart';

class HomeBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int index) onItemTapped;

  const HomeBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  State<HomeBottomNavigationBar> createState() => _HomeBottomNavigationBarState();
}

class _HomeBottomNavigationBarState extends State<HomeBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.selectedIndex,
      onTap: (index)=> widget.onItemTapped.call(index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), label: 'Favourite'),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Account'),
      ],
    );
  }
}
