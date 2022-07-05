import 'package:ad/media/media_event.dart';

class MediaData {
  String mediaName;
  int totalEvents;
  List<MediaEvent> events;

  MediaData({required this.mediaName, this.totalEvents = 0, this.events = const []});
}
