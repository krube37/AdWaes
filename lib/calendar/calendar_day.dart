part of 'calendar.dart';

class CalendarDay extends StatelessWidget {
  final Function onBackPressed;
  final DateTime dateTime;
  final List<Event>? mediaEvent;

  const CalendarDay({Key? key, required this.onBackPressed, required this.dateTime, this.mediaEvent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int hours = 24;
    List<Event>? eventsOnThisDay = mediaEvent != null ? mediaEvent!.map((e) => e).toList() : null;
    List<int>? eventHoursOnThisDay = eventsOnThisDay?.map((e) => e.dateTime.hour).toList();
    String formattedDate = DateFormat('MMMM dd yyyy').format(dateTime);
    return Column(
      children: [
        Material(
          elevation: 2,
          child: Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(15),
                child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () {
                      onBackPressed.call();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.grey,
                      ),
                    )),
              ),
              Expanded(
                  child: Center(
                child: Text(formattedDate),
              ))
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
              child: Column(
            children: [
              for (int i = 0; i < hours; i++)
                Row(
                  key: UniqueKey(),
                  children: [
                    Container(
                      width: 50,
                      child: Center(child: Text("${i < 10 ? '0$i' : i}:00")),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 100, top: 10, bottom: 10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {},
                          child: Container(
                            height: 100,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 0.2,
                                ),
                              ),
                            ),
                            child: eventHoursOnThisDay != null && eventHoursOnThisDay.contains(i)
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.lightBlue,
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            ],
          )),
        )
      ],
    );
  }
}
