

import 'package:ad/news_paper/news_paper_data.dart';
import 'package:flutter/material.dart';

class NewsPaperTile extends StatelessWidget {
  final NewsPaper newsPaper;
  final Function()? onClick;
  final bool isTileSelected;

  const NewsPaperTile({Key? key, required this.newsPaper, this.onClick, this.isTileSelected = false})
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
            color: (isTileSelected) ? Colors.purple.shade200 : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                      newsPaper.name,
                      overflow: TextOverflow.ellipsis,
                    )),
                Text(
                  newsPaper.events.length.toString(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
