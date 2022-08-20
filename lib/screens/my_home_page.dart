import 'package:ad/constants.dart';
import 'package:ad/globals.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Adwise',
            style: TextStyle(
              color: primaryColor,
              fontSize: 30.0,
              fontFamily: 'Ubuntu',
            ),
          ),
          toolbarHeight: 75.0,
          backgroundColor: Colors.white,
        ),
        body: const _ProductsMenu());
  }
}

class _ProductsMenu extends StatefulWidget {
  const _ProductsMenu({Key? key}) : super(key: key);

  @override
  State<_ProductsMenu> createState() => _ProductsMenuState();
}

class _ProductsMenuState extends State<_ProductsMenu> {
  bool disableBackScroll = true, disableForwardScroll = false;
  double initialScrollOffset = 0.0;
  late ScrollController _controller;

  @override
  Widget build(BuildContext context) {
    _controller = ScrollController(initialScrollOffset: initialScrollOffset);

    return Container(
      //color: Colors.red,
      height: 95.0,
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        children: [
          disableBackScroll
              ? const SizedBox(
                  width: 50.0,
                  height: 50.0,
                )
              : InkWell(
                  borderRadius: BorderRadius.circular(25.0),
                  onTap: _moveBackward,
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    // color: Colors.blue,
                    padding: const EdgeInsets.all(8.0),
                    child: const Icon(Icons.navigate_before),
                  ),
                ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  debugPrint("_MyHomePageState build: constraints ${constraints.maxWidth}");
                  return ListView.builder(
                    controller: _controller,
                    scrollDirection: Axis.horizontal,
                    itemCount: ProductType.values.length,
                    itemBuilder: (context, index) => _ProductListViewTile(type: ProductType.values[index]),
                  );
                },
              ),
            ),
          ),
          disableForwardScroll
              ? const SizedBox(
                  width: 50.0,
                  height: 50.0,
                )
              : InkWell(
                  borderRadius: BorderRadius.circular(25.0),
                  onTap: _moveForward,
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    // color: Colors.blue,
                    padding: const EdgeInsets.all(8.0),
                    child: const Icon(Icons.navigate_next),
                  ),
                ),
        ],
      ),
    );
  }

  _moveForward() {
    debugPrint(
        "_MyHomePageState _moveForward: max scroll ${_controller.position.extentBefore} ${_controller.position.extentAfter}");
    _controller
        .animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 700),
      curve: Curves.fastOutSlowIn,
    )
        .then((value) {
      debugPrint(
          "_ScrollButtonState _moveForward: forward ${_controller.position.extentAfter}  ${_controller.position.maxScrollExtent} ");
      if (_controller.position.extentAfter == 0) {
        setState(() {
          disableForwardScroll = true;
          disableBackScroll = false;
          initialScrollOffset = _controller.offset;
        });
      }
    });
  }

  _moveBackward() {
    _controller
        .animateTo(
      _controller.position.minScrollExtent,
      duration: const Duration(milliseconds: 700),
      curve: Curves.fastOutSlowIn,
    )
        .then((value) {
      if (_controller.position.extentBefore == 0) {
        setState(() {
          disableForwardScroll = false;
          disableBackScroll = true;
          initialScrollOffset = _controller.offset;
        });
      }
    });
  }
}

class _ProductListViewTile extends StatefulWidget {
  final ProductType type;

  const _ProductListViewTile({Key? key, required this.type}) : super(key: key);

  @override
  State<_ProductListViewTile> createState() => _ProductListViewTileState();
}

class _ProductListViewTileState extends State<_ProductListViewTile> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: SizedBox(
        width: 100.0,
        child: InkWell(
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {},
          child: Column(
            children: [
              Icon(
                widget.type.getIcon(),
                color: isHovering ? primaryColor : Colors.black,
              ),
              Text(
                widget.type.getDisplayName(),
                style: TextStyle(color: isHovering ? primaryColor : Colors.black),
              ),
              const SizedBox(
                height: 5.0,
              ),
              isHovering
                  ? Container(
                      width: 30.0,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1.5, color: isHovering ? primaryColor : Colors.black),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

// todo : implement faded end widget
// class _FadedEndListView extends StatelessWidget {
//   final ListView listView;
//
//   const _FadedEndListView({Key? key, required this.listView}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: AlignmentDirectional.centerStart,
//       children: [
//         Positioned(
//           left: 0,
//           width: 50.0,
//           height: 80.0,
//           child: Container(
//             width: 50.0,
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.centerLeft,
//                 end: Alignment.centerRight,
//                 stops: [0.0, 1.0],
//                 colors: [
//                   Color.fromARGB(255, 255, 255, 255),
//                   //Color.fromARGB(0, 255, 255, 255),
//                   Colors.red
//                   //Color.fromARGB(0, 255, 255, 255)
//                 ],
//               ),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 0.0),
//           child: listView,
//         ),
//         Positioned(
//           right: 0,
//           width: 50.0,
//           height: 50.0,
//           child: Container(
//             width: 50.0,
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.centerLeft,
//                 end: Alignment.centerRight,
//                 stops: [0.0, 1.0],
//                 colors: [
//                  Colors.red,
//                   Colors.red
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
