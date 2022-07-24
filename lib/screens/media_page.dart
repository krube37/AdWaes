import 'package:ad/media/media_data.dart';
import 'package:ad/media/media_event.dart';
import 'package:ad/media/media_tile.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../widgets/top_bar_contents.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({Key? key}) : super(key: key);

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  @override
  Widget build(BuildContext context) {
    List<MediaData> mediaData = [
      MediaData(mediaName: "media name 1", events: getTestEvents()),
      MediaData(mediaName: "media name 2"),
      MediaData(mediaName: "media name 3")
    ];
    return ScreenTypeLayout(
      desktop: _MediaPageDesktop(mediaDataList: mediaData),
      mobile: _MediaPageMobile(mediaDataList: mediaData),
    );
  }
}

List<MediaEvent> getTestEvents() {
  List<MediaEvent> events = [];
  for (int i = 0; i < 50; i++) {
    events.add(MediaEvent("event name $i", dateTime: DateTime(2022, 6, 25, 10)));
  }
  return events;
}

class _MediaPageDesktop extends StatefulWidget {
  final List<MediaData> mediaDataList;

  const _MediaPageDesktop({
    Key? key,
    required this.mediaDataList,
  }) : super(key: key);

  @override
  State<_MediaPageDesktop> createState() => _MediaPageDesktopState();
}

class _MediaPageDesktopState extends State<_MediaPageDesktop> {
  int? selectedIndex;
  int cursorIndex = -1;

  @override
  Widget build(BuildContext context) {
    List<MediaEvent>? events;
    if (selectedIndex != null) {
      events = widget.mediaDataList[selectedIndex!].events;
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 100),
        child: const TopBarContents(),
      ),
      body: Row(
        children: [
          Expanded(
              flex: 1,
              child: Material(
                color: Colors.grey.shade200,
                child: ListView.builder(
                    itemCount: widget.mediaDataList.length,
                    itemBuilder: (context, index) => MediaTile(
                          mediaData: widget.mediaDataList[index],
                          isTileSelected: index == selectedIndex,
                          onClick: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                        )),
              )),
          Expanded(
              flex: 3,
              child: events != null
                  ? GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3/2,
                      ),
                      itemCount: events.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: MouseRegion(
                          onEnter: (_) => setState(() => cursorIndex = index),
                          onExit: (_) => setState(() => cursorIndex = -1),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: Colors.grey.shade400,
                                  width: 0.5,
                                )),
                            elevation: cursorIndex == index ? 10 : 0,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                child: Center(child: Text(events![index].eventName)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const Center(
                      child: Text(
                        "nothing selected",
                      ),
                    ))
        ],
      ),
    );
  }
}

class _MediaPageMobile extends StatefulWidget {
  final List<MediaData> mediaDataList;

  const _MediaPageMobile({Key? key, required this.mediaDataList}) : super(key: key);

  @override
  State<_MediaPageMobile> createState() => _MediaPageMobileState();
}

class _MediaPageMobileState extends State<_MediaPageMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: const Text(
          'Adwisor',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 24,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.bold,
            //letterSpacing: 3,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.mediaDataList.length,
        itemBuilder: (context, index) => MediaTile(mediaData: widget.mediaDataList[index], onClick: () {}),
      ),
    );
  }
}
