import 'package:ad/media/media_data.dart';
import 'package:flutter/material.dart';

class MediaTile extends StatelessWidget {
  final MediaData mediaData;
  final Function()? onClick;
  final bool isTileSelected;

  const MediaTile({Key? key, required this.mediaData, this.onClick, this.isTileSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          onClick?.call();
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
                  mediaData.totalEvents.toString(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
