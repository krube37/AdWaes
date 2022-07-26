import 'package:ad/globals.dart';
import 'package:ad/news_paper/news_paper_data.dart';
import 'package:ad/news_paper/news_paper_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../news_paper/news_paper_event.dart';
import '../../provider/news_paper_provider.dart';

class NewsPapersPage extends StatefulWidget {
  const NewsPapersPage({Key? key}) : super(key: key);

  @override
  State<NewsPapersPage> createState() => _NewsPapersPageState();
}

class _NewsPapersPageState extends State<NewsPapersPage> {
  int cursorIndex = -1;
  int selectedIndex = 0;
  List<NewsPaper> newsPapers = [];
  late NewsPaperEventProvider newsPaperEventProvider;
  late NewsPaperProvider newsPaperProvider;
  bool _isListeningToEvent = false;

  @override
  void didChangeDependencies() {
    newsPaperProvider =  NewsPaperProvider();
    newsPaperEventProvider = NewsPaperEventProvider();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    NewsPaperEventProvider.disposeProvider();
    NewsPaperProvider.disposeProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    if (newsPapers.isNotEmpty) {
      _isListeningToEvent = true;
      newsPaperEventProvider.listenToEvents(newsPapers[selectedIndex].name);
    }
    newsPapers = newsPaperProvider.newsPapers;

    return Scaffold(
        appBar: getAppBar(MediaQuery.of(context).size),
        body: Consumer<NewsPaperProvider>(
          builder: (context, newsPaperValue, _) {
            if (!_isListeningToEvent) {
              newsPaperEventProvider.listenToEvents(newsPapers[selectedIndex].name);
              _isListeningToEvent = true;
            }
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                      itemCount: newsPapers.length,
                      itemBuilder: (context, index) {
                        return NewsPaperTile(
                            newsPaper: newsPapers[index],
                            isTileSelected: selectedIndex == index,
                            onClick: () {
                              if (selectedIndex == index) return;
                              setState(() {
                                selectedIndex = index;
                                _isListeningToEvent = false;
                              });
                            });
                      }),
                ),
                Expanded(
                  flex: 3,
                  child: newsPapers.isEmpty
                      ? const Center(
                          child: Text("there are no Events available "),
                        )
                      : Consumer<NewsPaperEventProvider>(builder: (_, newsPaperValue, child) {
                          List<NewsPaperEvent> events = Provider.of<NewsPaperEventProvider>(context).newsPaperEvents;
                          print("_NewsPapersPageState build: checkzzz events ${events.length}");
                          return events.isEmpty
                              //todo: do something here because if is empty, then will always show circular progress
                              ? const Center(child: CircularProgressIndicator())
                              : GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: isDesktopView(screenSize) ? 2 : 1,
                                    childAspectRatio: isDesktopView(screenSize) ? 3 / 2 : 6,
                                  ),
                                  itemCount: events.length,
                                  itemBuilder: (context, index) {
                                    return StatefulBuilder(
                                      builder: (BuildContext context, void Function(void Function()) setState) {
                                        return Padding(
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
                                                  child: Center(child: Text(events[index].eventName)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  });
                        }),
                ),
                // todo: remove test code
                Expanded(
                    child: Column(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          List<NewsPaperEvent> events = [
                            NewsPaperEvent("movie event india ", "left corner", 2000, 4, DateTime.now()),
                            // NewsPaperEvent("Function event india ", "center", 10000, 1, dateTime: DateTime.now()),
                            // NewsPaperEvent("scientific event ", "top center", 5000, 5, dateTime: DateTime.now())
                          ];
                          List<NewsPaper> newsPapers = [
                            NewsPaper(name: 'The Hindu', events: events),
                            NewsPaper(name: 'The New York Times', events: events),
                            NewsPaper(name: 'The Times of India', events: events),
                          ];
                          NewsPaperEventProvider.addNewsPaperData(
                            NewsPaper(name: 'The Hindu', events: events),
                          );
                        },
                        child: Text("Add")),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          NewsPaperEventProvider.removeNewsPaperData('The Hindu');
                        },
                        child: Text("delete")),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          NewsPaperEventProvider.addNewsPaperEvent(
                              'The Hindu', NewsPaperEvent("scientific event ", "top center", 5000, 5, DateTime.now()));
                        },
                        child: Text("add Event")),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          NewsPaperEventProvider.deleteLastNewsPaperEvent('The Hindu');
                        },
                        child: Text("delete Event"))
                  ],
                ))
              ],
            );
          },
        ));
  }
}
