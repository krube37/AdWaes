import 'dart:math';

import 'package:ad/media/media_data.dart';
import 'package:ad/media/media_event.dart';
import 'package:ad/media/media_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../calendar/calendar.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({Key? key}) : super(key: key);

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  @override
  Widget build(BuildContext context) {
    List<MediaData> mediaData = [
      MediaData(mediaName: "media name 1", slots: [MediaEvent("event name 1", dateTime: DateTime(2022, 6, 25, 10))]),
      MediaData(mediaName: "media name 2"),
      MediaData(mediaName: "media name 3")
    ];
    return Scaffold(
        body: ScreenTypeLayout(
      desktop: _MediaPageDesktop(mediaDataList: mediaData),
      mobile: _MediaPageMobile(
        mediaDataList: mediaData,
      ),
    ));
  }
}

class _MediaPageDesktop extends StatefulWidget {
  List<MediaData> mediaDataList;
  int? selectedIndex;

  _MediaPageDesktop({Key? key, required this.mediaDataList}) : super(key: key);

  @override
  State<_MediaPageDesktop> createState() => _MediaPageDesktopState();
}

class _MediaPageDesktopState extends State<_MediaPageDesktop> {
  bool _showHoursPage = false;
  DateTime _dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Material(
              color: Colors.grey.shade200,
              child: ListView.builder(
                  itemCount: widget.mediaDataList.length,
                  itemBuilder: (context, index) => MediaTile(
                      mediaData: widget.mediaDataList[index],
                      onClick: () {
                        setState(() {
                          widget.selectedIndex = index;
                        });
                      },
                      isTileSelected: widget.selectedIndex == index)),
            )),
        Expanded(
          flex: 3,
          child: widget.selectedIndex != null
              ? _showHoursPage
                  ? CalendarDay(
                      onBackPressed: backFromHoursPage,
                      dateTime: _dateTime,
                      mediaEvent: widget.selectedIndex != null ? widget.mediaDataList[widget.selectedIndex!].slots: null,
                    )
                  : SingleChildScrollView(
                      child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraint) {
                          return Container(
                            child: widget.selectedIndex != null
                              ? Calendar.getCalenderWidget(
                                constraint.maxWidth - (constraint.maxWidth / 6), constraint.maxHeight,
                                onModeChanged: onModeChanged,
                                dateTime: _dateTime,
                                mediaData: widget.mediaDataList[widget.selectedIndex!])
                              : null,
                          );
                        },
                      ),
                    )
              : const SizedBox(),
        )
      ],
    );
  }

  void onModeChanged(bool showHoursPage, DateTime dateTime) async {
    setState(() {
      _showHoursPage = showHoursPage;
      _dateTime = dateTime;
    });
  }

  void backFromHoursPage() {
    setState(() {
      _showHoursPage = false;
    });
  }
}

class _MediaPageMobile extends StatelessWidget {
  List<MediaData> mediaDataList;

  _MediaPageMobile({Key? key, required this.mediaDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        MediaTile(mediaData: mediaDataList[0], isTileSelected: false),
        MediaTile(
          mediaData: mediaDataList[1],
          isTileSelected: false,
        ),
        MediaTile(
          mediaData: mediaDataList[2],
          isTileSelected: false,
        )
      ],
    );
  }
}
