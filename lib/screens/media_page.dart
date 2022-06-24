import 'package:ad/media/media_data.dart';
import 'package:ad/media/media_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../calendar/calendar.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({Key? key}) : super(key: key);

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  @override
  Widget build(BuildContext context) {
    MediaData mediaData = MediaData(mediaName: "media name 1");
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
              child: ListView(
                children: [
                  MediaTile(mediaData: mediaData),
                  MediaTile(mediaData: mediaData),
                  MediaTile(mediaData: mediaData)
                ],
              )
          ),
          Expanded(
            flex: 3,
              child: Container(
                child: Calendar.getCalenderWidget(),
              ))
        ],
      ),

    );
  }
}
