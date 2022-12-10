import 'package:ad/provider/data_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/globals.dart';

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
  late DataManager dataManager;

  @override
  void didChangeDependencies() {
    dataManager = Provider.of<DataManager>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider = dataManager.user?.proPicImageProvider;
    return BottomNavigationBar(
      currentIndex: widget.selectedIndex,
      onTap: (index) => widget.onItemTapped.call(index),
      iconSize: 30.0,
      unselectedFontSize: 0.0,
      selectedFontSize: 0.0,
      items: [
        const BottomNavigationBarItem(
          icon: SizedBox(
            height: 28.0,
            child: Icon(Icons.home),
          ),
          label: '',
        ),
        const BottomNavigationBarItem(
          icon: SizedBox(
            height: 28.0,
            child: Icon(Icons.favorite_outline),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
            icon: imageProvider != null
                ? Container(
                    height: 30.0,
                    width: 30.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.0),
                        border: Border.all(
                          color: widget.selectedIndex == 2 ? primaryColor : Colors.grey,
                          width: 2,
                        )),
                    child: CircleAvatar(
                      backgroundImage: dataManager.user!.proPicImageProvider,
                    ),
                  )
                : const Icon(Icons.account_circle_outlined),
            label: ''),
      ],
    );
  }
}
