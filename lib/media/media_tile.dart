import 'package:ad/media/media_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../calendar/calendar.dart';

class MediaTile extends StatelessWidget {
  final MediaData mediaData;

  const MediaTile({Key? key, required this.mediaData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        _showCalendarDialog(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
        child: Row(
          children: [
            Expanded(child: Text(mediaData.mediaName)),
            Text(mediaData.availableSlots.toString())
          ],
        ),
      ),
    );
  }

  void _showCalendarDialog(BuildContext context) async {
    DateTime? date = await Calendar.showDatePickerDialog(
      context,
      DateTime.now(),
    );
    debugPrint('_BaseWidgetState._showCalendarDialog: pickedDate: $date');
  }
}
