import 'package:ad/media/media_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../calendar/calendar.dart';

class MediaTile extends StatelessWidget {
  final MediaData mediaData;
  Function()? onClick;
  Function(bool haveState, DateTime? date)? onDialogStateChanged;

  bool isTileSelected;

  MediaTile({Key? key, required this.mediaData, this.onClick, this.isTileSelected = false, this.onDialogStateChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceScreenType screenType = getDeviceType(MediaQuery.of(context).size);
    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        onTap: () async {
          onClick?.call();
          if (screenType != DeviceScreenType.desktop) {
            await _showCalendarDialog(context, onDialogStateChanged, mediaData);
          }
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: (isTileSelected) ? Colors.lightBlue.shade200 : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  mediaData.mediaName,
                  overflow: TextOverflow.ellipsis,
                )),
                Text(
                  mediaData.availableSlots.toString(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _showCalendarDialog(
      BuildContext context, Function(bool haveState, DateTime? date)? onDialogStateChanged, MediaData mediaData) async {
    onDialogStateChanged?.call(true, null);
    DateTime? date = await Calendar.showDatePickerDialog(
      context,
      DateTime.now(),
      mediaData,
    );
    onDialogStateChanged?.call(false, date);
    debugPrint('_BaseWidgetState._showCalendarDialog: pickedDate: $date');
  }
}
