import 'package:ad/media/media_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

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
        onTap: () {},
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
}
