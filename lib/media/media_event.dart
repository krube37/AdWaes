import 'package:ad/event.dart';

class MediaEvent extends Event {

  final String eventName;

  MediaEvent(this.eventName, {required dateTime}) : super(dateTime: dateTime);
}
