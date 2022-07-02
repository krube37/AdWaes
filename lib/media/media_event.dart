import 'package:ad/event.dart';

class MediaEvent extends Event {
  final DateTime dateTime;
  final String eventName;

  MediaEvent(this.eventName, {required this.dateTime}) : super(dateTime: dateTime);
}
