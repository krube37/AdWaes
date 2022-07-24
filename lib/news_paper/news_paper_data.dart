import 'package:ad/news_paper/news_paper_event.dart';

class NewsPaper {
  String name;
  String? description;
  List<NewsPaperEvent> events;

  NewsPaper({required this.name, this.description, this.events = const []});

  factory NewsPaper.fromFirestore(Map json) => NewsPaper(name: json['name'], description: json['description']);

  get map => {
        'name': name,
        'description': description,
        'totalEvents': events.length,
      };
}
