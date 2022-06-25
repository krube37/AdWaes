import 'package:ad/media/media_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../calendar/calendar.dart';

class MediaTile extends StatelessWidget {
  final MediaData mediaData;
  Function()? onClick;
  bool isTileSelected;

  MediaTile({Key? key, required this.mediaData, this.onClick, required this.isTileSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceScreenType screenType = getDeviceType(MediaQuery.of(context).size);
    return Padding(
      padding: EdgeInsets.all(5),
      child: InkWell(
        onTap: (){
          onClick?.call();
          if(screenType != DeviceScreenType.desktop){
            _showCalendarDialog(context);
          }
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ( isTileSelected) ? Colors.lightBlue.shade200 : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
            child: Row(
              children: [
                Expanded(child: Text(mediaData.mediaName, overflow: TextOverflow.ellipsis,)),
                Text(mediaData.availableSlots.toString(),)
              ],
            ),
          ),
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
